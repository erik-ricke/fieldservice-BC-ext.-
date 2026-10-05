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
        area(Processing)
        {
            action(Traveling)
            {
                Caption = 'Anfahrt';
                ApplicationArea = All;
                Scope = Repeater;
                Image = MoveUp;
                ToolTip = 'Marks the job as currently traveling to the customer.';

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Traveling;
                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
            action(StartJob)
            {
                Caption = 'Start Job';
                ApplicationArea = All;
                Scope = Repeater;
                Image = Start;
                ToolTip = 'Starts the selected field service job.';

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::"In Progress";
                    Rec.Modify();
                    CurrPage.Update();
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
                    Rec.Status := Rec.Status::Paused;
                    Rec.Modify();
                    CurrPage.Update();
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
            action(AddSparePart)
            {
                Caption = 'Material verbuchen';
                ApplicationArea = All;
                Scope = Repeater;
                Image = Item;
                ToolTip = 'Öffnet die Auswahl, um ein neues Material oder Teil der Work Order hinzuzufügen.';

                trigger OnAction()
                var
                    WorkOrderItemMgt: Codeunit "DEF FS Work Order Item Mgt";
                begin
                    WorkOrderItemMgt.AddItemToWorkOrder(Rec."No.");
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey(Priority, Status);
        Rec.Ascending(false);
    end;
}