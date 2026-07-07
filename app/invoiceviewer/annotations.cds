using ViewerService as service from '../../srv/viewer-service';

annotate service.Invoices with @(

    UI.HeaderInfo : {
        TypeName       : 'Invoice',
        TypeNamePlural : 'Invoices',
        Title : {
            Value : invoiceNumber
        },
        Description : {
            Value : status
        }
    },

    UI.SelectionFields : [
        vendor,
        status,
        invoiceDate,
        dueDate,
        currency
    ],

    UI.PresentationVariant : {
        SortOrder : [{
            Property : invoiceDate,
            Descending : true
        }]
    },

    UI.LineItem : [

        {
            $Type : 'UI.DataField',
            Label : 'Invoice Number',
            Value : invoiceNumber,
            ![@UI.Importance] : #High
        },

        {
            $Type : 'UI.DataField',
            Label : 'Vendor',
            Value : vendor.vendorName,
            ![@UI.Importance] : #High
        },

        {
            $Type : 'UI.DataField',
            Label : 'Invoice Date',
            Value : invoiceDate
        },

        {
            $Type : 'UI.DataField',
            Label : 'Due Date',
            Value : dueDate
        },

        {
            $Type : 'UI.DataField',
            Label : 'Amount',
            Value : amount,
            ![@UI.Importance] : #High
        },

        {
            $Type : 'UI.DataField',
            Label : 'Currency',
            Value : currency
        },

        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status,
            Criticality : criticality,
            ![@UI.Importance] : #High
        }

    ],

    UI.HeaderFacets : [

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Vendor Information',
            Target : '@UI.FieldGroup#HeaderVendor'
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Approval Information',
            Target : '@UI.FieldGroup#HeaderApproval'
        }

    ],

    UI.FieldGroup #HeaderVendor : {

        Data : [

            {
                $Type : 'UI.DataField',
                Label : 'Vendor',
                Value : vendor.vendorName
            },

            {
                $Type : 'UI.DataField',
                Label : 'Amount',
                Value : amount
            },

            {
                $Type : 'UI.DataField',
                Label : 'Currency',
                Value : currency
            }

        ]

    },

    UI.FieldGroup #HeaderApproval : {

        Data : [

            {
                $Type : 'UI.DataField',
                Label : 'Approved By',
                Value : approvedBy
            },

            {
                $Type : 'UI.DataField',
                Label : 'Approved At',
                Value : approvedAt
            },

            {
                $Type : 'UI.DataField',
                Label : 'Payment Date',
                Value : paymentDate
            },

            {
                $Type : 'UI.DataField',
                Label : 'Payment Reference',
                Value : paymentReference
            }

        ]

    }

);

annotate service.Invoices with @(

    UI.Facets : [

        {
            $Type : 'UI.CollectionFacet',
            Label : 'Invoice Details',

            Facets : [

                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'General Information',
                    Target : '@UI.FieldGroup#GeneralInfo'
                },

                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Approval Information',
                    Target : '@UI.FieldGroup#ApprovalInfo'
                }

            ]
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Invoice Items',
            Target : 'lineItems/@UI.LineItem'
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Attachments',
            Target : 'attachments/@UI.LineItem'
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Approval History',
            Target : 'approvalHistory/@UI.LineItem'
        }

    ],

    UI.FieldGroup #GeneralInfo : {

        Data : [

            {
                $Type : 'UI.DataField',
                Label : 'Invoice Number',
                Value : invoiceNumber
            },

            {
                $Type : 'UI.DataField',
                Label : 'Vendor',
                Value : vendor.vendorName
            },

            {
                $Type : 'UI.DataField',
                Label : 'Invoice Date',
                Value : invoiceDate
            },

            {
                $Type : 'UI.DataField',
                Label : 'Due Date',
                Value : dueDate
            },

            {
                $Type : 'UI.DataField',
                Label : 'Amount',
                Value : amount
            },

            {
                $Type : 'UI.DataField',
                Label : 'Currency',
                Value : currency.code            },

            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : status
            },

            {
                $Type : 'UI.DataField',
                Label : 'Department',
                Value : department
            },

            {
                $Type : 'UI.DataField',
                Label : 'Reference Number',
                Value : referenceNumber
            },

            {
                $Type : 'UI.DataField',
                Label : 'Remarks',
                Value : remarks
            }

        ]

    },

    UI.FieldGroup #ApprovalInfo : {

        Data : [

            {
                $Type : 'UI.DataField',
                Label : 'Submitted By',
                Value : submittedBy
            },

            {
                $Type : 'UI.DataField',
                Label : 'Submitted At',
                Value : submittedAt
            },

            {
                $Type : 'UI.DataField',
                Label : 'Approved By',
                Value : approvedBy
            },

            {
                $Type : 'UI.DataField',
                Label : 'Approved At',
                Value : approvedAt
            },

            {
                $Type : 'UI.DataField',
                Label : 'Approval Comments',
                Value : approvalComments
            },

            {
                $Type : 'UI.DataField',
                Label : 'Rejected By',
                Value : rejectedBy
            },

            {
                $Type : 'UI.DataField',
                Label : 'Rejected At',
                Value : rejectedAt
            },

            {
                $Type : 'UI.DataField',
                Label : 'Rejection Reason',
                Value : rejectionReason
            }

        ]

    }

);

annotate service.Invoices with {

    vendor @Common.ValueList : {

        $Type : 'Common.ValueListType',

        CollectionPath : 'Vendors',

        Parameters : [

            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : vendor_ID,
                ValueListProperty : 'ID'
            },

            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'vendorName'
            }

        ]

    };

};

//====================================================
// Invoice Items
//====================================================

annotate service.InvoiceItems with @(

    UI.LineItem : [

        {
            $Type : 'UI.DataField',
            Label : 'Line No',
            Value : lineNumber
        },

        {
            $Type : 'UI.DataField',
            Label : 'Description',
            Value : description
        },

        {
            $Type : 'UI.DataField',
            Label : 'Quantity',
            Value : quantity
        },

        {
            $Type : 'UI.DataField',
            Label : 'Unit Price',
            Value : unitPrice
        },

        {
            $Type : 'UI.DataField',
            Label : 'Total Amount',
            Value : totalAmount
        },

        {
            $Type : 'UI.DataField',
            Label : 'Tax %',
            Value : taxPercentage
        },

        {
            $Type : 'UI.DataField',
            Label : 'Discount',
            Value : discount
        },

        {
            $Type : 'UI.DataField',
            Label : 'Net Amount',
            Value : netAmount
        }

    ]

);

//====================================================
// Attachments
//====================================================

annotate service.Attachments with @(

    UI.LineItem : [

        {
            $Type : 'UI.DataField',
            Label : 'File Name',
            Value : fileName
        },

        {
            $Type : 'UI.DataField',
            Label : 'Media Type',
            Value : mediaType
        },

        {
            $Type : 'UI.DataField',
            Label : 'File Size',
            Value : fileSize
        },

        {
            $Type : 'UI.DataField',
            Label : 'Uploaded By',
            Value : uploadedBy
        },

        {
            $Type : 'UI.DataField',
            Label : 'Uploaded At',
            Value : uploadedAt
        }

    ]

);

//====================================================
// Approval History
//====================================================

annotate service.ApprovalHistory with @(

    UI.LineItem : [

        {
            $Type : 'UI.DataField',
            Label : 'Action',
            Value : action
        },

        {
            $Type : 'UI.DataField',
            Label : 'Actor',
            Value : actor
        },

        {
            $Type : 'UI.DataField',
            Label : 'Comments',
            Value : comments
        },

        {
            $Type : 'UI.DataField',
            Label : 'Action Date',
            Value : actionDate
        },

        {
            $Type : 'UI.DataField',
            Label : 'Status After Action',
            Value : statusAfterAction
        }

    ],

    UI.PresentationVariant : {

        SortOrder : [

            {
                Property : actionDate,
                Descending : true
            }

        ]

    }

);
