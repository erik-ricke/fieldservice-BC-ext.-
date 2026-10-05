namespace DEF.FieldService.WorkOrders;

/// <summary>
/// Owns all status changes of field service work orders, including which transitions are allowed.
/// </summary>
codeunit 50126 "DEF FS Status Mgt"
{
    var
        TransitionNotAllowedErr: Label 'Work order %1 cannot change from status %2 to status %3.', Comment = '%1 = work order number, %2 = current status, %3 = requested status';
        FailureNoteRequiredErr: Label 'Enter a note that explains why the job failed.';
        JobCompletedMsg: Label 'The job was marked as completed.';
        JobFailedMsg: Label 'The job was marked as failed.\Note: %1', Comment = '%1 = note entered by the technician';
        JobPausedMsg: Label 'The job was paused.';

    /// <summary>
    /// Changes the status of the work order after checking that the transition is allowed, and logs the change.
    /// </summary>
    procedure SetStatus(var WorkOrderHeader: Record "DEF FS Work Order Header"; NewStatus: Enum "DEF FS Order Status")
    begin
        ChangeStatus(WorkOrderHeader, NewStatus, '');
    end;

    /// <summary>
    /// Completes, fails or pauses the work order. A note is mandatory when the job failed.
    /// </summary>
    procedure Complete(var WorkOrderHeader: Record "DEF FS Work Order Header"; CompletionResult: Enum "DEF FS Completion Result"; Note: Text[250])
    begin
        if (CompletionResult = CompletionResult::Failed) and (Note.Trim() = '') then
            Error(FailureNoteRequiredErr);

        if Note.Trim() <> '' then
            WorkOrderHeader."Completion Note" := Note;
        ChangeStatus(WorkOrderHeader, GetStatusForResult(CompletionResult), Note);
    end;

    /// <summary>
    /// Asks the technician for the result of the job and applies it to the work order.
    /// </summary>
    procedure CompleteWithDialog(var WorkOrderHeader: Record "DEF FS Work Order Header")
    var
        JobCompletionDialog: Page "DEF FS Job Completion Dialog";
        CompletionResult: Enum "DEF FS Completion Result";
        Note: Text[250];
    begin
        if JobCompletionDialog.RunModal() <> Action::OK then
            exit;

        CompletionResult := JobCompletionDialog.GetCompletionResult();
        Note := JobCompletionDialog.GetNote();
        Complete(WorkOrderHeader, CompletionResult, Note);

        case CompletionResult of
            CompletionResult::Completed:
                Message(JobCompletedMsg);
            CompletionResult::Failed:
                Message(JobFailedMsg, Note);
            CompletionResult::Paused:
                Message(JobPausedMsg);
        end;
    end;

    procedure GetStatusForResult(CompletionResult: Enum "DEF FS Completion Result"): Enum "DEF FS Order Status"
    begin
        case CompletionResult of
            CompletionResult::Completed:
                exit("DEF FS Order Status"::Done);
            CompletionResult::Failed:
                exit("DEF FS Order Status"::Failed);
            CompletionResult::Paused:
                exit("DEF FS Order Status"::Paused);
        end;
    end;

    /// <summary>
    /// Returns whether a work order may move from one status to another.
    /// Done is final; a failed job can be reopened.
    /// </summary>
    procedure IsTransitionAllowed(FromStatus: Enum "DEF FS Order Status"; ToStatus: Enum "DEF FS Order Status"): Boolean
    var
        IsAllowed: Boolean;
        IsHandled: Boolean;
    begin
        OnBeforeIsTransitionAllowed(FromStatus, ToStatus, IsAllowed, IsHandled);
        if IsHandled then
            exit(IsAllowed);

        if FromStatus = ToStatus then
            exit(false);

        case FromStatus of
            FromStatus::Open:
                exit(ToStatus in [ToStatus::Traveling, ToStatus::"In Progress"]);
            FromStatus::Traveling:
                exit(ToStatus in [ToStatus::"In Progress", ToStatus::Paused]);
            FromStatus::"In Progress":
                exit(ToStatus in [ToStatus::Paused, ToStatus::Done, ToStatus::Failed]);
            FromStatus::Paused:
                exit(ToStatus in [ToStatus::Traveling, ToStatus::"In Progress", ToStatus::Done, ToStatus::Failed]);
            FromStatus::Failed:
                exit(ToStatus = ToStatus::Open);
        end;
        exit(false);
    end;

    local procedure ChangeStatus(var WorkOrderHeader: Record "DEF FS Work Order Header"; NewStatus: Enum "DEF FS Order Status"; Note: Text[250])
    var
        OldStatus: Enum "DEF FS Order Status";
    begin
        if not IsTransitionAllowed(WorkOrderHeader.Status, NewStatus) then
            Error(TransitionNotAllowedErr, WorkOrderHeader."No.", WorkOrderHeader.Status, NewStatus);

        OldStatus := WorkOrderHeader.Status;
        WorkOrderHeader.Status := NewStatus;
        WorkOrderHeader.Modify(true);
        InsertStatusLogEntry(WorkOrderHeader, OldStatus, Note);

        OnAfterSetStatus(WorkOrderHeader, OldStatus);
    end;

    local procedure InsertStatusLogEntry(WorkOrderHeader: Record "DEF FS Work Order Header"; OldStatus: Enum "DEF FS Order Status"; Note: Text[250])
    var
        StatusLogEntry: Record "DEF FS Status Log Entry";
    begin
        StatusLogEntry.Init();
        StatusLogEntry."Work Order No." := WorkOrderHeader."No.";
        StatusLogEntry."From Status" := OldStatus;
        StatusLogEntry."To Status" := WorkOrderHeader.Status;
        StatusLogEntry."Changed At" := CurrentDateTime();
        StatusLogEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(StatusLogEntry."User ID"));
        StatusLogEntry."Resource No." := WorkOrderHeader."Assigned Resource No.";
        StatusLogEntry.Note := Note;
        StatusLogEntry.Insert(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetStatus(var WorkOrderHeader: Record "DEF FS Work Order Header"; OldStatus: Enum "DEF FS Order Status")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeIsTransitionAllowed(FromStatus: Enum "DEF FS Order Status"; ToStatus: Enum "DEF FS Order Status"; var IsAllowed: Boolean; var IsHandled: Boolean)
    begin
    end;
}
