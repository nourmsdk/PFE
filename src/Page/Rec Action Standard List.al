page 65021 "Rec Action Standard List"
{
    PageType = List;
    SourceTable = "Rec Action Standard";
    Caption = 'Actions Correctives Standard';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code") { ApplicationArea = All; }
                field("Code Categorie"; Rec."Code Categorie") { ApplicationArea = All; }
                field("Code Sous Categorie"; Rec."Code Sous Categorie") { ApplicationArea = All; }
                field("Description"; Rec."Description") { ApplicationArea = All; }
                field("Delai Jours Defaut"; Rec."Delai Jours Defaut") { ApplicationArea = All; }
                field("Responsabilite Defaut"; Rec."Responsabilite Defaut")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}