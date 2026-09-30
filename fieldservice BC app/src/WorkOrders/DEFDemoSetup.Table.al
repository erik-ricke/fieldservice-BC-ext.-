namespace DEF.FieldService.WorkOrders;

table 50112 "DEF FS Demo Setup"
{
    Caption = 'Field Service Demo Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Work Order No."; Code[20])
        {
            Caption = 'Work Order No.';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
        }
        field(4; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(5; Priority; Integer)
        {
            Caption = 'Priority';
            DataClassification = CustomerContent;
        }
        field(6; Status; Enum "DEF FS Order Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(7; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(8; "Line Type"; Enum "DEF FS Line Type")
        {
            Caption = 'Line Type';
            DataClassification = CustomerContent;
        }
        field(9; "Item or Resource No."; Code[20])
        {
            Caption = 'Item or Resource No.';
            DataClassification = CustomerContent;
        }
        field(10; "Line Description"; Text[100])
        {
            Caption = 'Line Description';
            DataClassification = CustomerContent;
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(12; "Needs Purchasing"; Boolean)
        {
            Caption = 'Needs Purchasing';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Work Order No.")
        {
            Clustered = true;
        }
    }
}