namespace DEF.FieldService.Test;

using DEF.FieldService.WorkOrders;
using Microsoft.Foundation.NoSeries;
using Microsoft.Projects.Resources.Resource;

/// <summary>
/// Assertions and test data helpers shared by the Field Service tests.
/// </summary>
codeunit 50193 "DEF FS Test Library"
{
    var
        AreEqualErr: Label '%1 Expected: %2, Actual: %3.', Comment = '%1 = message, %2 = expected value, %3 = actual value';
        ConditionFailedErr: Label 'Assertion failed: %1', Comment = '%1 = message';
        ExpectedErrorErr: Label 'Expected an error containing "%1", but got "%2".', Comment = '%1 = expected text, %2 = actual error text';

    procedure AreEqual(Expected: Variant; Actual: Variant; Message: Text)
    begin
        if Format(Expected, 0, 9) <> Format(Actual, 0, 9) then
            Error(AreEqualErr, Message, Format(Expected, 0, 9), Format(Actual, 0, 9));
    end;

    procedure IsTrue(Condition: Boolean; Message: Text)
    begin
        if not Condition then
            Error(ConditionFailedErr, Message);
    end;

    procedure IsFalse(Condition: Boolean; Message: Text)
    begin
        IsTrue(not Condition, Message);
    end;

    procedure ExpectedError(ExpectedText: Text)
    begin
        if StrPos(GetLastErrorText(), ExpectedText) = 0 then
            Error(ExpectedErrorErr, ExpectedText, GetLastErrorText());
    end;

    procedure UniqueCode(): Code[20]
    begin
        exit(CopyStr('T' + DelChr(Format(CreateGuid()), '=', '{}-'), 1, 20));
    end;

    procedure CreateWorkOrder(Status: Enum "DEF FS Order Status"; IsDemo: Boolean) WorkOrderHeader: Record "DEF FS Work Order Header"
    begin
        WorkOrderHeader.Init();
        WorkOrderHeader."No." := UniqueCode();
        WorkOrderHeader.Description := WorkOrderHeader."No.";
        WorkOrderHeader.Status := Status;
        WorkOrderHeader."Demo Data" := IsDemo;
        WorkOrderHeader.Insert(true);
    end;

    procedure CreateWorkOrderLine(WorkOrderNo: Code[20]; LineNo: Integer)
    var
        WorkOrderLine: Record "DEF FS Work Order Line";
    begin
        WorkOrderLine.Init();
        WorkOrderLine."Document No." := WorkOrderNo;
        WorkOrderLine."Line No." := LineNo;
        WorkOrderLine.Quantity := 1;
        WorkOrderLine.Insert(true);
    end;

    /// <summary>
    /// Creates a person resource that is linked to the given user name. The user does not have to exist.
    /// </summary>
    procedure CreateTechnician(UserName: Code[50]) ResourceNo: Code[20]
    var
        Resource: Record Resource;
    begin
        ResourceNo := UniqueCode();
        Resource.Init();
        Resource."No." := ResourceNo;
        Resource.Name := ResourceNo;
        Resource.Type := Resource.Type::Person;
        Resource.Insert(true);
        Resource.Validate("DEF FS User ID", UserName);
        Resource.Modify(true);
    end;

    procedure CreateAssignedWorkOrder(ResourceNo: Code[20]; Status: Enum "DEF FS Order Status"; PlannedDate: Date) WorkOrderHeader: Record "DEF FS Work Order Header"
    begin
        WorkOrderHeader := CreateWorkOrder(Status, false);
        WorkOrderHeader."Assigned Resource No." := ResourceNo;
        WorkOrderHeader."Planned Date" := PlannedDate;
        WorkOrderHeader.Modify(true);
    end;

    procedure InsertStatusLogEntry(WorkOrderNo: Code[20]; ToStatus: Enum "DEF FS Order Status"; ChangedAt: DateTime)
    var
        StatusLogEntry: Record "DEF FS Status Log Entry";
    begin
        StatusLogEntry.Init();
        StatusLogEntry."Work Order No." := WorkOrderNo;
        StatusLogEntry."To Status" := ToStatus;
        StatusLogEntry."Changed At" := ChangedAt;
        StatusLogEntry.Insert(true);
    end;

    /// <summary>
    /// Points the Field Service Setup to a new number series, so tests do not depend on the company's configuration.
    /// </summary>
    procedure UseNewWorkOrderNoSeries(StartingNo: Code[20]) NoSeriesCode: Code[20]
    var
        FSSetup: Record "DEF FS Setup";
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        NoSeriesCode := CopyStr(UniqueCode(), 1, MaxStrLen(NoSeries.Code));
        NoSeries.Init();
        NoSeries.Code := NoSeriesCode;
        NoSeries."Default Nos." := true;
        NoSeries."Manual Nos." := true;
        NoSeries.Insert(true);

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := NoSeriesCode;
        NoSeriesLine."Line No." := 10000;
        NoSeriesLine.Validate("Starting No.", StartingNo);
        NoSeriesLine.Validate("Increment-by No.", 1);
        NoSeriesLine.Insert(true);

        FSSetup.InsertIfNotExists();
        FSSetup."Work Order Nos." := NoSeriesCode;
        FSSetup."Demo Item Template Code" := '';
        FSSetup.Modify(true);
    end;
}
