namespace DEF.FieldService.WorkOrders;

page 50103 "DEF FS Mobile Order Card"
{
    Caption = 'Field Service Work Order';
    PageType = Document;
    SourceTable = "DEF FS Work Order Header";
    ApplicationArea = All;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Documents;

    layout
    {
        area(Content)
        {
            group(WorkOrder)
            {
                Caption = 'Work Order';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the work order number used to identify this service visit.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a short summary of the requested field service work.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Caption = 'Customer';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer associated with this work order.';
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
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the service address for this work order.';
                }
            }
            part(Lines; "DEF FS Line Subform")
            {
                ApplicationArea = All;
                Editable = true;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(StartPromoted; Start)
            {
            }
            actionref(StopPromoted; Stop)
            {
            }
            actionref(StartWorkPromoted; StartWork)
            {
            }
            actionref(FinishOrderPromoted; FinishOrder)
            {
            }
        }
        area(Processing)
        {
            action(Start)
            {
                Caption = 'Start';
                ApplicationArea = All;
                Image = Navigate;
                ToolTip = 'Starts this work order.';

                trigger OnAction()
                begin
                    Message('Action Start triggered');
                end;
            }
            action(Stop)
            {
                Caption = 'Stop';
                ApplicationArea = All;
                Image = Pause;
                ToolTip = 'Stops or pauses this work order.';

                trigger OnAction()
                begin
                    Message('Action Stop triggered');
                end;
            }
            action(StartWork)
            {
                Caption = 'Start Work';
                ApplicationArea = All;
                ToolTip = 'Starts the work for this order.';

                trigger OnAction()
                begin
                    Message('Action Start Work triggered');
                end;
            }
            action(FinishOrder)
            {
                Caption = 'Finish Order';
                ApplicationArea = All;
                Image = Approve;
                ToolTip = 'Finishes this work order.';

                trigger OnAction()
                begin
                    Message('Action Finish Order triggered');
                end;
            }
        }
    }
}