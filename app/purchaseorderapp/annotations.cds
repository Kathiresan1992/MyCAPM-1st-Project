using CatalogService as service from '../../srv/CatalogService';

annotate service.POs with @(
    UI.SelectionFields: [
        PO_ID,
        GROSS_AMOUNT,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY
    ],
    UI.LineItem: [
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
        {
            $Type : 'UI.DataField',
            Value : OverallStatus,
            Criticality: ColorCode
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.boost',
            Label : 'Boost',
            Inline : true,
        },
    ],
    UI.HeaderInfo: {
        TypeName: 'PO',
        TypeNamePlural: 'Purchase Orders',
        Title: {
            Label: 'PO Number',
            Value: 'PO_ID'
        },
        Description: {
            Value: PARTNER_GUID.COMPANY_NAME
        },
        ImageUrl : 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/SAP_2011_logo.svg/800px-SAP_2011_logo.svg.png',
    },
    UI.Facets: [
        {
            $Type: 'UI.CollectionFacet',
            Label : 'More Information',
            Facets : [
                {
                    $Type: 'UI.ReferenceFacet',
                    Label : 'Details',
                    Target : '@UI.FieldGroup#Spiderman',
                },
                {
                    $Type: 'UI.ReferenceFacet',
                    Label: 'Pricing',
                    Target: '@UI.FieldGroup#Superman'
                }
            ],
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'PO Items',
            Target : 'Items/@UI.LineItem',
        }
    ],
    UI.FieldGroup #Spiderman:{
        Data: [
            {
                $Type: 'UI.DataField',
                Value: ID,
            },
            {
                $Type: 'UI.DataField',
                Value: PO_ID,
            },
            {
                $Type: 'UI.DataField',
                Value: PARTNER_GUID_NODE_KEY,
            },
            {
                $Type: 'UI.DataField',
                Value: OVERALL_STATUS,
            },                                    
        ]
    },
    UI.FieldGroup #Superman:{
        Data: [
            {
                $Type: 'UI.DataField',
                Value: GROSS_AMOUNT,
            },
            {
                $Type: 'UI.DataField',
                Value: NET_AMOUNT,
            },
            {
                $Type: 'UI.DataField',
                Value: TAX_AMOUNT,
            },
            {
                $Type: 'UI.DataField',
                Value: CURRENCY_code,
            },                                    
        ]
    }    
);

annotate service.PurchaseOrderItems with @(
     UI.LineItem:[
        {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT_GUID.PRODUCT_ID
        },
        {
            $Type: 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },        
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
     ],
     UI.HeaderInfo: {
        TypeName : 'PO Item',
        TypeNamePlural : 'PO Items',
        Title : {
            Label: 'Po Items ID',
            Value : PO_ITEM_POS,
        },
        Description : {           
            Value : PRODUCT_GUID.DESCRIPTION,        
        },
     },
     UI.Facets:[
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Item Data',
            Target : '@UI.FieldGroup#ItemInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Price Data',
            Target : '@UI.FieldGroup#Price',
        }    ,    
     ],
     UI.FieldGroup #ItemInfo:{
        Label : 'Item Data',
        Data: [
            {
                $Type : 'UI.DataField',
                Value : PO_ITEM_POS,
            },
            {
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID_NODE_KEY,
            }                                    
        ]
     },
     UI.FieldGroup #Price:{
        Label : 'Price Data',
        Data: [
            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },    
            {
                $Type : 'UI.DataField',
                Value : CURRENCY_code,
            },                     
        ]
     }

);

annotate CatalogService.POs with{
    PARTNER_GUID @(
        Common.Text: PARTNER_GUID.COMPANY_NAME,
        Common.ValueList.entity: CatalogService.BusinessPartnerSet
    )
};

annotate CatalogService.PurchaseOrderItems with{
    PRODUCT_GUID @(
        Common.Text: PRODUCT_GUID.DESCRIPTION,
        Common.ValueList.entity: CatalogService.ProductSet
    )
};

@cds.odata.valuelist
annotate CatalogService.BusinessPartnerSet with @(
    UI.Identification:[{
        $Type : 'UI.DataField',
        Value : COMPANY_NAME,
    },
    {
        $Type : 'UI.DataField',
        Value : ADDRESS_GUID.COUNTRY,
    },]
);

@cds.odata.valuelist
annotate CatalogService.ProductSet with @(
    UI.Identification:[{
        $Type : 'UI.DataField',
        Value : DESCRIPTION,
    }]
);