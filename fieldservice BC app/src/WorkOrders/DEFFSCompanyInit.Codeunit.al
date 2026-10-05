namespace DEF.FieldService.WorkOrders;

using Microsoft.Foundation.Company;
using Microsoft.Foundation.NoSeries;

/// <summary>
/// Creates the configuration a company needs to use Field Service. Safe to run more than once.
/// </summary>
codeunit 50127 "DEF FS Company Init"
{
    var
        WorkOrderNoSeriesTok: Label 'FS-WO', Locked = true;
        WorkOrderNoSeriesDescriptionLbl: Label 'Field Service Work Orders', MaxLength = 100;
        WorkOrderStartingNoTok: Label 'WO-00001', Locked = true;

    procedure InitializeCompany()
    var
        FSSetup: Record "DEF FS Setup";
        MobileCue: Record "DEF FS Mobile Cue";
    begin
        FSSetup.InsertIfNotExists();
        MobileCue.GetOrCreate();

        if FSSetup."Work Order Nos." <> '' then
            exit;

        FSSetup."Work Order Nos." := EnsureWorkOrderNoSeries();
        FSSetup.Modify(true);
    end;

    local procedure EnsureWorkOrderNoSeries(): Code[20]
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if NoSeries.Get(WorkOrderNoSeriesTok) then
            exit(NoSeries.Code);

        NoSeries.Init();
        NoSeries.Code := WorkOrderNoSeriesTok;
        NoSeries.Description := WorkOrderNoSeriesDescriptionLbl;
        NoSeries."Default Nos." := true;
        NoSeries."Manual Nos." := true;
        NoSeries.Insert(true);

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := NoSeries.Code;
        NoSeriesLine."Line No." := 10000;
        NoSeriesLine.Validate("Starting No.", WorkOrderStartingNoTok);
        NoSeriesLine.Validate("Increment-by No.", 1);
        NoSeriesLine.Insert(true);

        exit(NoSeries.Code);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", OnCompanyInitialize, '', false, false)]
    local procedure HandleOnCompanyInitialize()
    begin
        InitializeCompany();
    end;
}
