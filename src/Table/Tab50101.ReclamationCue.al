table 65061 "Reclamation Cue"
{
    Caption = 'Reclamation Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Total Reclamations"; Integer)
        {
            CalcFormula = count(Reclamation);
            Caption = 'Total Réclamations';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Reclamations Ouvertes"; Integer)
        {
            CalcFormula = count(Reclamation where(Statut = filter(Ouverte)));
            Caption = 'Réclamations Ouvertes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Reclamations Prise En Charge"; Integer)
        {
            CalcFormula = count(Reclamation where(Statut = filter("PriseEnCharge")));
            Caption = 'Réclamations Prise en charge';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Reclamations En Cours"; Integer)
        {
            CalcFormula = count(Reclamation where(Statut = filter("EnCours")));
            Caption = 'Réclamations En cours';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Reclamations Fermees"; Integer)
        {
            CalcFormula = count(Reclamation where(Statut = filter(Cloturee)));
            Caption = 'Réclamations Fermées';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "A Qualifier"; Integer)
        {
            CalcFormula = count(Reclamation where("Etape Workflow" = filter(Ouverture)));
            Caption = 'À qualifier';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "En Investigation"; Integer)
        {
            CalcFormula = count(Reclamation where("Etape Workflow" = filter(Affectation | Investigation | ActionCorrective)));
            Caption = 'En investigation';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "En Attente Validation"; Integer)
        {
            CalcFormula = count(Reclamation where("Etape Workflow" = filter(Validation)));
            Caption = 'En attente de validation';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}