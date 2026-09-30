namespace DEF.FieldService.WorkOrders;

page 50102 "DEF FS Mobile Order List"
{
    Caption = 'Field Service Work Orders';
    PageType = List;
    SourceTable = "DEF FS Work Order Header";
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Lists;
    CardPageId = "DEF FS Mobile Order Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the work order number used to identify this service visit.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Caption = 'Customer';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name associated with this work order.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority of this work order.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current processing status of this work order.';
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(StartJobPromoted; StartJob)
                {
                }
                actionref(PauseStopPromoted; PauseStop)
                {
                }
                actionref(CompleteJobPromoted; CompleteJob)
                {
                }
            }
        }
        area(Processing)
        {
            action(StartJob)
            {
                Caption = 'Start Job';
                ApplicationArea = All;
                Scope = Repeater;
                Image = Start;
                ToolTip = 'Starts the selected field service job.';

                trigger OnAction()
                begin
                    Message('Action Start Job triggered');
                end;
            }
            action(PauseStop)
            {
                Caption = 'Pause/Stopp';
                ApplicationArea = All;
                Scope = Repeater;
                Image = Pause;
                ToolTip = 'Pauses or stops the selected field service job.';

                trigger OnAction()
                begin
                    Message('Action Pause/Stopp triggered');
                end;
            }
            action(CompleteJob)
            {
                Caption = 'Job Abschließen';
                ApplicationArea = All;
                Scope = Repeater;
                Image = Completed;
                ToolTip = 'Completes the selected field service job.';

                trigger OnAction()
                begin
                    Message('Action Job Abschließen triggered');
                end;
            }
            action(AddSparePart)
            {
                Caption = 'Add Spare Part';
                ApplicationArea = All;
                Scope = Repeater;
                Image = Item;
                ToolTip = 'Opens item selection to add a spare part to this work order.';

                trigger OnAction()
                var
                    WorkOrderItemMgt: Codeunit "DEF FS Work Order Item Mgt";
                begin
                    WorkOrderItemMgt.AddItemToWorkOrder(Rec."No.");
                end;
            }
        }
    }
}