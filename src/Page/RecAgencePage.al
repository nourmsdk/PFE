page 65005 "Rec Agence List"
{
    Caption = 'Agences';
    PageType = List;
    SourceTable = "Rec Agence";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Nom; Rec.Nom)
                {
                    ApplicationArea = All;
                }
                field(Region; Rec.Region)
                {
                    ApplicationArea = All;
                }
                field(Responsable; Rec.Responsable)
                {
                    ApplicationArea = All;
                }
                field("No. Reclamations"; Rec."No. Reclamations")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                }
            }
        }
    }
}