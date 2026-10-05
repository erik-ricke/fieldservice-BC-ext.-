namespace DEF.FieldService.WorkOrders;

enum 50125 "DEF FS Completion Result"
{
    Caption = 'Field Service Completion Result';
    Extensible = false;

    value(0; Completed)
    {
        Caption = 'Job completed';
    }
    value(1; Failed)
    {
        Caption = 'Job failed';
    }
    value(2; Paused)
    {
        Caption = 'Paused';
    }
}
