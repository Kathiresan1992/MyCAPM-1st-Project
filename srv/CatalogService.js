module.exports = cds.service.impl(async function () {

    //Step 1: get the object of our odata entities
    const { EmployeeSet, POs } = this.entities;

    //Step 2: define generic handler for validation
    // this.before('UPDATE', EmployeeSet, (req, res) => {
    //     console.log("Aa gaya " + req.data.salaryAmount);
    //     if (parseFloat(req.data.salaryAmount) >= 1000000) {
    //         req.error(500, "Salary must be less than a million for employee");
    //     }
    // });

    // Generic handler for validation
    this.before('CREATE',EmployeeSet,(req,res) => {
        console.log("It has come " + JSON.stringify(req.data));
        if(parseInt(req.data.salaryAmount) >= 1000000){
            req.error(500,"You cannot pass more than a millions value to salary amount");
        }
    });

    this.on('increase', async (req,res) => {
        try {
            const ID = req.params[0];
            console.log("Hey Amigo, Your salary order with id " + req.params[0] + " will be boosted");
            const tx = cds.tx(req);
            await tx.update(EmployeeSet).with({
                salaryAmount: { '+=' : 20000 },
                NOTE: 'Boosted!!'
            }).where(ID);
        } catch (error) {
            return "Error " + error.toString();
        }
    });

    // this.on ('boost', async (req) => {
    //     const db = cds.connect.to('db');
    //     let { GROSS_AMOUNT} = req.data;
    //     await db.update('BankAccount',from).set('balance -=', GROSS_AMOUNT);

    //   });

    this.on('boost', async (req,res) => {
        try {
            const ID = req.params[0];
            console.log(ID);
            console.log("Hey Amigo, Your purchase order with id " + req.params[0] + " will be boosted");
            const tx = cds.tx(req);            
            await tx.update(POs).with({
                GROSS_AMOUNT: { '+=': 20000 },
                NOTE: 'Boosted!!'
            }).where(ID);

            
        } catch (error) {
            console.log("Error " + error.toString());
            return "Error " + error.toString();
        }
    });


    this.on('largestOrder', async (req, res) => {
        try {
            const ID = req.params[0];
            const tx = cds.tx(req);

            //SELECT * UPTO 1 ROW FROM dbtab ORDER BY GROSS_AMOUNT desc
            const reply = await tx.read(POs).orderBy({
                GROSS_AMOUNT: 'desc'
            }).limit(1);

            return reply;
        } catch (error) {
            return "Error " + error.toString();
        }
    });

    this.on('getOrderDefaults', async (req, res) => {
        try {
            const reply = {
                "OVERALL_STATUS": 'N'
            }
            return reply;
        } catch (error) {
            return "Error " + error.toString();
        }
    });    


}
);