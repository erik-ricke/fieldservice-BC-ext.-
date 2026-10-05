namespace DEF.FieldService.WorkOrders;

using Microsoft.Foundation.NoSeries;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Projects.Resources.Ledger;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Sales.Customer;

/// <summary>
/// Office staff and administrators: create and plan work orders, maintain setup and demo data.
/// </summary>
permissionset 50129 "DEF FS ADMIN"
{
    Assignable = true;
    Caption = 'Field Service Admin';
    IncludedPermissionSets = "DEF FS MOBILE";

    Permissions =
        tabledata "DEF FS Work Order Header" = RIMD,
        tabledata "DEF FS Work Order Line" = RIMD,
        tabledata "DEF FS Setup" = RIMD,
        tabledata "DEF FS Demo Setup" = RIMD,
        tabledata "DEF FS Demo Record" = RIMD,
        tabledata Customer = R,
        tabledata "No. Series" = RI,
        tabledata "No. Series Line" = RIM,
        tabledata Item = RIMD,
        tabledata "Item Templ." = R,
        tabledata "Item Unit of Measure" = RIMD,
        tabledata "Item Ledger Entry" = R,
        tabledata Resource = RIMD,
        tabledata "Res. Ledger Entry" = R,
        table "DEF FS Demo Setup" = X,
        table "DEF FS Demo Record" = X,
        page "DEF FS Work Order Entry" = X,
        page "DEF FS Work Order Card" = X,
        page "DEF FS Office Overview" = X,
        page "DEF FS Setup" = X,
        page "DEF FS Demo Setup" = X,
        codeunit "DEF FS Demo Data Mgt" = X,
        codeunit "DEF FS Company Init" = X;
}
