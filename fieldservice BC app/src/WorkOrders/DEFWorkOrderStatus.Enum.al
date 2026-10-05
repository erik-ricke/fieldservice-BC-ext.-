namespace DEF.FieldService.WorkOrders;

enum 50101 "DEF FS Order Status"
{
    Caption = 'Field Service Order Status';
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Traveling)
    {
        Caption = 'Traveling';
    }
    value(2; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(3; Paused)
    {
        Caption = 'Paused';
    }
    value(4; Done)
    {
        Caption = 'Done';
    }
    value(5; Failed)
    {
        Caption = 'Failed';
    }
}