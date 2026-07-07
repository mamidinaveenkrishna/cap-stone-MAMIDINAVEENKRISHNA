sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'vendor.invoice.invoiceapproval',
            componentId: 'InvoicesList',
            contextPath: '/Invoices'
        },
        CustomPageDefinitions
    );
});