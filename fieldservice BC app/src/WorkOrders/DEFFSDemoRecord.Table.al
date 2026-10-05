namespace DEF.FieldService.WorkOrders;

/// <summary>
/// Remembers which standard records (items, resources) were created by the demo data tool,
/// so that only those records are removed again.
/// </summary>
table 50124 "DEF FS Demo Record"
{
    Caption = 'Field Service Demo Record';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(2; "Record No."; Code[20])
        {
            Caption = 'Record No.';
        }
    }

    keys
    {
        key(PK; "Table No.", "Record No.")
        {
            Clustered = true;
        }
    }
}
