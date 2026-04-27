page 65003 "Rec Categorie List"
{
    Caption = 'Catégories Réclamation';
    PageType = List;
    SourceTable = "Rec Categorie";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field(Actif; Rec.Actif)
                {
                    ApplicationArea = All;
                    Caption = 'Actif';
                }
            }
        }
    }
}