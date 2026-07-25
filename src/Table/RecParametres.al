table 65007 "Rec Parametres"
{
    Caption = 'Paramètres Réclamations';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; "SLA Jours"; Integer)
        {
            Caption = 'SLA (jours)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "SLA Jours" <= 0 then
                    Error('Le SLA doit être supérieur à 0 jours.');
            end;
        }
        field(3; "Email Notification"; Text[100])
        {
            Caption = 'Email Notification';
            DataClassification = CustomerContent;
        }
        field(4; "No. Series Reclamation"; Code[20])
        {
            Caption = 'Souche N° Réclamation';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(5; "SLA Alerte Pct"; Integer)
        {
            Caption = 'Alerte SLA à (%)';
            DataClassification = CustomerContent;
            InitValue = 75;

            trigger OnValidate()
            begin
                if ("SLA Alerte Pct" <= 0) or ("SLA Alerte Pct" >= 100) then
                    Error('Le pourcentage d''alerte doit être entre 1 et 99.');
            end;
        }
        field(6; "Email Responsable"; Text[100])
        {
            Caption = 'Email Responsable';
            DataClassification = CustomerContent;
        }
        field(7; "Delai Relance Client Heures"; Integer)
        {
            Caption = 'Délai relance client (h)';
            DataClassification = CustomerContent;
            InitValue = 24;

            trigger OnValidate()
            begin
                if "Delai Relance Client Heures" <= 0 then
                    Error('Le délai de relance doit être supérieur à 0.');
            end;
        }
    }

    keys
    {
        key(PK; "Code") { Clustered = true; }
    }
}

page 65007 "Rec Parametres Page"
{
    Caption = 'Paramètres Réclamations';
    PageType = Card;
    SourceTable = "Rec Parametres";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Général';

                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field("No. Series Reclamation"; Rec."No. Series Reclamation")
                {
                    ApplicationArea = All;
                    Caption = 'Souche N° Réclamation';
                    Importance = Promoted;
                }
                field("SLA Jours"; Rec."SLA Jours")
                {
                    ApplicationArea = All;
                }
                field("SLA Alerte Pct"; Rec."SLA Alerte Pct")
                {
                    ApplicationArea = All;
                    Caption = 'Alerte SLA (%)';
                }
                field("Email Notification"; Rec."Email Notification")
                {
                    ApplicationArea = All;
                }
                field("Email Responsable"; Rec."Email Responsable")
                {
                    ApplicationArea = All;
                    Caption = 'Email Responsable';
                }
                field("Delai Relance Client Heures"; Rec."Delai Relance Client Heures")
                {
                    ApplicationArea = All;
                    Caption = 'Délai relance client (h)';
                }
            }
        }
    }
}
