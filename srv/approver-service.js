const cds = require('@sap/cds');
const { SELECT, UPDATE, INSERT } = cds.ql;

module.exports = cds.service.impl(async function () {

    const { Invoices, ApprovalHistory } = this.entities;

    this.before('READ', Invoices, req => {

        if (req.query.SELECT.where) {
            req.query.SELECT.where.push('and');
            req.query.SELECT.where.push({ ref: ['status'] });
            req.query.SELECT.where.push('=');
            req.query.SELECT.where.push({ val: 'SUBMITTED' });
        } else {
            req.query.SELECT.where = [
                { ref: ['status'] },
                '=',
                { val: 'SUBMITTED' }
            ];
        }

    });

    this.on('ApproveInvoice', async (req) => {

        const invoiceID = req.params?.[0]?.ID || req.data.invoiceID;

        const invoice = await SELECT.one
            .from(Invoices)
            .where({ ID: invoiceID });

        if (!invoice) {
            req.error(404, 'Invoice not found');
        }

        if (invoice.status !== 'SUBMITTED') {
            req.error(400, 'Only submitted invoices can be approved');
        }

        if (!req.data.comments || !req.data.comments.trim()) {
            req.error(400, 'Approval comments are required');
        }

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
            comments: req.data.comments,
            actionDate: new Date(),
            statusAfterAction: 'APPROVED'
        });

        return 'Invoice approved successfully';

    });

    this.on('RejectInvoice', async (req) => {

        const invoiceID = req.params?.[0]?.ID || req.data.invoiceID;

        const invoice = await SELECT.one
            .from(Invoices)
            .where({ ID: invoiceID });

        if (!invoice) {
            req.error(404, 'Invoice not found');
        }

        if (invoice.status !== 'SUBMITTED') {
            req.error(400, 'Only submitted invoices can be rejected');
        }

        if (!req.data.reason || !req.data.reason.trim()) {
            req.error(400, 'Rejection reason is required');
        }

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

        return 'Invoice rejected successfully';

    });

});