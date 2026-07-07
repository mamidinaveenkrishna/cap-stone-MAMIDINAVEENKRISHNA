using AdminService as service from '../../srv/admin-service';

annotate service.Invoices with @(

    UI.HeaderInfo : {
        TypeName : 'Invoice',
        TypeNamePlural : 'Invoices',
        Title : { Value : invoiceNumber },
        Description : { Value : vendor.vendorName }
    },

    UI.SelectionFields : [
        invoiceNumber,
        vendor,
        status,
        invoiceDate
    ],

    UI.LineItem : [

        { Value : invoiceNumber, Label : 'Invoice No.' },

        { Value : vendor.vendorName, Label : 'Vendor' },

        { Value : invoiceDate },

        { Value : dueDate },

        { Value : amount },

        { Value : currency_code, Label : 'Currency' },

        {
            Value : status,
            Criticality : criticality
        }

    ],

    UI.Identification : [

        { Value : invoiceNumber },

        { Value : vendor.vendorName },

        { Value : amount },

        {
            Value : status,
            Criticality : criticality
        },

        {
            $Type : 'UI.DataFieldForAction',
            Action : 'AdminService.SubmitInvoice',
            Label : 'Submit'
        },

        {
            $Type : 'UI.DataFieldForAction',
            Action : 'AdminService.ApproveInvoice',
            Label : 'Approve'
        },

        {
            $Type : 'UI.DataFieldForAction',
            Action : 'AdminService.RejectInvoice',
            Label : 'Reject'
        }

    ],

    UI.FieldGroup #General : {

        Data : [

            { $Type:'UI.DataField', Label:'Invoice Number', Value:invoiceNumber },

            { $Type:'UI.DataField', Label:'Vendor', Value:vendor_ID },

            { $Type:'UI.DataField', Label:'Invoice Date', Value:invoiceDate },

            { $Type:'UI.DataField', Label:'Due Date', Value:dueDate },

            { $Type:'UI.DataField', Label:'Amount', Value:amount },

            {
                $Type:'UI.DataField',
                Label:'Status',
                Value:status,
                Criticality:criticality
            },

            { $Type:'UI.DataField', Label:'Department', Value:department },

            { $Type:'UI.DataField', Label:'Remarks', Value:remarks },

            { $Type:'UI.DataField', Label:'Submitted By', Value:submittedBy },

            { $Type:'UI.DataField', Label:'Submitted At', Value:submittedAt },

            { $Type:'UI.DataField', Label:'Approved By', Value:approvedBy },

            { $Type:'UI.DataField', Label:'Approved At', Value:approvedAt },

            { $Type:'UI.DataField', Label:'Rejected By', Value:rejectedBy },

            { $Type:'UI.DataField', Label:'Rejected At', Value:rejectedAt },

            { $Type:'UI.DataField', Label:'Approval Comments', Value:approvalComments },

            { $Type:'UI.DataField', Label:'Rejection Reason', Value:rejectionReason },

            { $Type:'UI.DataField', Label:'Payment Date', Value:paymentDate },

            { $Type:'UI.DataField', Label:'Payment Reference', Value:paymentReference }

        ]

    },

    UI.Facets : [

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'General Information',
            Target : '@UI.FieldGroup#General'
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

    ]

);

annotate service.Invoices with {

    vendor @Common.Text : vendor.vendorName;

    vendor @Common.ValueList : {
        CollectionPath : 'Vendors',
        Label : 'Vendor',
        Parameters : [

            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : vendor_ID,
                ValueListProperty : 'ID'
            },

            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'vendorCode'
            },

            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'vendorName'
            }

        ]
    };

};

annotate service.InvoiceItems with @(

    UI.LineItem : [

        { Value : lineNumber },

        { Value : description },

        { Value : quantity },

        { Value : unitPrice },

        { Value : totalAmount },

        { Value : taxPercentage },

        { Value : discount },

        { Value : netAmount }

    ]

);

annotate service.Attachments with @(

    UI.LineItem : [

        { Value : fileName },

        { Value : mediaType },

        { Value : fileSize },

        { Value : uploadedBy },

        { Value : uploadedAt }

    ]

);

annotate service.ApprovalHistory with @(

    UI.LineItem : [

        { Value : action },

        { Value : actor },

        { Value :comments },

        { Value : actionDate },

        { Value : statusAfterAction }

    ]

);

annotate service.Vendors with @(

    UI.HeaderInfo : {

        TypeName : 'Vendor',

        TypeNamePlural : 'Vendors',

        Title : {
            Value : vendorName
        }

    },

    UI.LineItem : [

        { Value : vendorCode },

        { Value : vendorName },

        { Value : email },

        { Value : phone },

        { Value : country },

        { Value : status }

    ],

   UI.Identification : [
    { Value : vendorCode },
    { Value : vendorName },
    { Value : email },
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'AdminService.SyncVendors',
        Label : 'Sync from S/4HANA'
    }
]

);