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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name associated with this work order.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority of this work order. Higher numbers are shown first.';
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
        area(Processing)
        {
            action(Traveling)
            {
                ApplicationArea = All;
                Caption = 'Travel';
                Scope = Repeater;
                Image = MoveUp;
                Enabled = CanTravel;
                ToolTip = 'Marks the job as currently traveling to the customer.';

                trigger OnAction()
                begin
                    StatusMgt.SetStatus(Rec, Rec.Status::Traveling);
                    CurrPage.Update(false);
                end;
            }
            action(StartJob)
            {
                ApplicationArea = All;
                Caption = 'Start Job';
                Scope = Repeater;
                Image = Start;
                Enabled = CanStart;
                ToolTip = 'Starts the selected field service job.';

                trigger OnAction()
                begin
                    StatusMgt.SetStatus(Rec, Rec.Status::"In Progress");
                    CurrPage.Update(false);
                end;
            }
            action(PauseStop)
            {
                ApplicationArea = All;
                Caption = 'Pause';
                Scope = Repeater;
                Image = Pause;
                Enabled = CanPause;
                ToolTip = 'Pauses the selected field service job.';

                trigger OnAction()
                begin
                    StatusMgt.SetStatus(Rec, Rec.Status::Paused);
                    CurrPage.Update(false);
                end;
            }
            action(CompleteJob)
            {
                ApplicationArea = All;
                Caption = 'Complete Job';
                Scope = Repeater;
                Image = Completed;
                Enabled = CanComplete;
                ToolTip = 'Completes the selected field service job, marks it as failed, or pauses it.';

                trigger OnAction()
                begin
                    StatusMgt.CompleteWithDialog(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(AddSparePart)
            {
                ApplicationArea = All;
                Caption = 'Add Material';
                Scope = Repeater;
                Image = Item;
                Enabled = CanAddMaterial;
                ToolTip = 'Adds an item that was used for the selected work order.';

                trigger OnAction()
                var
                    WorkOrderItemMgt: Codeunit "DEF FS Work Order Item Mgt";
                begin
                    WorkOrderItemMgt.AddItemToWorkOrder(Rec."No.");
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(TravelingPromoted; Traveling)
                {
                }
                actionref(StartJobPromoted; StartJob)
                {
                }
                actionref(PauseStopPromoted; PauseStop)
                {
                }
                actionref(AddSparePartPromoted; AddSparePart)
                {
                }
                actionref(CompleteJobPromoted; CompleteJob)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey(Priority, Status);
        Rec.Ascending(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateActionStates();
    end;

    var
        StatusMgt: Codeunit "DEF FS Status Mgt";
        CanTravel: Boolean;
        CanStart: Boolean;
        CanPause: Boolean;
        CanComplete: Boolean;
        CanAddMaterial: Boolean;

    local procedure UpdateActionStates()
    begin
        CanTravel := StatusMgt.IsTransitionAllowed(Rec.Status, Rec.Status::Traveling);
        CanStart := StatusMgt.IsTransitionAllowed(Rec.Status, Rec.Status::"In Progress");
        CanPause := StatusMgt.IsTransitionAllowed(Rec.Status, Rec.Status::Paused);
        CanComplete := StatusMgt.IsTransitionAllowed(Rec.Status, Rec.Status::Done);
        CanAddMaterial := not (Rec.Status in [Rec.Status::Done, Rec.Status::Failed]);
    end;
}
