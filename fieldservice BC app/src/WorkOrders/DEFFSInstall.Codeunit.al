namespace DEF.FieldService.WorkOrders;

codeunit 50110 "DEF FS Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        CompanyInit: Codeunit "DEF FS Company Init";
    begin
        CompanyInit.InitializeCompany();
    end;
}
