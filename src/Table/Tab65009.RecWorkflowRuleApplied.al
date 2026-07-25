table 65009 "Rec Workflow Rule Applied"
{
    Caption = 'Règles Workflow Appliquées';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No. Reclamation"; Code[20])
        {
            Caption = 'N° Réclamation';
            DataClassification = CustomerContent;
            TableRelation = Reclamation."No_";
            NotBlank = true;
        }
        field(2; "Rule Code"; Code[20])
        {
            Caption = 'Code Règle';
            DataClassification = CustomerContent;
            TableRelation = "Rec Workflow Rule"."Code";
            NotBlank = true;
        }
        field(3; "Date Heure"; DateTime)
        {
            Caption = 'Date / Heure Exécution';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No. Reclamation", "Rule Code") { Clustered = true; }
        key(K2; "Rule Code") { }
    }
}
