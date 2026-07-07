namespace vendor.invoice;

using {
    cuid,
    managed,
    Currency
} from '@sap/cds/common';

using { vendor.invoice as common } from './common';

entity Vendors : cuid, managed {

    @mandatory
    vendorCode          : String(20);

    @mandatory
    vendorName          : String(100);

    @mandatory
    email               : String(100);

    phone               : String(20);
    address             : String(255);
    city                : String(50);
    state               : String(50);
    country             : String(50);
    postalCode          : String(20);

    currency            : Currency;
    taxId               : String(30);

    externalSupplierId  : String(40);
    assignedManager     : String(255);

    status              : common.VendorStatus default #PENDING;

    isActive            : Boolean default true;
    vendorType          : String(30);

    creditLimit         : Decimal(15,2);
    paymentTerms        : String(50);

    bankName            : String(100);
    bankAccount         : String(50);
    swiftCode           : String(20);

    invoices            : Association to many Invoices
                            on invoices.vendor = $self;
}


@assert.unique : {
    invoiceVendor : [
        vendor,
        invoiceNumber
    ]
}
entity Invoices : cuid, managed {

    @mandatory
    invoiceNumber       : String(30);

    @mandatory
    vendor              : Association to Vendors;

    @mandatory
    invoiceDate         : Date;
    virtual invoiceAge : Integer;

    @mandatory
    dueDate             : Date;

    @mandatory
    amount              : Decimal(15,2);

    // @mandatory
    currency            : Currency;

    status              : common.InvoiceStatus default #DRAFT;
    criticality         : Integer default 0;

    submittedBy         : String(255);
    submittedAt         : Timestamp;

    approvedBy          : String(255);
    approvedAt          : Timestamp;

    rejectedBy          : String(255);
    rejectedAt          : Timestamp;

    approvalComments    : String(500);
    rejectionReason     : String(500);

    paymentDate         : Date;
    paymentReference    : String(50);

    referenceNumber     : String(50);

    department          : String(100);
    createdDepartment   : String(100);

    remarks             : String(500);
    submittedComments   : String(500);

    exchangeRate        : Decimal(10,4);

    isPaid              : Boolean default false;

    virtual canSubmit : Boolean;
virtual canApprove : Boolean;
virtual canReject : Boolean;

    lineItems : Composition of many InvoiceItems
        on lineItems.invoice = $self;

    attachments : Composition of many Attachments
        on attachments.invoice = $self;

    approvalHistory : Composition of many ApprovalHistory
        on approvalHistory.invoice = $self;
}


entity InvoiceItems : cuid, managed {

    invoice             : Association to Invoices;

    lineNumber          : Integer;

    @mandatory
    description         : String(255);

    @mandatory
    quantity            : Decimal(13,2);

    @mandatory
    unitPrice           : Decimal(15,2);

    totalAmount         : Decimal(15,2);

    taxPercentage       : Decimal(5,2);

    discount            : Decimal(10,2);

    netAmount           : Decimal(15,2);

}


entity Attachments : cuid, managed {

    invoice             : Association to Invoices;

    @mandatory
    fileName            : String(255);

    mediaType           : String(100);

    fileSize            : Integer;

    uploadedBy          : String(255);

    uploadedAt          : Timestamp;

    documentUrl         : String(500);

}


entity ApprovalHistory : cuid, managed {

    invoice             : Association to Invoices;

    @mandatory
    action              : common.ApprovalAction;

    actor               : String(255);

    comments            : String(500);

    actionDate          : Timestamp;

    statusAfterAction   : common.InvoiceStatus;

}