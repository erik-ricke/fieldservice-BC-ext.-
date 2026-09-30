namespace DEF.FieldService.WorkOrders;

using Microsoft.Sales.Customer;

table 50100 "DEF Work Order"
{
    Caption = 'Field Service Work Order';
    DataClassification = CustomerContent;
    DataCaptionFields = "No.", Description;

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
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if Customer.Get("Customer No.") then
                    "Customer Name" := Customer.Name
                else
                    "Customer Name" := '';
            end;
        }
        field(4; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
        }
        field(5; "Work Date"; Date)
        {
            Caption = 'Work Date';
            DataClassification = CustomerContent;
        }
        field(6; Status; Enum "DEF Work Order Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(7; "Service Address"; Text[100])
        {
            Caption = 'Service Address';
            DataClassification = CustomerContent;
        }
        field(8; "Service City"; Text[30])
        {
            Caption = 'Service City';
            DataClassification = CustomerContent;
        }
        field(9; "Service Post Code"; Code[20])
        {
            Caption = 'Service Post Code';
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