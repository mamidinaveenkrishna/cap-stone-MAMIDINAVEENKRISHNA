using { vendor.invoice as db } from '../db/schema';

//@requires: 'Viewer'
service AdminService @(path:'/admin') {

    //@requires: 'VendorManager'
    entity Vendors as projection on db.Vendors;

    //@requires: 'Admin'
    @odata.draft.enabled
    entity Invoices as projection on db.Invoices
    actions {
        action SubmitInvoice() returns String;
        action ApproveInvoice(comments : String) returns String;
        action RejectInvoice(reason : String) returns String;
    };

    //@requires: 'Admin'
    entity InvoiceItems as projection on db.InvoiceItems;

    //@requires: 'Admin'
    entity Attachments as projection on db.Attachments;

    //@requires: 'Viewer'
    entity ApprovalHistory as projection on db.ApprovalHistory;

    //@requires: 'VendorManager'
    action SyncVendors() returns String;
}