// using { anubhav.db.master, anubhav.db.transaction } from '../db/datamodel';

// service CatalogService {

//     entity EmployeeSet as projection on master.employees;
//     entity BusinessPartnerSet as projection on master.businesspartner;
//     entity PurchaseOrderSet as projection on transaction.purchaseorder;
//     entity POItemSet as projection on transaction.purchaseorder;

// }
using { anubhav.db } from '../db/datamodel';
using { cappo.cds } from '../db/CDSViews';


service CatalogService @(path:'CatalogService') {

    // @Capabilities : { Insertable,Updatable, Deletable: false }
    entity BusinessPartnerSet as projection on db.master.businesspartner;
    entity AddressSet as projection on db.master.address;
    // @readonly
    entity EmployeeSet as projection on db.master.employees actions{
        action increase();
    };
    entity PurchaseOrderItems as projection on db.transaction.poitems;
    function getOrderDefaults() returns POs;
    entity POs @(
        odata.draft.enabled: true,
        Common.DefaultValuesFunction: 'getOrderDefaults'
    ) as projection on db.transaction.purchaseorder{
        CASE OVERALL_STATUS
            WHEN 'A' then 'Approved'    
            WHEN 'X' then 'Rejected'    
            WHEN 'N' then 'New'    
            WHEN 'D' then 'Delivered'    
            WHEN 'P' then 'Pending' end as OverallStatus: String(15),
        CASE OVERALL_STATUS
            WHEN 'A' then 3    
            WHEN 'X' then 1    
            WHEN 'N' then 2    
            WHEN 'D' then 3    
            WHEN 'P' then 2 end as ColorCode: Integer,            
            *,
            Items
    } actions{
        action boost();
        function largestOrder() returns array of POs;
    };
    // entity POs as projection on db.transaction.purchaseorder{
    //     *,
    //     round(GROSS_AMOUNT) as GROSS_AMOUNT: Decimal(10,2),
    //     Items: redirected to PurchaseOrderItems
    // }actions{
    //     action boost();
    //     function largestOrder() returns array of POs;
    // };
    // entity CProductValuesView as projection on cds.CDSViews.CProductValuesView;
    entity ProductSet as projection on db.master.product;

}
