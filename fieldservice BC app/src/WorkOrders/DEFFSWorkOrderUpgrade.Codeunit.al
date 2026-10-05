namespace DEF.FieldService.WorkOrders;

using System.Upgrade;

codeunit 50114 "DEF FS Work Order Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        CompanyInit: Codeunit "DEF FS Company Init";
        UpgradeTag: Codeunit "Upgrade Tag";
    begin
        CompanyInit.InitializeCompany();

        if UpgradeTag.HasUpgradeTag(GetMarkDemoOrdersUpgradeTag()) then
            exit;

        MarkExistingDemoOrders();
        UpgradeTag.SetUpgradeTag(GetMarkDemoOrdersUpgradeTag());
    end;

    /// <summary>
    /// Versions before 1.2 did not flag demo work orders. Flag the orders that were generated from the demo setup rows,
    /// so that "Delete Demo Data" can find them without touching real work orders.
    /// </summary>
    local procedure MarkExistingDemoOrders()
    var
        DemoSetup: Record "DEF FS Demo Setup";
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        if not DemoSetup.FindSet() then
            exit;

        repeat
            if WorkOrderHeader.Get(DemoSetup."Work Order No.") then
                if not WorkOrderHeader."Demo Data" then begin
                    WorkOrderHeader."Demo Data" := true;
                    WorkOrderHeader.Modify(false);
                end;
        until DemoSetup.Next() = 0;
    end;

    local procedure GetMarkDemoOrdersUpgradeTag(): Code[250]
    begin
        exit('DEF-FS-MARK-DEMO-ORDERS-20261005');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", OnGetPerCompanyUpgradeTags, '', false, false)]
    local procedure RegisterPerCompanyUpgradeTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(GetMarkDemoOrdersUpgradeTag());
    end;
}
