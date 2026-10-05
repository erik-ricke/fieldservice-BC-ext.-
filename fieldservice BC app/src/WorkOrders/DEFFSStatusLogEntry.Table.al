namespace DEF.FieldService.WorkOrders;

using Microsoft.Projects.Resources.Resource;

/// <summary>
/// One row per status change of a work order. Used to show the history and to calculate travel and work time.
/// </summary>
table 50133 "DEF FS Status Log Entry"
{
    Caption = 'Field Service Status Log Entry';
    DataClassification = CustomerContent;
    DrillDownPageId = "DEF FS Status Log Entries";
    LookupPageId = "DEF FS Status Log Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Work Order No."; Code[20])
        {
            Caption = 'Work Order No.';
            DataClassification = CustomerContent;
            TableRelation = "DEF FS Work Order Header"."No.";
        }
        field(3; "From Status"; Enum "DEF FS Order Status")
        {
            Caption = 'From Status';
            DataClassification = CustomerContent;
        }
        field(4; "To Status"; Enum "DEF FS Order Status")
        {
            Caption = 'To Status';
            DataClassification = CustomerContent;
        }
        field(5; "Changed At"; DateTime)
        {
            Caption = 'Changed At';
            DataClassification = CustomerContent;
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(7; "Resource No."; Code[20])
        {
            Caption = 'Technician';
            DataClassification = CustomerContent;
            TableRelation = Resource;
        }
        field(8; Note; Text[250])
        {
            Caption = 'Note';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(WorkOrder; "Work Order No.", "Changed At")
        {
        }
    }
}
