const cds = require('@sap/cds');
const { SELECT, UPDATE, INSERT } = cds.ql;

module.exports = cds.service.impl(async function () {

    const { Invoices, Vendors, InvoiceItems, ApprovalHistory } = this.entities;

    this.before('CREATE', Invoices, async (req) => {

        req.data.status = 'DRAFT';

        if (req.data.invoiceDate && new Date(req.data.invoiceDate) > new Date()) {
            req.error(400, 'Invoice date cannot be in the future');
        }

        if (
            req.data.invoiceDate &&
            req.data.dueDate &&
            new Date(req.data.dueDate) < new Date(req.data.invoiceDate)
        ) {
            req.error(400, 'Due date cannot be before invoice date');
        }

        if (Number(req.data.amount) <= 0) {
            req.error(400, 'Invoice amount must be greater than 0');
        }

        if (Number(req.data.amount) > 1000000) {
            req.error(400, 'Invoice amount cannot exceed 1,000,000');
        }

        const vendor = await SELECT.one
            .from(Vendors)
            .where({ ID: req.data.vendor_ID });

        if (!vendor) {
            req.error(400, 'Vendor not found');
        }

        if (vendor.status !== 'APPROVED') {
            req.error(400, 'Only approved vendors can create invoices');
        }
    });

    this.before(['UPDATE', 'PATCH'], Invoices, async (req) => {

        const invoice = await SELECT.one
            .from(Invoices)
            .where({ ID: req.data.ID });

        if (!invoice) return;

        if (invoice.status !== 'DRAFT') {
            req.error(400, 'Only draft invoices can be edited');
        }

        if (
            req.data.invoiceDate &&
            req.data.dueDate &&
            new Date(req.data.dueDate) < new Date(req.data.invoiceDate)
        ) {
            req.error(400, 'Due date cannot be before invoice date');
        }

        if (
            req.data.invoiceDate &&
            new Date(req.data.invoiceDate) > new Date()
        ) {
            req.error(400, 'Invoice date cannot be in the future');
        }

        if (
            req.data.amount != null &&
            Number(req.data.amount) <= 0
        ) {
            req.error(400, 'Invoice amount must be greater than 0');
        }
    });

    this.on('SubmitInvoice', async (req) => {

        const invoiceID = req.params?.[0]?.ID || req.data.invoiceID;

        const invoice = await SELECT.one
            .from(Invoices)
            .where({ ID: invoiceID });

        if (!invoice) {
            req.error(404, 'Invoice not found');
        }

        if (invoice.status !== 'DRAFT') {
            req.error(400, 'Only draft invoices can be submitted');
        }

        const items = await SELECT
            .from(InvoiceItems)
            .where({ invoice_ID: invoiceID });

        if (!items.length) {
            req.error(400, 'Invoice must contain at least one line item');
        }

        const invalid = items.find(i =>
            Number(i.quantity) <= 0 ||
            Number(i.unitPrice) <= 0
        );

        if (invalid) {
            req.error(400, 'Invoice contains invalid line items');
        }

        const total = items.reduce(
            (sum, i) => sum + Number(i.quantity) * Number(i.unitPrice),
            0
        );

        if (Math.abs(total - Number(invoice.amount)) > 0.01) {
            req.error(400, 'Invoice total does not match line item total');
        }

        await UPDATE(Invoices)
            .set({
                status: 'SUBMITTED',
                criticality: 2,
                submittedAt: new Date(),
                submittedBy: req.user.id
            })
            .where({ ID: invoiceID });

        await INSERT.into(ApprovalHistory).entries({
            invoice_ID: invoiceID,
            action: 'SUBMITTED',
            actor: req.user.id,
            comments: 'Submitted for approval',
            actionDate: new Date(),
            statusAfterAction: 'SUBMITTED'
        });

        return 'Invoice submitted successfully';
    });

});