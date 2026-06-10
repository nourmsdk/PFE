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
                    Caption = 'Description';  // ligne 20 déjà existante
                }
                field("Actif"; Rec.Actif)
                {
                    ApplicationArea = All;
                    Caption = 'Actif';
                }
                field("SLA Jours"; Rec."SLA Jours")
                {
                    ApplicationArea = All;
                    Caption = 'SLA Jours';
                }
                field("Gravite Defaut"; Rec."Gravite Defaut")
                {
                    ApplicationArea = All;
                    Caption = 'Gravité par défaut';
                }

            }
        }
    }
}