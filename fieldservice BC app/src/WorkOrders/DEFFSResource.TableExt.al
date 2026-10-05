namespace DEF.FieldService.WorkOrders;

using Microsoft.Projects.Resources.Resource;
using System.Security.AccessControl;

/// <summary>
/// Links a resource to the Business Central user who works as this field service technician.
/// </summary>
tableextension 50130 "DEF FS Resource" extends Resource
{
    fields
    {
        field(50130; "DEF FS User ID"; Code[50])
        {
            Caption = 'Field Service User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                TechnicianMgt: Codeunit "DEF FS Technician Mgt";
            begin
                TechnicianMgt.CheckUserNotLinkedToOtherResource(Rec."No.", Rec."DEF FS User ID");
            end;
        }
    }

    keys
    {
        key("DEF FS User ID"; "DEF FS User ID")
        {
        }
    }
}
