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
            CalcFormula = count("DEF FS Work Order Header" where(Status = filter(Open | Traveling | "In Progress" | Paused),
                                                                  "Assigned Resource No." = field("Resource Filter")));
            Editable = false;
        }
        field(3; "Due Today"; Integer)
        {
            Caption = 'Due Today';
            FieldClass = FlowField;
            CalcFormula = count("DEF FS Work Order Header" where(Status = filter(Open | Traveling | "In Progress" | Paused),
                                                                  "Assigned Resource No." = field("Resource Filter"),
                                                                  "Planned Date" = field("Today Filter")));
            Editable = false;
        }
        field(4; Overdue; Integer)
        {
            Caption = 'Overdue';
            FieldClass = FlowField;
            CalcFormula = count("DEF FS Work Order Header" where(Status = filter(Open | Traveling | "In Progress" | Paused),
                                                                  "Assigned Resource No." = field("Resource Filter"),
                                                                  "Planned Date" = field("Overdue Date Filter")));
            Editable = false;
        }
        field(10; "Resource Filter"; Code[20])
        {
            Caption = 'Resource Filter';
            FieldClass = FlowFilter;
        }
        field(11; "Today Filter"; Date)
        {
            Caption = 'Today Filter';
            FieldClass = FlowFilter;
        }
        field(12; "Overdue Date Filter"; Date)
        {
            Caption = 'Overdue Date Filter';
            FieldClass = FlowFilter;
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

    /// <summary>
    /// Limits the cues to one technician (all technicians if ResourceNo is empty) and sets the date filters relative to ReferenceDate.
    /// Work orders without a planned date are never overdue.
    /// </summary>
    procedure SetCueFilters(ResourceNo: Code[20]; ReferenceDate: Date)
    begin
        if ResourceNo <> '' then
            Rec.SetRange("Resource Filter", ResourceNo)
        else
            Rec.SetRange("Resource Filter");
        Rec.SetRange("Today Filter", ReferenceDate);
        Rec.SetFilter("Overdue Date Filter", '<>%1&<%2', 0D, ReferenceDate);
    end;
}
