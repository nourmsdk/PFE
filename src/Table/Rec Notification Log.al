table 65003 "Rec Notification Log"
{
    Caption = 'Log Notifications Réclamation';
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
        field(3; "Type Notification"; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionMembers = " ","Hors SLA","Alerte75pct","Escalade Manager","Confirmation Client","Cloture","Satisfaction","Relance Client";
            OptionCaption = ' ,Hors SLA,Alerte 75%,Escalade Manager,Confirmation Client,Clôture,Satisfaction,Relance Client';
        }
        field(4; Message; Text[500])
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
        field(5; "Date Heure"; DateTime)
        {
            Caption = 'Date / Heure';
            DataClassification = CustomerContent;
        }
        field(6; Processed; Boolean)
        {
            Caption = 'Traité';
            DataClassification = CustomerContent;
        }
        field(7; Destinataire; Text[100])
        {
            Caption = 'Destinataire';
            DataClassification = CustomerContent;
        }
        field(8; "No. Client"; Code[20])
        {
            Caption = 'N° Client';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
        field(9; "Email Envoye"; Boolean)
        {
            Caption = 'Email Envoyé';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(K2; "No. Reclamation") { }
        key(K3; Processed) { }
        key(K4; "Type Notification") { }
    }
}