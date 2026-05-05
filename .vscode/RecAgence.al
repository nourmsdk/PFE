table 65005 "Rec Agence"
{
    Caption = 'Agence';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Nom; Text[100])
        {
            Caption = 'Nom Agence';
            DataClassification = CustomerContent;
        }
        field(3; Region; Text[50])
        {
            Caption = 'Région';
            DataClassification = CustomerContent;
        }
        field(4; Responsable; Text[100])
        {
            Caption = 'Responsable';
            DataClassification = CustomerContent;
        }
        field(5; "No. Reclamations"; Integer)
        {
            Caption = 'Nb Réclamations';
            FieldClass = FlowField;
            CalcFormula = count(Reclamation where(Agence = field(Code)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}