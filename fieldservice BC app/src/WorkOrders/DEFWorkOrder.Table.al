namespace DEF.FieldService.WorkOrders;

using Microsoft.Sales.Customer;

table 50100 "DEF FS Work Order Header"
{
    Caption = 'Field Service Work Order';
    DataClassification = CustomerContent;
    DataCaptionFields = "No.", "Customer Name";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer';
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
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}