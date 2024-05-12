using { anubhav.db } from '../db/datamodel';

service myService @(path:'myService'){
    function hello(name: String(30)) returns String;    

    entity ReadEmployeeSrv as projection on db.master.employees;
}