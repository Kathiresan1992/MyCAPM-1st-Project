const cds = require("@sap/cds");    
const mysrvdemo = function(srv){
    const { ReadEmployeeSrv } = this.entities;
    const { employees } = cds.entities("anubhav.db.master");
    srv.on('hello', (req,res) => {
        console.log("Call has come to my service code");
        return "Hello " + req.data.name;
    });

    srv.on('READ',ReadEmployeeSrv, async(req,res) => {
        // return {
        //     "ID": "12345"
        // }

        var whereCondition = req.data;
        console.log(whereCondition);
        // let myRecords = await cds.tx(req).run(SELECT.from(employees).limit(5));        
        if(whereCondition.hasOwnProperty("ID")){
            results = await cds.tx(req).run(SELECT.from(employees).limit(10).where(whereCondition));
        }
        else{
            results = await cds.tx(req).run(SELECT.from(employees).limit(2));            
        }
        return results; 
    });
    // srv.on("READ", "ReadEmployeeSrv", async(req,res) => {

    //     var results = [];

    //     //Example 1: hardcoded data
    //     // results.push({
    //     //     "ID":"02BD2137-0890-1EEA-A6C2-VV55C19787CD",
    //     //     "nameFirst": "Chistiano",
    //     //     "nameLast": "Ronaldo"
    //     // });


    //     //Example 2: Use Select on DB table
    //     //results = await cds.tx(req).run(SELECT.from(employees).limit(10));

    //     //Example 3: Use Select on DB table with where
    //     //results = await cds.tx(req).run(SELECT.from(employees).limit(10).where({"nameFirst":"Susan"}));

    //     //Example 4:Caller will pass the condition like ID
    //     //use /Entity/key
    //     var whereCondition = req.data;
    //     console.log(whereCondition);
    //     if(whereCondition.hasOwnProperty("ID")){
    //         results = await cds.tx(req).run(SELECT.from(employees).limit(10).where(whereCondition));
    //     }else{
    //         results = await cds.tx(req).run(SELECT.from(employees).limit(1));
    //     }


    //     return results;


    // });

};

module.exports = mysrvdemo;