namespace vendor.details;

using {
    cuid,
    managed
} from '@sap/cds/common';

entity Vendors : cuid, managed {

    vendorId       : String(20);
    vendorName     : String(100);
    email          : String(100);
    phone          : String(20);

    requestedBy    : String(100);

    workflowId     : String(100);
    workflowStatus : String(30);

    status : String(20) default 'NEW';
}