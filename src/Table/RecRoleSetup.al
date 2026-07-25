table 65017 "Rec Role Setup"
{
    Caption = 'Paramétrage Rôles Réclamation';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'N° Entrée';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "User ID"; Code[50])
        {
            Caption = 'Utilisateur';
            DataClassification = CustomerContent;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            NotBlank = true;
        }
        field(3; Role; Enum "Rec Role")
        {
            Caption = 'Rôle';
            DataClassification = CustomerContent;
        }
        field(4; Actif; Boolean)
        {
            Caption = 'Actif';
            DataClassification = CustomerContent;
            InitValue = true;
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(K2; "User ID") { Unique = true; }
        key(K3; Role) { }
    }
}

page 65017 "Rec Role Setup List"
{
    Caption = 'Paramétrage Rôles Réclamation';
    PageType = List;
    SourceTable = "Rec Role Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(Role; Rec.Role)
                {
                    ApplicationArea = All;
                }
                field(Actif; Rec.Actif)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
