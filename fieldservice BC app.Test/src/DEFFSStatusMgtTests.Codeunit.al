namespace DEF.FieldService.Test;

using DEF.FieldService.WorkOrders;

codeunit 50190 "DEF FS Status Mgt Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        TestLibrary: Codeunit "DEF FS Test Library";
        StatusMgt: Codeunit "DEF FS Status Mgt";

    [Test]
    procedure IsTransitionAllowed_FromOpen_AllowsTravelAndStart()
    var
        Status: Enum "DEF FS Order Status";
    begin
        TestLibrary.IsTrue(StatusMgt.IsTransitionAllowed(Status::Open, Status::Traveling), 'Open -> Traveling');
        TestLibrary.IsTrue(StatusMgt.IsTransitionAllowed(Status::Open, Status::"In Progress"), 'Open -> In Progress');
        TestLibrary.IsFalse(StatusMgt.IsTransitionAllowed(Status::Open, Status::Done), 'Open -> Done');
    end;

    [Test]
    procedure IsTransitionAllowed_FromDone_AllowsNothing()
    var
        Status: Enum "DEF FS Order Status";
        Ordinal: Integer;
    begin
        foreach Ordinal in Enum::"DEF FS Order Status".Ordinals() do
            TestLibrary.IsFalse(StatusMgt.IsTransitionAllowed(Status::Done, Enum::"DEF FS Order Status".FromInteger(Ordinal)), 'Done must be final');
    end;

    [Test]
    procedure IsTransitionAllowed_SameStatus_ReturnsFalse()
    var
        Status: Enum "DEF FS Order Status";
    begin
        TestLibrary.IsFalse(StatusMgt.IsTransitionAllowed(Status::Paused, Status::Paused), 'Paused -> Paused');
    end;

    [Test]
    procedure IsTransitionAllowed_FromFailed_AllowsReopen()
    var
        Status: Enum "DEF FS Order Status";
    begin
        TestLibrary.IsTrue(StatusMgt.IsTransitionAllowed(Status::Failed, Status::Open), 'Failed -> Open');
    end;

    [Test]
    procedure SetStatus_OpenToDone_ThrowsError()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);

        asserterror StatusMgt.SetStatus(WorkOrderHeader, WorkOrderHeader.Status::Done);

        // asserterror rolls back the whole test transaction, including the inserted work order,
        // so the unchanged status is checked on the record variable instead of re-reading it.
        TestLibrary.ExpectedError('cannot change from status');
        TestLibrary.AreEqual("DEF FS Order Status"::Open, WorkOrderHeader.Status, 'Status must not change');
    end;

    [Test]
    procedure SetStatus_OpenToTraveling_SavesStatus()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);

        StatusMgt.SetStatus(WorkOrderHeader, WorkOrderHeader.Status::Traveling);

        WorkOrderHeader.Get(WorkOrderHeader."No.");
        TestLibrary.AreEqual("DEF FS Order Status"::Traveling, WorkOrderHeader.Status, 'Status after travel');
    end;

    [Test]
    procedure Complete_FailedWithoutNote_ThrowsError()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::"In Progress", false);

        asserterror StatusMgt.Complete(WorkOrderHeader, "DEF FS Completion Result"::Failed, '   ');

        TestLibrary.ExpectedError('why the job failed');
    end;

    [Test]
    procedure Complete_FailedWithNote_StoresNoteAndStatus()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::"In Progress", false);

        StatusMgt.Complete(WorkOrderHeader, "DEF FS Completion Result"::Failed, 'Spare part missing');

        WorkOrderHeader.Get(WorkOrderHeader."No.");
        TestLibrary.AreEqual("DEF FS Order Status"::Failed, WorkOrderHeader.Status, 'Status after failure');
        TestLibrary.AreEqual('Spare part missing', WorkOrderHeader."Completion Note", 'Completion note');
    end;

    [Test]
    procedure Complete_Completed_SetsStatusDone()
    var
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::"In Progress", false);

        StatusMgt.Complete(WorkOrderHeader, "DEF FS Completion Result"::Completed, '');

        WorkOrderHeader.Get(WorkOrderHeader."No.");
        TestLibrary.AreEqual("DEF FS Order Status"::Done, WorkOrderHeader.Status, 'Status after completion');
    end;

    [Test]
    procedure SetStatus_OpenToTraveling_WritesLogEntry()
    var
        StatusLogEntry: Record "DEF FS Status Log Entry";
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Open, false);
        WorkOrderHeader."Assigned Resource No." := TestLibrary.CreateTechnician(TestLibrary.UniqueCode());
        WorkOrderHeader.Modify(true);

        StatusMgt.SetStatus(WorkOrderHeader, WorkOrderHeader.Status::Traveling);

        StatusLogEntry.SetRange("Work Order No.", WorkOrderHeader."No.");
        TestLibrary.AreEqual(1, StatusLogEntry.Count(), 'Number of log entries');
        StatusLogEntry.FindFirst();
        TestLibrary.AreEqual("DEF FS Order Status"::Open, StatusLogEntry."From Status", 'From status');
        TestLibrary.AreEqual("DEF FS Order Status"::Traveling, StatusLogEntry."To Status", 'To status');
        TestLibrary.AreEqual(WorkOrderHeader."Assigned Resource No.", StatusLogEntry."Resource No.", 'Technician');
        TestLibrary.AreEqual(UpperCase(UserId()), StatusLogEntry."User ID", 'User');
        TestLibrary.IsTrue(StatusLogEntry."Changed At" <> 0DT, 'Changed at must be set');
    end;

    [Test]
    procedure Complete_FailedWithNote_LogsNote()
    var
        StatusLogEntry: Record "DEF FS Status Log Entry";
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::"In Progress", false);

        StatusMgt.Complete(WorkOrderHeader, "DEF FS Completion Result"::Failed, 'Customer not at home');

        StatusLogEntry.SetRange("Work Order No.", WorkOrderHeader."No.");
        StatusLogEntry.FindFirst();
        TestLibrary.AreEqual("DEF FS Order Status"::Failed, StatusLogEntry."To Status", 'To status');
        TestLibrary.AreEqual('Customer not at home', StatusLogEntry.Note, 'Note');
    end;

    [Test]
    procedure SetStatus_NotAllowed_WritesNoLogEntry()
    var
        StatusLogEntry: Record "DEF FS Status Log Entry";
        WorkOrderHeader: Record "DEF FS Work Order Header";
    begin
        WorkOrderHeader := TestLibrary.CreateWorkOrder("DEF FS Order Status"::Done, false);

        asserterror StatusMgt.SetStatus(WorkOrderHeader, WorkOrderHeader.Status::Open);

        TestLibrary.ExpectedError('cannot change from status');
        StatusLogEntry.SetRange("Work Order No.", WorkOrderHeader."No.");
        TestLibrary.IsTrue(StatusLogEntry.IsEmpty(), 'No log entry for a rejected change');
    end;
}
