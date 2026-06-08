page 65012 "Rec Workflow History FB"
{
    Caption = 'Historique Workflow';
    PageType = ListPart;
    SourceTable = "Rec Workflow History";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Date Heure"; Rec."Date Heure")
                {
                    ApplicationArea = All;
                    Caption = 'Date / Heure';
                }
                field("Etape Precedente"; Rec."Etape Precedente")
                {
                    ApplicationArea = All;
                    Caption = 'De';
                }
                field("Etape Suivante"; Rec."Etape Suivante")
                {
                    ApplicationArea = All;
                    Caption = 'Vers';
                    StyleExpr = EtapeStyle;
                }
                field("Statut Suivant"; Rec."Statut Suivant")
                {
                    ApplicationArea = All;
                    Caption = 'Nouveau Statut';
                    StyleExpr = StatutStyle;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Caption = 'Par';
                }
                field(Commentaire; Rec.Commentaire)
                {
                    ApplicationArea = All;
                    Caption = 'Commentaire';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case Rec."Etape Suivante" of
            Rec."Etape Suivante"::Cloture:
                EtapeStyle := 'Favorable';
            Rec."Etape Suivante"::Investigation,
            Rec."Etape Suivante"::ActionCorrective:
                EtapeStyle := 'Ambiguous';
            Rec."Etape Suivante"::Qualification,
            Rec."Etape Suivante"::Ouverture:
                EtapeStyle := 'Unfavorable';
            else
                EtapeStyle := 'Standard';
        end;

        case Rec."Statut Suivant" of
            Rec."Statut Suivant"::Cloturee:
                StatutStyle := 'Favorable';
            Rec."Statut Suivant"::EnCours,
            Rec."Statut Suivant"::PriseEnCharge:
                StatutStyle := 'Ambiguous';
            Rec."Statut Suivant"::Ouverte:
                StatutStyle := 'Unfavorable';
            else
                StatutStyle := 'Standard';
        end;
    end;

    var
        EtapeStyle: Text;
        StatutStyle: Text;
}