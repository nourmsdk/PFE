page 65004 "Rec Sous Categorie List"
{
    Caption = 'Sous-Catégories Réclamation';
    PageType = List;
    SourceTable = "Rec Sous Categorie";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Code Categorie"; Rec."Code Categorie")
                {
                    ApplicationArea = All;
                    Caption = 'Code Catégorie';
                }
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