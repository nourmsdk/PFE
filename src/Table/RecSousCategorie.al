table 65002 "Rec Sous Categorie"
{
    Caption = 'Sous-Catégorie Réclamation';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code Categorie"; Code[20])
        {
            Caption = 'Code Catégorie';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = "Rec Categorie".Code;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; "Actif"; Boolean)
        {
            Caption = 'Actif';
            DataClassification = CustomerContent;
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Code Categorie", "Code")
        {
            Clustered = true;
        }
    }
}