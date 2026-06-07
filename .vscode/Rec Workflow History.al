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
        field(3; "Etape Precedente"; Option)
        {
            OptionMembers = " ",Ouverture,Qualification,Affectation,Investigation,"Action corrective",Validation,Cloture;
            OptionCaption = ' ,Ouverture,Qualification,Affectation,Investigation,Action corrective,Validation,Clôture';
        }
        field(4; "Etape Suivante"; Option)
        {
            OptionMembers = " ",Ouverture,Qualification,Affectation,Investigation,"Action corrective",Validation,Cloture;
            OptionCaption = ' ,Ouverture,Qualification,Affectation,Investigation,Action corrective,Validation,Clôture';
        }
        field(5; "Statut Precedent"; Option)
        {
            Caption = 'Statut Précédent';
            DataClassification = CustomerContent;
            OptionMembers = " ","Ouverte","Prise en charge","En cours","Cloturee";
            OptionCaption = ' ,Ouverte,Prise en charge,En cours,Clôturée';
        }
        field(6; "Statut Suivant"; Option)
        {
            Caption = 'Statut Suivant';
            DataClassification = CustomerContent;
            OptionMembers = " ","Ouverte","Prise en charge","En cours","Cloturee";
            OptionCaption = ' ,Ouverte,Prise en charge,En cours,Clôturée';
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