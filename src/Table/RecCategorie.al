table 65001 "Rec Categorie"
{
    Caption = 'Catégorie Réclamation';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Actif"; Boolean)
        {
            Caption = 'Actif';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(4; "SLA Jours"; Integer)
        {
            Caption = 'SLA Jours (spécifique)';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(5; "Gravite Defaut"; Enum "Gravite Reclamation")
        {
            Caption = 'Gravité par défaut';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}