page 65006 "Rec Historique Client FB"
{
    PageType = ListPart;
    SourceTable = Reclamation;
    Caption = 'Historique Client';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("No_"; Rec."No_")
                {
                    ApplicationArea = All;
                    Caption = 'N° Réclamation';
                }
                field(Statut; Rec.Statut)
                {
                    ApplicationArea = All;
                    Caption = 'Statut';
                    StyleExpr = StatutStyle;
                }
                field("Date Creation"; Rec."Date Creation")
                {
                    ApplicationArea = All;
                    Caption = 'Date Création';
                }
                field(Gravite; Rec.Gravite)
                {
                    ApplicationArea = All;
                    Caption = 'Gravité';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case Rec.Statut of
            Rec.Statut::Ouverte:
                StatutStyle := 'Unfavorable';
            Rec.Statut::"PriseEnCharge",
            Rec.Statut::"EnCours":
                StatutStyle := 'Ambiguous';
            Rec.Statut::Cloturee:
                StatutStyle := 'Favorable';
            else
                StatutStyle := 'Standard';
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.GetFilter("No. Client") = '' then
            Rec.SetRange("No. Client", 'NO_CLIENT_VIDE')
        else
            Rec.SetRange("No. Client");
    end;

    var
        StatutStyle: Text;
}