namespace DEF.FieldService.WorkOrders;

codeunit 50110 "DEF FS Demo Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        InsertCueRecord();
    end;

    local procedure InsertCueRecord()
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