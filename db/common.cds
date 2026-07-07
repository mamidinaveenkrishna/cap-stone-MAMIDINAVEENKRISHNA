namespace vendor.invoice;

type VendorStatus : String enum {
  PENDING;
  APPROVED;
  SUSPENDED;
  DELETED;
}

type InvoiceStatus : String enum {
  DRAFT;
  SUBMITTED;
  APPROVED;
  REJECTED;
  PAID;
}

type ApprovalAction : String enum {
  SUBMITTED;
  APPROVED;
  REJECTED;
}