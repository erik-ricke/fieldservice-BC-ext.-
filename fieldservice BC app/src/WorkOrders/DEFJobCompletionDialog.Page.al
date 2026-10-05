namespace DEF.FieldService.WorkOrders;

page 50119 "DEF FS Job Completion Dialog"
{
    PageType = StandardDialog;
    Caption = 'Job abschließen';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(CompletionChoice; CompletionChoice)
                {
                    ApplicationArea = All;
                    Caption = 'Ergebnis';

                    trigger OnValidate()
                    begin
                        if (CompletionChoice = CompletionChoice::"Job fehlgeschlagen") and (FailureNote.Trim() = '') then
                            Error('Bitte eine Notiz für den fehlgeschlagenen Job eingeben.');
                    end;
                }
                field(FailureNote; FailureNote)
                {
                    ApplicationArea = All;
                    Caption = 'Notiz';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        if (CompletionChoice = CompletionChoice::"Job fehlgeschlagen") and (FailureNote.Trim() = '') then
                            Error('Bitte eine Notiz für den fehlgeschlagenen Job eingeben.');
                    end;
                }
            }
        }
    }

    var
        CompletionChoice: Option "Job abgeschlossen","Job fehlgeschlagen","Pausiert";
        FailureNote: Text[250];

    procedure GetCompletionChoice(): Integer
    begin
        case CompletionChoice of
            CompletionChoice::"Job abgeschlossen":
                exit(4);
            CompletionChoice::"Job fehlgeschlagen":
                exit(5);
            CompletionChoice::Pausiert:
                exit(3);
        end;
    end;

    procedure GetFailureNote(): Text[250]
    begin
        exit(FailureNote);
    end;
}