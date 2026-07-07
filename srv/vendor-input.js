const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const { Vendors } = this.entities;

    this.on('StartWorkflow', async (req) => {

        const { vendorId } = req.data;

        const tx = cds.tx(req);

        const vendor = await tx.run(
            SELECT.one.from(Vendors).where({ ID: vendorId })
        );

        if (!vendor) {
            return req.error(404, 'Vendor not found');
        }

        // Get OAuth Token
        const tokenResponse = await fetch(
            process.env.UAA_URL + "/oauth/token?grant_type=client_credentials",
            {
                method: "POST",
                headers: {
                    Authorization:
                        "Basic " +
                        Buffer.from(
                            process.env.CLIENT_ID +
                            ":" +
                            process.env.CLIENT_SECRET
                        ).toString("base64")
                }
            }
        );

        const token = await tokenResponse.json();

        // Start Workflow
        const workflowResponse = await fetch(
            process.env.API_ENDPOINT +
            "/workflow/rest/v1/workflow-instances",
            {
                method: "POST",
                headers: {
                    Authorization: `Bearer ${token.access_token}`,
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    definitionId:
                        "ap21.5623638etrial.vendorapprvoal.vendorApprovalProcess",

                    context: {
                        vENDORNAME: vendor.vendorName,
                        vENDORID: vendor.vendorId,
                        eMAIL: vendor.email,
                        pH: vendor.phone,
                        eMAIL_1: vendor.email,
                        requestedby: vendor.requestedBy
                    }
                })
            }
        );

        if (!workflowResponse.ok) {
            const error = await workflowResponse.text();
            return req.error(500, error);
        }

        const workflow = await workflowResponse.json();

        await tx.run(
            UPDATE(Vendors)
                .set({
                    workflowId: workflow.id,
                    workflowStatus: "STARTED",
                    status: "IN_PROGRESS"
                })
                .where({ ID: vendorId })
        );

        return workflow.id;
    });

});