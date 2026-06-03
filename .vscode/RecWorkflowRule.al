table 65008 "Rec Workflow Rule"
{
    Caption = 'Regles Workflow Reclamation';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code Regle';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; Actif; Boolean)
        {
            Caption = 'Actif';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(4; "Ordre Evaluation"; Integer)
        {
            Caption = 'Ordre evaluation';
            DataClassification = CustomerContent;
            InitValue = 10;
        }
        field(10; "Condition Statut"; Option)
        {
            Caption = 'Si Statut';
            DataClassification = CustomerContent;
            OptionMembers = " ",Ouverte,"Prise en charge","En cours",Cloturee;
            OptionCaption = ' ,Ouverte,Prise en charge,En cours,Cloturee';
        }
        field(11; "Condition Etape"; Option)
        {
            Caption = 'Si Etape';
            DataClassification = CustomerContent;
            OptionMembers = " ",Ouverture,Qualification,Affectation,Investigation,"Action corrective",Validation,Cloture;
            OptionCaption = ' ,Ouverture,Qualification,Affectation,Investigation,Action corrective,Validation,Cloture';
        }
        field(12; "Condition Gravite"; Option)
        {
            Caption = 'Si Gravite';
            DataClassification = CustomerContent;
            OptionMembers = " ",Faible,Moyenne,Haute,Critique;
            OptionCaption = ' ,Faible,Moyenne,Haute,Critique';
        }
        field(13; "Condition Delai Pct Min"; Integer)
        {
            Caption = 'Si delai SLA atteint pct min';
            DataClassification = CustomerContent;
        }
        field(14; "Condition Priorite"; Option)
        {
            Caption = 'Si Priorite';
            DataClassification = CustomerContent;
            OptionMembers = " ",Faible,Moyenne,Haute;
            OptionCaption = ' ,Faible,Moyenne,Haute';
        }
        field(15; "Condition Agence"; Code[20])
        {
            Caption = 'Si Agence';
            DataClassification = CustomerContent;
            TableRelation = "Rec Agence".Code;
        }
        field(16; "Condition Categorie"; Code[20])
        {
            Caption = 'Si Categorie';
            DataClassification = CustomerContent;
            TableRelation = "Rec Categorie".Code;
        }
        field(20; "Action Etape"; Option)
        {
            Caption = 'Alors Etape';
            DataClassification = CustomerContent;
            OptionMembers = " ",Ouverture,Qualification,Affectation,Investigation,"Action corrective",Validation,Cloture;
            OptionCaption = ' ,Ouverture,Qualification,Affectation,Investigation,Action corrective,Validation,Cloture';
        }
        field(21; "Action Statut"; Option)
        {
            Caption = 'Alors Statut';
            DataClassification = CustomerContent;
            OptionMembers = " ",Ouverte,"Prise en charge","En cours",Cloturee;
            OptionCaption = ' ,Ouverte,Prise en charge,En cours,Cloturee';
        }
        field(22; "Action Priorite"; Option)
        {
            Caption = 'Alors Priorite';
            DataClassification = CustomerContent;
            OptionMembers = " ",Faible,Moyenne,Haute;
            OptionCaption = ' ,Faible,Moyenne,Haute';
        }
        field(23; "Action Notification"; Option)
        {
            Caption = 'Alors Notification';
            DataClassification = CustomerContent;
            OptionMembers = " ","Hors SLA",Alerte75pct,"Escalade Manager","Confirmation Client",Cloture,Satisfaction,"Relance Client";
            OptionCaption = ' ,Hors SLA,Alerte 75pct,Escalade Manager,Confirmation Client,Cloture,Satisfaction,Relance Client';
        }
        field(24; "Action Attribuer A"; Code[50])
        {
            Caption = 'Alors Attribue a';
            DataClassification = CustomerContent;
            TableRelation = User."User Name";
        }
        field(25; "Action Message"; Text[250])
        {
            Caption = 'Message notification';
            DataClassification = CustomerContent;
        }
        field(26; "Action Forcer Hors Delai"; Boolean)
        {
            Caption = 'Alors Forcer Hors Delai';
            DataClassification = CustomerContent;
        }
        field(30; "Une Seule Fois"; Boolean)
        {
            Caption = 'Executer une seule fois par reclamation';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(31; "Nb Executions"; Integer)
        {
            Caption = 'Nb executions';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Code") { Clustered = true; }
        key(K2; Actif, "Ordre Evaluation") { }
    }
}

page 65008 "Rec Workflow Rule List"
{
    Caption = 'Regles Workflow Reclamation';
    PageType = List;
    SourceTable = "Rec Workflow Rule";
    UsageCategory = Administration;
    ApplicationArea = All;
    CardPageId = "Rec Workflow Rule Card";

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Actif; Rec.Actif)
                {
                    ApplicationArea = All;
                    StyleExpr = ActifStyle;
                }
                field("Ordre Evaluation"; Rec."Ordre Evaluation")
                {
                    ApplicationArea = All;
                    Caption = 'Ordre';
                }
                field("Condition Statut"; Rec."Condition Statut")
                {
                    ApplicationArea = All;
                    Caption = 'Statut cond.';
                }
                field("Condition Gravite"; Rec."Condition Gravite")
                {
                    ApplicationArea = All;
                    Caption = 'Gravite cond.';
                }
                field("Condition Delai Pct Min"; Rec."Condition Delai Pct Min")
                {
                    ApplicationArea = All;
                    Caption = 'Delai SLA pct';
                }
                field("Action Etape"; Rec."Action Etape")
                {
                    ApplicationArea = All;
                    Caption = 'Action etape';
                }
                field("Action Notification"; Rec."Action Notification")
                {
                    ApplicationArea = All;
                    Caption = 'Action notif.';
                }
                field("Nb Executions"; Rec."Nb Executions")
                {
                    ApplicationArea = All;
                    Caption = 'Executions';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.Actif then
            ActifStyle := 'Favorable'
        else
            ActifStyle := 'Unfavorable';
    end;

    var
        ActifStyle: Text;
}

page 65009 "Rec Workflow Rule Card"
{
    Caption = 'Regle Workflow';
    PageType = Card;
    SourceTable = "Rec Workflow Rule";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Identification';

                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Actif; Rec.Actif)
                {
                    ApplicationArea = All;
                }
                field("Ordre Evaluation"; Rec."Ordre Evaluation")
                {
                    ApplicationArea = All;
                    Caption = 'Ordre evaluation';
                    ToolTip = 'Plus petit = evalue en premier. Utilisez des pas de 10.';
                }
                field("Une Seule Fois"; Rec."Une Seule Fois")
                {
                    ApplicationArea = All;
                }
            }
            group(Conditions)
            {
                Caption = 'Conditions';

                field("Condition Statut"; Rec."Condition Statut")
                {
                    ApplicationArea = All;
                }
                field("Condition Etape"; Rec."Condition Etape")
                {
                    ApplicationArea = All;
                }
                field("Condition Gravite"; Rec."Condition Gravite")
                {
                    ApplicationArea = All;
                }
                field("Condition Priorite"; Rec."Condition Priorite")
                {
                    ApplicationArea = All;
                }
                field("Condition Delai Pct Min"; Rec."Condition Delai Pct Min")
                {
                    ApplicationArea = All;
                    ToolTip = 'Mettre 75 pour 75pct du SLA, 100 pour depassement. 0 = pas de condition.';
                }
                field("Condition Agence"; Rec."Condition Agence")
                {
                    ApplicationArea = All;
                }
                field("Condition Categorie"; Rec."Condition Categorie")
                {
                    ApplicationArea = All;
                }
            }
            group(ActionsRegles)
            {
                Caption = 'Actions';

                field("Action Etape"; Rec."Action Etape")
                {
                    ApplicationArea = All;
                }
                field("Action Statut"; Rec."Action Statut")
                {
                    ApplicationArea = All;
                }
                field("Action Priorite"; Rec."Action Priorite")
                {
                    ApplicationArea = All;
                }
                field("Action Notification"; Rec."Action Notification")
                {
                    ApplicationArea = All;
                }
                field("Action Message"; Rec."Action Message")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Variables : pct1=No Rec, pct2=Nom Client, pct3=Delai, pct4=Agence';
                }
                field("Action Attribuer A"; Rec."Action Attribuer A")
                {
                    ApplicationArea = All;
                }
                field("Action Forcer Hors Delai"; Rec."Action Forcer Hors Delai")
                {
                    ApplicationArea = All;
                }
            }
            group(Stats)
            {
                Caption = 'Statistiques';

                field("Nb Executions"; Rec."Nb Executions")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
