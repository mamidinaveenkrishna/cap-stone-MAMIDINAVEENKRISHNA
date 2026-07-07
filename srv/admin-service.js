const cds = require('@sap/cds');
const { SELECT, INSERT, UPDATE } = cds.ql;

module.exports = cds.service.impl(async function () {

    const { Vendors, Invoices, InvoiceItems, ApprovalHistory } = this.entities;

    const bp = await cds.connect.to('API_BUSINESS_PARTNER');

    this.before(['CREATE', 'UPDATE', 'PATCH'], InvoiceItems, async (req) => {

        const item = req.data;

        if (Number(item.quantity) <= 0) {
            req.error(400, "Quantity must be greater than 0");
        }

        if (Number(item.unitPrice) <= 0) {
            req.error(400, "Unit Price must be greater than 0");
        }

        if (item.quantity != null && item.unitPrice != null) {
            item.totalAmount = Number(item.quantity) * Number(item.unitPrice);
        }

    });

    this.after(['CREATE', 'UPDATE', 'DELETE'], 'InvoiceItems', async (data, req) => {

        const invoiceID =
            req.data.invoice_ID ||
            req.data.invoice?.ID ||
            data?.invoice_ID;

        if (!invoiceID) return;

        const items = await SELECT.from(InvoiceItems)
            .where({ invoice_ID: invoiceID });

        const total = items.reduce(
            (sum, i) => sum + (Number(i.quantity) * Number(i.unitPrice)),
            0
        );

        await UPDATE(Invoices)
            .set({ amount: total })
            .where({ ID: invoiceID });

    });
    this.before('CREATE', Invoices, async (req) => {

        console.log('Creating Invoice...');

        if (req.data.invoiceDate && req.data.dueDate) {
            if (new Date(req.data.dueDate) < new Date(req.data.invoiceDate)) {
                req.error(400, "Due Date cannot be before Invoice Date");
            }
        }

        if (Number(req.data.amount) <= 0) {
            req.error(400, "Invoice Amount must be greater than 0");
        }

        const exists = await SELECT.one.from(Invoices).where({
            invoiceNumber: req.data.invoiceNumber,
            vendor_ID: req.data.vendor_ID
        });

        if (exists) {
            req.error(400, "Invoice Number already exists for this Vendor");
        }

    });

    this.before('UPDATE', Invoices, async (req) => {

        console.log('Updating Invoice...');

        const invoice = await SELECT.one
            .from(Invoices)
            .where({ ID: req.data.ID });

        if (!invoice) return;

        // Only Draft invoice can be edited
        if (invoice.status !== 'DRAFT') {
            req.error(400, 'Only Draft invoices can be edited.');
        }
        if (req.data.invoiceDate && req.data.dueDate) {
            if (new Date(req.data.dueDate) < new Date(req.data.invoiceDate)) {
                req.error(400, "Due Date cannot be before Invoice Date");
            }
        }

        if (req.data.amount != null && Number(req.data.amount) <= 0) {
            req.error(400, "Invoice Amount must be greater than 0");
        }

    });

    this.before('DELETE', Vendors, async () => {
        console.log('Deleting Vendor...');
    });

    this.after('READ', Invoices, (data) => {

        const invoices = Array.isArray(data) ? data : [data];

        for (const inv of invoices) {

            inv.canSubmit = inv.status === 'DRAFT';
            inv.canApprove = inv.status === 'SUBMITTED';
            inv.canReject = inv.status === 'SUBMITTED';

        }

    });

    // =========================
    // SUBMIT INVOICE
    // =========================

    this.on('SubmitInvoice', async (req) => {

        const invoiceID = req.params?.[0]?.ID || req.data.invoiceID;

        const invoice = await SELECT.one
            .from(Invoices)
            .where({ ID: invoiceID });

        if (!invoice)
            req.error(404, 'Invoice not found');

        if (invoice.status !== 'DRAFT')
            req.error(400, 'Only Draft invoice can be submitted');

        const items = await SELECT.from(InvoiceItems)
            .where({ invoice_ID: invoiceID });

        if (items.length === 0)
            req.error(400, 'Invoice must contain at least one line item');

        const invalidItem = items.find(
            i => Number(i.quantity) <= 0 || Number(i.unitPrice) <= 0
        );

        if (invalidItem) {
            req.error(400, "Invoice contains invalid line items.");
        }

        const total = items.reduce(
            (sum, i) => sum + (Number(i.quantity) * Number(i.unitPrice)),
            0
        );

        if (total !== Number(invoice.amount)) {
            req.error(
                400,
                `Line items total (${total}) does not match invoice amount (${invoice.amount})`
            );
        }

        await UPDATE(Invoices)
            .set({
                status: 'SUBMITTED',
                criticality: 2,
                submittedBy: req.user.id,
                submittedAt: new Date()
            })
            .where({ ID: invoiceID });

        await INSERT.into(ApprovalHistory).entries({
            invoice_ID: invoiceID,
            action: 'SUBMITTED',
            actor: req.user.id,
            comments: 'Invoice Submitted',
            actionDate: new Date(),
            statusAfterAction: 'SUBMITTED'
        });

        return 'Invoice submitted successfully.';

    });

    // =========================
    // APPROVE INVOICE
    // =========================

    this.on('ApproveInvoice', async (req) => {

        const invoiceID = req.params?.[0]?.ID || req.data.invoiceID;

        const invoice = await SELECT.one
            .from(Invoices)
            .where({ ID: invoiceID });

        if (!invoice)
            req.error(404, 'Invoice not found');

        if (invoice.status !== 'SUBMITTED')
            req.error(400, 'Only Submitted invoice can be approved');

        if (!req.data.comments || req.data.comments.trim() === '') {
            req.error(400, 'Approval comments are mandatory');
        }

        // Optional: Submitter cannot approve
        // if (invoice.submittedBy === req.user.id) {
        //     req.error(400, 'Submitter cannot approve the same invoice');
        // }

        await UPDATE(Invoices)
            .set({
                status: 'APPROVED',
                criticality: 3,
                approvedBy: req.user.id,
                approvedAt: new Date(),
                approvalComments: req.data.comments
            })
            .where({ ID: invoiceID });

        await INSERT.into(ApprovalHistory).entries({
            invoice_ID: invoiceID,
            action: 'APPROVED',
            actor: req.user.id,
            comments: req.data.comments || 'Approved',
            actionDate: new Date(),
            statusAfterAction: 'APPROVED'
        });

        return 'Invoice approved successfully.';
    });

    // =========================
    // REJECT INVOICE
    // =========================

    this.on('RejectInvoice', async (req) => {

        const invoiceID = req.params?.[0]?.ID || req.data.invoiceID;

        const invoice = await SELECT.one
            .from(Invoices)
            .where({ ID: invoiceID });

        if (!invoice)
            req.error(404, 'Invoice not found');

        if (invoice.status !== 'SUBMITTED')
            req.error(400, 'Only Submitted invoice can be rejected');

        if (!req.data.reason || req.data.reason.trim() === '')
            req.error(400, 'Rejection reason is mandatory');

        await UPDATE(Invoices)
            .set({
                status: 'REJECTED',
                criticality: 1,
                rejectedBy: req.user.id,
                rejectedAt: new Date(),
                rejectionReason: req.data.reason
            })
            .where({ ID: invoiceID });

        await INSERT.into(ApprovalHistory).entries({
            invoice_ID: invoiceID,
            action: 'REJECTED',
            actor: req.user.id,
            comments: req.data.reason,
            actionDate: new Date(),
            statusAfterAction: 'REJECTED'
        });

        return 'Invoice rejected successfully.';
    });

    // =========================
    // SYNC VENDORS
    // =========================

    this.on('SyncVendors', async () => {

        const bpData = await bp.run(
            SELECT.from('API_BUSINESS_PARTNER.A_BusinessPartner').limit(20)
        );

        let count = 0;

        for (const partner of bpData) {

            const exists = await SELECT.one
                .from(Vendors)
                .where({ vendorCode: partner.BusinessPartner });

            if (!exists) {

                await INSERT.into(Vendors).entries({

                    vendorCode: partner.BusinessPartner,

                    vendorName:
                        partner.BusinessPartnerFullName ||
                        partner.BusinessPartnerName ||
                        partner.OrganizationBPName1,

                    email: "",
                    phone: "",
                    country: "",
                    status: "APPROVED"

                });

                count++;

            }
        }

        return `${count} Vendors synchronized successfully.`;

    });

    this.after("READ", "Invoices", (data) => {

        const today = new Date();

        const calculateAge = (invoice) => {
            if (!invoice.invoiceDate) return;

            const invoiceDate = new Date(invoice.invoiceDate);
            const diff = today - invoiceDate;

            invoice.invoiceAge = Math.floor(diff / (1000 * 60 * 60 * 24));
        };

        if (Array.isArray(data)) {
            data.forEach(calculateAge);
        } else {
            calculateAge(data);
        }
    });
});