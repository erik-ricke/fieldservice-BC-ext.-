namespace DEF.FieldService.WorkOrders;

using Microsoft.Inventory.Item;

permissionset 50111 "DEF FS MOBILE"
{
    Assignable = true;
    Caption = 'Field Service Mobile';

    Permissions =
        tabledata "DEF FS Work Order Header" = RIMD,
        tabledata "DEF FS Work Order Line" = RIMD,
        tabledata Item = R,
        tabledata "DEF FS Demo Setup" = RIMD,
        tabledata "DEF FS Mobile Cue" = R,
        page "DEF FS Mobile Order List" = X,
        page "DEF FS Office Overview" = X,
        page "DEF FS Add Item Lookup" = X,
        page "DEF FS Item Add Dialog" = X,
        page "DEF FS Job Completion Dialog" = X,
        page "DEF FS Mobile Order Card" = X,
        page "DEF FS Line Subform" = X,
        page "DEF FS Demo Setup" = X,
        page "DEF FS Mobile Activities" = X,
        page "DEF FS Mobile Role Center" = X,
        codeunit "DEF FS Demo Data Mgt" = X,
        codeunit "DEF FS Work Order Item Mgt" = X;
}