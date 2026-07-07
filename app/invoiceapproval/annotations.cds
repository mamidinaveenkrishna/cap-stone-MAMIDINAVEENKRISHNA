using ApproverService as service from '../../srv/approver-service';

annotate service.Invoices with @(

    UI.HeaderInfo : {
        TypeName : 'Invoice',
        TypeNamePlural : 'Invoices',
        Title : {
            Value : invoiceNumber
        },
        Description : {
            Value : vendor.vendorName
        }
    },

    UI.SelectionFields : [
        invoiceNumber,
        vendor,
        status,
        invoiceDate,
        dueDate
    ],

    UI.LineItem : [

        { $Type:'UI.DataField', Label:'Invoice', Value:invoiceNumber },
        { $Type:'UI.DataField', Label:'Vendor', Value:vendor.vendorName },
        { $Type:'UI.DataField', Label:'Invoice Date', Value:invoiceDate },
        { $Type:'UI.DataField', Label:'Due Date', Value:dueDate },
        { $Type:'UI.DataField', Label:'Amount', Value:amount },
        { $Type:'UI.DataField', Label:'Currency', Value:currency_code },

        {
            $Type:'UI.DataField',
            Label:'Status',
            Value:status,
            Criticality:criticality
        }

    ],

    UI.Identification:[

        { $Type:'UI.DataField', Value:invoiceNumber },
        { $Type:'UI.DataField', Value:vendor.vendorName },
        { $Type:'UI.DataField', Value:amount },
        {
            $Type:'UI.DataField',
            Value:status,
            Criticality:criticality
        },

        {
            $Type:'UI.DataFieldForAction',
            Action:'ApproverService.ApproveInvoice',
            Label:'Approve Invoice'
        },

        {
            $Type:'UI.DataFieldForAction',
            Action:'ApproverService.RejectInvoice',
            Label:'Reject Invoice'
        }

    ],

    UI.FieldGroup #General : {

        Data : [

            { $Type:'UI.DataField', Label:'Invoice Number', Value:invoiceNumber },
            { $Type:'UI.DataField', Label:'Vendor', Value:vendor.vendorName },
            { $Type:'UI.DataField', Label:'Invoice Date', Value:invoiceDate },
            { $Type:'UI.DataField', Label:'Due Date', Value:dueDate },
            { $Type:'UI.DataField', Label:'Amount', Value:amount },
            { $Type:'UI.DataField', Label:'Currency', Value:currency_code },

            {
                $Type:'UI.DataField',
                Label:'Status',
                Value:status,
                Criticality:criticality
            },

            { $Type:'UI.DataField', Label:'Submitted By', Value:submittedBy },
            { $Type:'UI.DataField', Label:'Submitted At', Value:submittedAt },
            { $Type:'UI.DataField', Label:'Approval Comments', Value:approvalComments },
            { $Type:'UI.DataField', Label:'Rejection Reason', Value:rejectionReason }

        ]
    },

    UI.Facets:[

        {
            $Type:'UI.ReferenceFacet',
            ID:'General',
            Label:'General Information',
            Target:'@UI.FieldGroup#General'
        },

        {
            $Type:'UI.ReferenceFacet',
            ID:'Items',
            Label:'Invoice Items',
            Target:'lineItems/@UI.LineItem'
        },

        {
            $Type:'UI.ReferenceFacet',
            ID:'Attachments',
            Label:'Attachments',
            Target:'attachments/@UI.LineItem'
        },

        {
            $Type:'UI.ReferenceFacet',
            ID:'History',
            Label:'Approval History',
            Target:'approvalHistory/@UI.LineItem'
        }

    ]

);

annotate service.InvoiceItems with @(
    UI.LineItem:[
        { Value:lineNumber, Label:'Line' },
        { Value:description, Label:'Description' },
        { Value:quantity, Label:'Quantity' },
        { Value:unitPrice, Label:'Unit Price' },
        { Value:totalAmount, Label:'Total Amount' }
    ]
);

annotate service.Attachments with @(
    UI.LineItem:[
        { Value:fileName, Label:'File Name' },
        { Value:mediaType, Label:'Type' },
        { Value:fileSize, Label:'Size' },
        { Value:uploadedBy, Label:'Uploaded By' },
        { Value:uploadedAt, Label:'Uploaded At' }
    ]
);

annotate service.ApprovalHistory with @(
    UI.LineItem:[
        { Value:action, Label:'Action' },
        { Value:actor, Label:'Approver' },
        { Value:comments, Label:'Comments' },
        { Value:actionDate, Label:'Action Date' },
        { Value:statusAfterAction, Label:'Status' }
    ]
);
