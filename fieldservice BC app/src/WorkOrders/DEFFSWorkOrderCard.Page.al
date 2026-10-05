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
                    ToolTip = 'Specifies the priority of the work order. Higher numbers are shown first to technicians.';
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
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ReopenPromoted; Reopen)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        StatusMgt: Codeunit "DEF FS Status Mgt";
    begin
        CanReopen := StatusMgt.IsTransitionAllowed(Rec.Status, Rec.Status::Open);
    end;

    var
        CanReopen: Boolean;
}
