page 65002 "Reclamation FactBox"
{
    PageType = CardPart;
    SourceTable = Reclamation;
    Caption = 'Indicateurs Réclamations';

    layout
    {
        area(Content)
        {
            group(Indicateurs)
            {
                field(TotalReclamations; TotalReclamations)
                {
                    ApplicationArea = All;
                    Caption = 'Total Réclamations';
                }

                field(NbOuvertes; NbOuvertes)
                {
                    ApplicationArea = All;
                    Caption = 'Ouvertes';
                }

                field(NbPriseEnCharge; NbPriseEnCharge)
                {
                    ApplicationArea = All;
                    Caption = 'Prise en charge';
                }

                field(NbCloturees; NbCloturees)
                {
                    ApplicationArea = All;
                    Caption = 'Clôturées';
                }

                field(NbPrioriteHaute; NbPrioriteHaute)
                {
                    ApplicationArea = All;
                    Caption = 'Priorité Haute';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalculerIndicateurs();
    end;

    trigger OnOpenPage()
    begin
        CalculerIndicateurs();
    end;

    local procedure CalculerIndicateurs()
    var
        RecReclamation: Record Reclamation;
    begin
        RecReclamation.Reset();

        // Total
        TotalReclamations := RecReclamation.Count;

        // Ouvertes
        RecReclamation.SetRange(Statut, RecReclamation.Statut::Ouverte);
        NbOuvertes := RecReclamation.Count;

        // Prise en charge
        RecReclamation.Reset();
        RecReclamation.SetRange(Statut, RecReclamation.Statut::"Prise en charge");
        NbPriseEnCharge := RecReclamation.Count;

        // Clôturées
        RecReclamation.Reset();
        RecReclamation.SetRange(Statut, RecReclamation.Statut::Cloturee);
        NbCloturees := RecReclamation.Count;

        // Priorité haute
        RecReclamation.Reset();
        RecReclamation.SetRange(Priorite, RecReclamation.Priorite::Haute);
        NbPrioriteHaute := RecReclamation.Count;

        CurrPage.Update();
    end;

    var
        TotalReclamations: Integer;
        NbOuvertes: Integer;
        NbPriseEnCharge: Integer;
        NbCloturees: Integer;
        NbPrioriteHaute: Integer;
}