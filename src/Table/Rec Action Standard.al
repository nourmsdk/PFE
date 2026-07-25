table 65020 "Rec Action Standard"
{
    Caption = 'Action Corrective Standard';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(10; "Code Categorie"; Code[20])
        {
            Caption = 'Code Catégorie';
            TableRelation = "Rec Categorie".Code;
        }
        field(20; "Code Sous Categorie"; Code[20])
        {
            Caption = 'Code Sous-Catégorie';
            TableRelation = "Rec Sous Categorie".Code where("Code Categorie" = field("Code Categorie"));
        }
        field(30; "Description"; Text[250])
        {
            Caption = 'Description Action';
        }
        field(40; "Delai Jours Defaut"; Integer)
        {
            Caption = 'Délai par défaut (jours)';
        }
        field(50; "Responsabilite Defaut"; Enum "Responsabilite Reclamation")
        {
            Caption = 'Responsabilité par défaut';
        }
    }

    keys
    {
        key(PK; "Code") { Clustered = true; }
        key(K1; "Code Categorie", "Code Sous Categorie") { }
    }
}