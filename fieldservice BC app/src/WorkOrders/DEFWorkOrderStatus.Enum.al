namespace DEF.FieldService.WorkOrders;

enum 50101 "DEF Work Order Status"
{
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Scheduled)
    {
        Caption = 'Scheduled';
    }
    value(2; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(3; Completed)
    {
        Caption = 'Completed';
    }
    value(4; Canceled)
    {
        Caption = 'Canceled';
    }
}