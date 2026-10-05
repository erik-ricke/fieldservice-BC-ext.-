namespace DEF.FieldService.Test;

using DEF.FieldService.WorkOrders;

codeunit 50195 "DEF FS Work Time Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        TestLibrary: Codeunit "DEF FS Test Library";
        WorkTimeMgt: Codeunit "DEF FS Work Time Mgt";
        MinuteMs: Integer;

    [Test]
    procedure CalcTimes_NoLogEntries_ReturnsZero()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
        TravelTime: Duration;
        WorkTime: Duration;
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);

        WorkTimeMgt.CalcTimes(WorkOrderHeader."No.", CurrentDateTime(), TravelTime, WorkTime);

        AssertMinutes(0, TravelTime, 'Travel time');
        AssertMinutes(0, WorkTime, 'Work time');
    end;

    [Test]
    procedure CalcTimes_TravelWorkPauseWorkDone_SumsTimePerStatus()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
        Start: DateTime;
        TravelTime: Duration;
        WorkTime: Duration;
    begin
        Initialize();
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Done, false);
        Start := CreateDateTime(DMY2Date(15, 6, 2026), 080000T);
        TestLibrary.InsertStatusLogEntry(WorkOrderHeader."No.", "DEF FS Order Status"::Traveling, Start);
        TestLibrary.InsertStatusLogEntry(WorkOrderHeader."No.", "DEF FS Order Status"::"In Progress", Start + 30 * MinuteMs);
        TestLibrary.InsertStatusLogEntry(WorkOrderHeader."No.", "DEF FS Order Status"::Paused, Start + 90 * MinuteMs);
        TestLibrary.InsertStatusLogEntry(WorkOrderHeader."No.", "DEF FS Order Status"::"In Progress", Start + 120 * MinuteMs);
        TestLibrary.InsertStatusLogEntry(WorkOrderHeader."No.", "DEF FS Order Status"::Done, Start + 135 * MinuteMs);

        WorkTimeMgt.CalcTimes(WorkOrderHeader."No.", Start + 600 * MinuteMs, TravelTime, WorkTime);

        AssertMinutes(30, TravelTime, 'Travel time');
        AssertMinutes(75, WorkTime, 'Work time without the pause');
    end;

    [Test]
    procedure CalcTimes_StillInProgress_CountsUntilGivenTime()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
        Start: DateTime;
        TravelTime: Duration;
        WorkTime: Duration;
    begin
        Initialize();
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::"In Progress", false);
        Start := CreateDateTime(DMY2Date(15, 6, 2026), 080000T);
        TestLibrary.InsertStatusLogEntry(WorkOrderHeader."No.", "DEF FS Order Status"::"In Progress", Start);

        WorkTimeMgt.CalcTimes(WorkOrderHeader."No.", Start + 45 * MinuteMs, TravelTime, WorkTime);

        AssertMinutes(0, TravelTime, 'Travel time');
        AssertMinutes(45, WorkTime, 'Work time so far');
    end;

    local procedure Initialize()
    begin
        MinuteMs := 60 * 1000;
    end;

    local procedure AssertMinutes(ExpectedMinutes: Integer; Actual: Duration; Message: Text)
    var
        Expected: Duration;
    begin
        Expected := ExpectedMinutes * 60 * 1000;
        TestLibrary.AreEqual(Expected, Actual, Message);
    end;
}
