const cds = require('@sap/cds');
const { SELECT } = cds.ql;

module.exports = cds.service.impl(async function () {

    const { Invoices } = this.entities;

    // Show only APPROVED invoices
    this.on('READ', Invoices, async (req) => {

        const query = req.query;

        if (query.SELECT.where) {
            query.SELECT.where.push('and');
            query.SELECT.where.push({ ref: ['status'] });
            query.SELECT.where.push('=');
            query.SELECT.where.push({ val: 'APPROVED' });
        } else {
            query.SELECT.where = [
                { ref: ['status'] },
                '=',
                { val: 'APPROVED' }
            ];
        }

        return cds.run(query);

    });

    this.after('READ', 'Invoices', () => {
        console.log('Approved invoices viewed');
    });

    console.log('Viewer Service Loaded');

});