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
                field("SLA Jours"; Rec."SLA Jours")
                {
                    ApplicationArea = All;
                }
                field("Email Notification"; Rec."Email Notification")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}