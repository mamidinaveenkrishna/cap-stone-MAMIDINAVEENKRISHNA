using { vendor.details as db } from '../db/vendor-schema';

service VendorService {

    entity Vendors as projection on db.Vendors;

    action StartWorkflow(
        vendorId : String
    ) returns String;

}