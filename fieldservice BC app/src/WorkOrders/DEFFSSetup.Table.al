namespace DEF.FieldService.WorkOrders;

using Microsoft.Foundation.NoSeries;
using Microsoft.Inventory.Item;

table 50122 "DEF FS Setup"
{
    Caption = 'Field Service Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "Work Order Nos."; Code[20])
        {
            Caption = 'Work Order Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(3; "Demo Item Template Code"; Code[20])
        {
            Caption = 'Demo Item Template Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Templ.";
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
        RecordHasBeenRead: Boolean;

    /// <summary>
    /// Reads the setup record once per instance. If it does not exist yet, the record stays initialized with default values.
    /// </summary>
    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;

        if not Rec.Get() then
            Rec.Init();
        RecordHasBeenRead := true;
    end;

    /// <summary>
    /// Makes sure the single setup record exists.
    /// </summary>
    procedure InsertIfNotExists()
    begin
        Rec.Reset();
        if Rec.Get() then
            exit;

        Rec.Init();
        Rec.Insert(true);
    end;
}
