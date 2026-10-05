namespace DEF.FieldService.WorkOrders;

table 50107 "DEF FS Mobile Cue"
{
    Caption = 'Field Service Activities';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "Open Orders"; Integer)
        {
            Caption = 'Active Orders';
            FieldClass = FlowField;
            CalcFormula = count("DEF FS Work Order Header" where(Status = filter(Open | Traveling | "In Progress" | Paused)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        DefaultKeyTok: Label 'DEFAULT', Locked = true;

    /// <summary>
    /// Loads the single cue record and creates it first if it does not exist yet.
    /// </summary>
    procedure GetOrCreate()
    begin
        Rec.Reset();
        if Rec.Get(DefaultKeyTok) then
            exit;

        Rec.Init();
        Rec."Primary Key" := DefaultKeyTok;
        Rec.Insert();
    end;
}
