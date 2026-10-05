namespace DEF.FieldService.WorkOrders;

/// <summary>
/// Editable work order card for office staff. Technicians use "DEF FS Mobile Order Card".
/// </summary>
page 50128 "DEF FS Work Order Card"
{
    Caption = 'Field Service Work Order';
    PageType = Document;
    SourceTable = "DEF FS Work Order Header";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the work order number. Leave it empty to use the number series from the Field Service Setup.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a short summary of the requested field service work.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer that the work is done for. Selecting a customer fills in the name and address.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the customer.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service address.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority of the work order. Higher numbers are more urgent.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current processing status. Technicians change it from their role center.';
                }
                field("Completion Note"; Rec."Completion Note")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the note that was entered when the job was completed, failed or paused.';
                }
                field("Demo Data"; Rec."Demo Data")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the work order was created by the demo data tool and is removed by Delete Demo Data.';
                    Visible = false;
                }
            }
            group(Planning)
            {
                Caption = 'Planning';

                field("Assigned Resource No."; Rec."Assigned Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the technician who does the job. The technician sees the work order in the mobile role center.';
                }
                field("Assigned Resource Name"; Rec."Assigned Resource Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the technician who does the job.';
                }
                field("Planned Date"; Rec."Planned Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the day the job is planned for.';
                }
                field("Planned Start Time"; Rec."Planned Start Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the time the job is planned to start.';
                }
                field("Estimated Duration"; Rec."Estimated Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how long the job is expected to take on site.';
                }
            }
            group(TimeSpent)
            {
                Caption = 'Time Spent';

                field(TravelTime; TravelTime)
                {
                    ApplicationArea = All;
                    Caption = 'Travel Time';
                    Editable = false;
                    ToolTip = 'Specifies how long the technician traveled to the customer, based on the status history.';
                }
                field(WorkTime; WorkTime)
                {
                    ApplicationArea = All;
                    Caption = 'Work Time';
                    Editable = false;
                    ToolTip = 'Specifies how long the technician worked on the job, based on the status history. Paused time is not included.';
                }
            }
            part(Lines; "DEF FS Line Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Reopen)
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Image = ReOpen;
                Enabled = CanReopen;
                ToolTip = 'Sets a failed work order back to Open so that it can be scheduled again.';

                trigger OnAction()
                var
                    StatusMgt: Codeunit "DEF FS Status Mgt";
                begin
                    StatusMgt.SetStatus(Rec, Rec.Status::Open);
                    CurrPage.Update(false);
                end;
            }
        }
        area(Navigation)
        {
            action(StatusHistory)
            {
                ApplicationArea = All;
                Caption = 'Status History';
                Image = History;
                RunObject = page "DEF FS Status Log Entries";
                RunPageLink = "Work Order No." = field("No.");
                ToolTip = 'Opens the status changes of this work order.';
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ReopenPromoted; Reopen)
                {
                }
                actionref(StatusHistoryPromoted; StatusHistory)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        StatusMgt: Codeunit "DEF FS Status Mgt";
        WorkTimeMgt: Codeunit "DEF FS Work Time Mgt";
    begin
        CanReopen := StatusMgt.IsTransitionAllowed(Rec.Status, Rec.Status::Open);
        WorkTimeMgt.CalcTimes(Rec."No.", CurrentDateTime(), TravelTime, WorkTime);
    end;

    var
        CanReopen: Boolean;
        TravelTime: Duration;
        WorkTime: Duration;
}
