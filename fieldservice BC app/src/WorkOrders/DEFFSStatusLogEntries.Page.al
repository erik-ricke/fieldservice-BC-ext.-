namespace DEF.FieldService.WorkOrders;

page 50134 "DEF FS Status Log Entries"
{
    Caption = 'Work Order Status History';
    PageType = List;
    SourceTable = "DEF FS Status Log Entry";
    SourceTableView = sorting("Work Order No.", "Changed At") order(descending);
    ApplicationArea = All;
    UsageCategory = History;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Work Order No."; Rec."Work Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the work order whose status was changed.';
                }
                field("Changed At"; Rec."Changed At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the status was changed.';
                }
                field("From Status"; Rec."From Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status before the change.';
                }
                field("To Status"; Rec."To Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status after the change.';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the technician the work order was assigned to when the status was changed.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who changed the status.';
                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the note that was entered when the job was completed, failed or paused.';
                }
            }
        }
    }
}
