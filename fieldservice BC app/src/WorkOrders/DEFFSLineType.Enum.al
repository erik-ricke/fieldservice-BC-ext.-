namespace DEF.FieldService.WorkOrders;

enum 50104 "DEF FS Line Type"
{
    Caption = 'Field Service Line Type';
    Extensible = true;

    value(0; Item)
    {
        Caption = 'Item';
    }
    value(1; Resource)
    {
        Caption = 'Resource';
    }
}