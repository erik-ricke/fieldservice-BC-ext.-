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
            DataClassification = CustomerContent;
        }
        field(2; "Open Orders"; Integer)
        {
            Caption = 'Open Orders';
            FieldClass = FlowField;
            CalcFormula = count("DEF FS Work Order Header" where(Status = const(Open)));
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}