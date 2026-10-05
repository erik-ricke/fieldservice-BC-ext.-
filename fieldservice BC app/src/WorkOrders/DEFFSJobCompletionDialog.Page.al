namespace DEF.FieldService.WorkOrders;

page 50119 "DEF FS Job Completion Dialog"
{
    PageType = StandardDialog;
    Caption = 'Complete Job';

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;

                field(CompletionResult; CompletionResult)
                {
                    ApplicationArea = All;
                    Caption = 'Result';
                    ToolTip = 'Specifies whether the job was completed, failed or is paused.';
                }
                field(Note; Note)
                {
                    ApplicationArea = All;
                    Caption = 'Note';
                    MultiLine = true;
                    ToolTip = 'Specifies a note about the outcome. A note is required when the job failed.';
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction <> Action::OK then
            exit(true);

        if (CompletionResult = CompletionResult::Failed) and (Note.Trim() = '') then begin
            Message(FailureNoteRequiredMsg);
            exit(false);
        end;
        exit(true);
    end;

    var
        CompletionResult: Enum "DEF FS Completion Result";
        Note: Text[250];
        FailureNoteRequiredMsg: Label 'Enter a note that explains why the job failed.';

    procedure GetCompletionResult(): Enum "DEF FS Completion Result"
    begin
        exit(CompletionResult);
    end;

    procedure GetNote(): Text[250]
    begin
        exit(Note);
    end;
}
