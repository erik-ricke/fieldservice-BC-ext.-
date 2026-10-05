# Singleton Pattern (Setup Tables)

## Rule
Tables that hold exactly one record (setup, cues) follow the singleton pattern. The procedures live **on the table**, so every caller uses the same code.

## Implementation

```al
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

    // For reading: never writes, so it works for users with read-only permissions.
    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;

        if not Rec.Get() then
            Rec.Init();
        RecordHasBeenRead := true;
    end;

    // For install code and the setup page: creates the record if it is missing.
    procedure InsertIfNotExists()
    begin
        Rec.Reset();
        if Rec.Get() then
            exit;

        Rec.Init();
        Rec.Insert(true);
    end;
}
```

## Guidelines
- **Reading:** Business logic calls `GetRecordOnce()`, then `TestField` on the values it needs. That gives the user a clear error such as "Work Order Nos. must have a value in Field Service Setup".
- **Creating:** Only install/upgrade code, `OnCompanyInitialize` subscribers and the setup page (`OnOpenPage`) call `InsertIfNotExists()`. Ordinary users often have no insert permission on setup tables.
- **Setup page:** `PageType = Card`, `InsertAllowed = false`, `DeleteAllowed = false`, `UsageCategory = Administration`.
- **Cue tables:** same idea, with a `GetOrCreate()` procedure called from the cue page's `OnOpenPage`. The cue table needs `RIM` permission for all users of the role center.

## ❌ Avoid
```al
SalesSetup.FindFirst();   // fails when the record does not exist
SalesSetup.Get();         // same, without a helpful message
```
