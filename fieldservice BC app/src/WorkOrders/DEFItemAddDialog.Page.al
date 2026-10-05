namespace DEF.FieldService.WorkOrders;

using Microsoft.Inventory.Item;

page 50120 "DEF FS Item Add Dialog"
{
    PageType = StandardDialog;
    Caption = 'Material hinzufügen';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(ItemNo; ItemNo)
                {
                    ApplicationArea = All;
                    Caption = 'Artikel';
                    TableRelation = Item."No.";

                    trigger OnValidate()
                    var
                        Item: Record Item;
                    begin
                        if Item.Get(ItemNo) then
                            ItemDescription := Item.Description
                        else
                            ItemDescription := '';
                    end;
                }
                field(ItemDescription; ItemDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Beschreibung';
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Anzahl';
                    MinValue = 1;
                }
                field(NeedsPurchasing; NeedsPurchasing)
                {
                    ApplicationArea = All;
                    Caption = 'Materialbedarf';
                }
                field(ItemNote; ItemNote)
                {
                    ApplicationArea = All;
                    Caption = 'Notiz';
                    MultiLine = true;
                }
            }
        }
    }

    var
        ItemNo: Code[20];
        ItemDescription: Text[100];
        Quantity: Decimal;
        NeedsPurchasing: Boolean;
        ItemNote: Text[250];

    procedure GetItemNo(): Code[20]
    begin
        exit(ItemNo);
    end;

    procedure GetQuantity(): Decimal
    begin
        exit(Quantity);
    end;

    procedure GetNeedsPurchasing(): Boolean
    begin
        exit(NeedsPurchasing);
    end;

    procedure GetItemNote(): Text[250]
    begin
        exit(ItemNote);
    end;
}
