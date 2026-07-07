using VendorManagerService as service from '../../srv/vendor-service';

annotate service.Vendors with @(

    UI.HeaderInfo : {
        TypeName       : 'Vendor',
        TypeNamePlural : 'Vendors',
        Title : {
            Value : vendorName
        },
        Description : {
            Value : vendorCode
        }
    },

    UI.HeaderFacets : [

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Vendor Overview',
            Target : '@UI.FieldGroup#Header'
        }

    ],

    UI.SelectionFields : [

        vendorCode,
        vendorName,
        city,
        country,
        status

    ],

    UI.LineItem : [

        {
            $Type : 'UI.DataField',
            Label : 'Vendor Code',
            Value : vendorCode
        },

        {
            $Type : 'UI.DataField',
            Label : 'Vendor Name',
            Value : vendorName
        },

        {
            $Type : 'UI.DataField',
            Label : 'Email',
            Value : email
        },

        {
            $Type : 'UI.DataField',
            Label : 'Phone',
            Value : phone
        },

        {
            $Type : 'UI.DataField',
            Label : 'City',
            Value : city
        },

        {
            $Type : 'UI.DataField',
            Label : 'Country',
            Value : country
        },

        {
            $Type : 'UI.DataField',
            Label : 'Currency',
            Value : currency
        },

        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status
        }

    ],

    UI.FieldGroup #Header : {

        Data : [

            {
                $Type : 'UI.DataField',
                Value : vendorCode
            },

            {
                $Type : 'UI.DataField',
                Value : vendorName
            },

            {
                $Type : 'UI.DataField',
                Value : email
            },

            {
                $Type : 'UI.DataField',
                Value : phone
            },

            {
                $Type : 'UI.DataField',
                Value : country
            },

            {
                $Type : 'UI.DataField',
                Value : status
            }

        ]

    }

);

annotate service.Vendors with @(

    UI.Identification : [

        {
            $Type : 'UI.DataField',
            Value : vendorCode
        },

        {
            $Type : 'UI.DataField',
            Value : vendorName
        },

        {
            $Type : 'UI.DataField',
            Value : email
        },

        {
            $Type : 'UI.DataField',
            Value : phone
        },

        {
            $Type : 'UI.DataFieldForAction',
            Action : 'VendorManagerService.SyncVendors',
            Label : 'Sync Vendors'
        }

    ],

    UI.FieldGroup #General : {

        Data : [

            { $Type:'UI.DataField', Label:'Vendor Code', Value:vendorCode },

            { $Type:'UI.DataField', Label:'Vendor Name', Value:vendorName },

            { $Type:'UI.DataField', Label:'Email', Value:email },

            { $Type:'UI.DataField', Label:'Phone', Value:phone },

            { $Type:'UI.DataField', Label:'Address', Value:address },

            { $Type:'UI.DataField', Label:'City', Value:city },

            { $Type:'UI.DataField', Label:'State', Value:state },

            { $Type:'UI.DataField', Label:'Country', Value:country },

            { $Type:'UI.DataField', Label:'Postal Code', Value:postalCode },

            { $Type:'UI.DataField', Label:'Vendor Type', Value:vendorType },

            { $Type:'UI.DataField', Label:'Status', Value:status },

            { $Type:'UI.DataField', Label:'Assigned Manager', Value:assignedManager }

        ]

    },

    UI.FieldGroup #Finance : {

        Data : [

            { $Type:'UI.DataField', Label:'Currency', Value:currency },

            { $Type:'UI.DataField', Label:'Credit Limit', Value:creditLimit },

            { $Type:'UI.DataField', Label:'Payment Terms', Value:paymentTerms },

            { $Type:'UI.DataField', Label:'Tax ID', Value:taxId }

        ]

    },

    UI.FieldGroup #Bank : {

        Data : [

            { $Type:'UI.DataField', Label:'Bank Name', Value:bankName },

            { $Type:'UI.DataField', Label:'Bank Account', Value:bankAccount },

            { $Type:'UI.DataField', Label:'SWIFT Code', Value:swiftCode }

        ]

    },

    UI.Facets : [

        {
            $Type : 'UI.CollectionFacet',
            Label : 'Vendor Details',

            Facets : [

                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'General Information',
                    Target : '@UI.FieldGroup#General'
                },

                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Financial Information',
                    Target : '@UI.FieldGroup#Finance'
                },

                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Bank Information',
                    Target : '@UI.FieldGroup#Bank'
                }

            ]
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Invoices',
            Target : 'invoices/@UI.LineItem'
        }

    ]

);

//====================================================
// Related Invoices
//====================================================

annotate service.Invoices with @(

    UI.LineItem : [

        {
            $Type : 'UI.DataField',
            Label : 'Invoice Number',
            Value : invoiceNumber
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
            Value : currency
        },

        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status
        }

    ]

);

//====================================================
// Invoice Items
//====================================================

annotate service.InvoiceItems with @(

    UI.LineItem : [

        {
            $Type : 'UI.DataField',
            Value : lineNumber
        },

        {
            $Type : 'UI.DataField',
            Value : description
        },

        {
            $Type : 'UI.DataField',
            Value : quantity
        },

        {
            $Type : 'UI.DataField',
            Value : unitPrice
        },

        {
            $Type : 'UI.DataField',
            Value : totalAmount
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
            Value : fileName
        },

        {
            $Type : 'UI.DataField',
            Value : mediaType
        },

        {
            $Type : 'UI.DataField',
            Value : fileSize
        },

        {
            $Type : 'UI.DataField',
            Value : uploadedBy
        },

        {
            $Type : 'UI.DataField',
            Value : uploadedAt
        }

    ]

);