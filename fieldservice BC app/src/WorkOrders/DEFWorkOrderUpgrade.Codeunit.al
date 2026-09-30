namespace DEF.FieldService.WorkOrders;

codeunit 50114 "DEF FS Work Order Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    begin
        EnsureMobileCueRecord();
    end;

    local procedure EnsureMobileCueRecord()
    var
        MobileCue: Record "DEF FS Mobile Cue";
    begin
        if MobileCue.Get('DEFAULT') then
            exit;

        MobileCue.Init();
        MobileCue."Primary Key" := 'DEFAULT';
        MobileCue.Insert(false);
    end;
}