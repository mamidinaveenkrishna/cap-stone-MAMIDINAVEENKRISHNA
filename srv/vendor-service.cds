using { vendor.invoice as db } from '../db/schema';

@requires: 'VendorManager'
service VendorManagerService @(path:'/vendor') {

    entity Vendors as projection on db.Vendors;

    @odata.draft.enabled
    entity Invoices as projection on db.Invoices
    actions {
        action SubmitInvoice() returns String;
    };

    entity InvoiceItems as projection on db.InvoiceItems;

    entity Attachments as projection on db.Attachments;

}