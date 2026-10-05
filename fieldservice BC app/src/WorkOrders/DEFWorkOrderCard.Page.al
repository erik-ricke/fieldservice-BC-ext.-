namespace DEF.FieldService.WorkOrders;

page 50103 "DEF FS Mobile Order Card"
{
    Caption = 'Field Service Work Order';
    PageType = Document;
    SourceTable = "DEF FS Work Order Header";
    ApplicationArea = All;
    Editable = false;
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
                Editable = false;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(TravelingPromoted; Traveling)
            {
            }
            actionref(StartPromoted; StartJob)
            {
            }
            actionref(StopPromoted; "Pause/Stop")
            {
            }
            actionref(AddSparePartPromoted; AddSparePart)
            {
            }
            actionref(StartWorkPromoted; CompleteJob)
            {
            }

        }
        area(Processing)
        {
            action(Traveling)
            {
                Caption = 'Anfahrt';
                ApplicationArea = All;
                Image = MoveUp;
                ToolTip = 'Marks this work order as currently traveling to the customer.';

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Traveling;
                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
            action(StartJob)
            {
                Caption = 'Start';
                ApplicationArea = All;
                Image = Navigate;
                ToolTip = 'Starts this work order.';

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::"In Progress";
                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
            action("Pause/Stop")
            {
                Caption = 'Pause/Stop';
                ApplicationArea = All;
                Image = Pause;
                ToolTip = 'Stops or pauses this work order.';

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Paused;
                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
            action(AddSparePart)
            {
                Caption = 'Material verbuchen';
                ApplicationArea = All;
                Image = Item;
                ToolTip = 'Öffnet die Auswahl, um ein neues Material oder Teil der Work Order hinzuzufügen.';

                trigger OnAction()
                var
                    WorkOrderItemMgt: Codeunit "DEF FS Work Order Item Mgt";
                begin
                    WorkOrderItemMgt.AddItemToWorkOrder(Rec."No.");
                end;
            }
            action(CompleteJob)
            {
                Caption = 'Complete Job';
                ApplicationArea = All;
                ToolTip = 'Completes the work for this order.';

                trigger OnAction()
                var
                    JobCompletionDialog: Page "DEF FS Job Completion Dialog";
                    CompletionChoice: Integer;
                    FailureNote: Text[250];
                begin
                    if JobCompletionDialog.RunModal() <> Action::OK then
                        exit;

                    CompletionChoice := JobCompletionDialog.GetCompletionChoice();
                    FailureNote := JobCompletionDialog.GetFailureNote();

                    case CompletionChoice of
                        4:
                            begin
                                Rec.Status := Rec.Status::Done;
                                Rec.Modify();
                                CurrPage.Update();
                                Message('Job wurde als abgeschlossen markiert.');
                            end;
                        5:
                            begin
                                if FailureNote.Trim() = '' then
                                    Error('Bitte eine Notiz für den fehlgeschlagenen Job eingeben.');

                                Rec.Status := Rec.Status::Failed;
                                Rec.Modify();
                                CurrPage.Update();
                                Message('Job wurde als fehlgeschlagen markiert.\Notiz: %1', FailureNote);
                            end;
                        3:
                            begin
                                Rec.Status := Rec.Status::Paused;
                                Rec.Modify();
                                CurrPage.Update();
                                Message('Job wurde pausiert.');
                            end;
                    end;
                end;
            }

        }
    }
}