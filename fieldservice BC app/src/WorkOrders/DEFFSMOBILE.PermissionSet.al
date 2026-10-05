namespace DEF.FieldService.WorkOrders;

using Microsoft.Inventory.Item;
using Microsoft.Projects.Resources.Resource;

/// <summary>
/// Technicians: work through their orders and record material.
/// </summary>
permissionset 50111 "DEF FS MOBILE"
{
    Assignable = true;
    Caption = 'Field Service Mobile';

    Permissions =
        tabledata "DEF FS Work Order Header" = RM,
        tabledata "DEF FS Work Order Line" = RIM,
        tabledata "DEF FS Setup" = R,
        tabledata "DEF FS Mobile Cue" = RIM,
        tabledata "DEF FS Status Log Entry" = RI,
        tabledata Item = R,
        tabledata Resource = R,
        table "DEF FS Work Order Header" = X,
        table "DEF FS Work Order Line" = X,
        table "DEF FS Setup" = X,
        table "DEF FS Mobile Cue" = X,
        table "DEF FS Status Log Entry" = X,
        page "DEF FS Mobile Order List" = X,
        page "DEF FS Mobile Order Card" = X,
        page "DEF FS Line Subform" = X,
        page "DEF FS Add Item Lookup" = X,
        page "DEF FS Item Add Dialog" = X,
        page "DEF FS Job Completion Dialog" = X,
        page "DEF FS Mobile Activities" = X,
        page "DEF FS Mobile Role Center" = X,
        page "DEF FS Status Log Entries" = X,
        codeunit "DEF FS Status Mgt" = X,
        codeunit "DEF FS Work Order Item Mgt" = X,
        codeunit "DEF FS Technician Mgt" = X,
        codeunit "DEF FS Work Time Mgt" = X;
}
