using { vendor.invoice as db } from '../db/schema';

@requires: 'Approver'
service ApproverService @(path:'/approver') {

    entity Vendors as projection on db.Vendors;

    entity Invoices as projection on db.Invoices
    actions {
        action ApproveInvoice() returns String;
        action RejectInvoice() returns String;
    };

    entity InvoiceItems as projection on db.InvoiceItems;

    entity Attachments as projection on db.Attachments;

    entity ApprovalHistory as projection on db.ApprovalHistory;

}