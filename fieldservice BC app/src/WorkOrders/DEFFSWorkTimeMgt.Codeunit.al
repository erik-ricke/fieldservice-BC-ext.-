namespace DEF.FieldService.WorkOrders;

/// <summary>
/// Calculates how long a technician traveled to and worked on a work order, based on its status history.
/// </summary>
codeunit 50135 "DEF FS Work Time Mgt"
{
    /// <summary>
    /// Adds up the time the work order spent in status Traveling and In Progress.
    /// A status that is still active counts until UntilDateTime.
    /// </summary>
    procedure CalcTimes(WorkOrderNo: Code[20]; UntilDateTime: DateTime; var TravelTime: Duration; var WorkTime: Duration)
    var
        StatusLogEntry: Record "DEF FS Status Log Entry";
        CurrentStatus: Enum "DEF FS Order Status";
        CurrentSince: DateTime;
    begin
        TravelTime := 0;
        WorkTime := 0;

        StatusLogEntry.SetCurrentKey("Work Order No.", "Changed At");
        StatusLogEntry.SetRange("Work Order No.", WorkOrderNo);
        StatusLogEntry.SetLoadFields("To Status", "Changed At");
        if not StatusLogEntry.FindSet() then
            exit;

        CurrentStatus := StatusLogEntry."To Status";
        CurrentSince := StatusLogEntry."Changed At";
        while StatusLogEntry.Next() <> 0 do begin
            AddInterval(CurrentStatus, CurrentSince, StatusLogEntry."Changed At", TravelTime, WorkTime);
            CurrentStatus := StatusLogEntry."To Status";
            CurrentSince := StatusLogEntry."Changed At";
        end;
        AddInterval(CurrentStatus, CurrentSince, UntilDateTime, TravelTime, WorkTime);
    end;

    local procedure AddInterval(Status: Enum "DEF FS Order Status"; StartDateTime: DateTime; EndDateTime: DateTime; var TravelTime: Duration; var WorkTime: Duration)
    begin
        if EndDateTime <= StartDateTime then
            exit;

        case Status of
            Status::Traveling:
                TravelTime += EndDateTime - StartDateTime;
            Status::"In Progress":
                WorkTime += EndDateTime - StartDateTime;
        end;
    end;
}
