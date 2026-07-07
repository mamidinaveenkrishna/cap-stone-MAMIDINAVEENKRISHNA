sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"vendor/invoice/invoiceapproval/test/integration/pages/InvoicesList",
	"vendor/invoice/invoiceapproval/test/integration/pages/InvoicesObjectPage"
], function (JourneyRunner, InvoicesList, InvoicesObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('vendor/invoice/invoiceapproval') + '/test/flp.html#app-preview',
        pages: {
			onTheInvoicesList: InvoicesList,
			onTheInvoicesObjectPage: InvoicesObjectPage
        },
        async: true
    });

    return runner;
});

