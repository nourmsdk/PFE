table 65004 "Rec Workflow History"
{
    Caption = 'Historique Workflow Réclamation';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'N° Entrée';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "No. Reclamation"; Code[20])
        {
            Caption = 'N° Réclamation';
            DataClassification = CustomerContent;
            TableRelation = Reclamation."No_";
        }
        field(3; "Etape Precedente"; Enum "Etape Workflow Reclamation")
        {
            Caption = 'Etape Précédente';
            DataClassification = CustomerContent;
        }
        field(4; "Etape Suivante"; Enum "Etape Workflow Reclamation")
        {
            Caption = 'Etape Suivante';
            DataClassification = CustomerContent;
        }
        field(5; "Statut Precedent"; Enum "Statut Reclamation")
        {
            Caption = 'Statut Précédent';
            DataClassification = CustomerContent;
        }
        field(6; "Statut Suivant"; Enum "Statut Reclamation")
        {
            Caption = 'Statut Suivant';
            DataClassification = CustomerContent;
        }
        field(7; "User ID"; Code[50])          // ← champ manquant ajouté
        {
            Caption = 'Utilisateur';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(8; "Date Heure"; DateTime)
        {
            Caption = 'Date / Heure';
            DataClassification = CustomerContent;
        }
        field(9; Commentaire; Text[250])
        {
            Caption = 'Commentaire';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(K2; "No. Reclamation") { }
        key(K3; "Date Heure") { }
    }
}