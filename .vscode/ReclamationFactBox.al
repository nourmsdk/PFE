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
                Caption = 'Statistiques';

                field(TotalReclamations; TotalReclamations)
                {
                    ApplicationArea = All;
                    Caption = 'Total Réclamations';
                    Style = Strong;
                }
                field(NbOuvertes; NbOuvertes)
                {
                    ApplicationArea = All;
                    Caption = 'Ouvertes';
                    StyleExpr = StyleOuvertes;
                }
                field(NbPriseEnCharge; NbPriseEnCharge)
                {
                    ApplicationArea = All;
                    Caption = 'Prise en Charge';
                    StyleExpr = StylePriseEnCharge;
                }
                field(NbEnCours; NbEnCours)
                {
                    ApplicationArea = All;
                    Caption = 'En Cours';
                    StyleExpr = StyleEnCours;
                }
                field(NbCloturees; NbCloturees)
                {
                    ApplicationArea = All;
                    Caption = 'Clôturées';
                    StyleExpr = StyleCloturees;
                }
                field(NbPrioriteHaute; NbPrioriteHaute)
                {
                    ApplicationArea = All;
                    Caption = 'Priorité Haute';
                    StyleExpr = StylePrioriteHaute;
                }
                field(NbGraviteCritique; NbGraviteCritique)
                {
                    ApplicationArea = All;
                    Caption = 'Gravité Critique';
                    StyleExpr = StyleGraviteCritique;
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
        // Total
        RecReclamation.Reset();
        TotalReclamations := RecReclamation.Count;

        // Ouvertes
        RecReclamation.Reset();
        RecReclamation.SetRange(Statut, RecReclamation.Statut::Ouverte);
        NbOuvertes := RecReclamation.Count;

        // Prise en charge
        RecReclamation.Reset();
        RecReclamation.SetRange(Statut, RecReclamation.Statut::"Prise en charge");
        NbPriseEnCharge := RecReclamation.Count;

        // En cours
        RecReclamation.Reset();
        RecReclamation.SetRange(Statut, RecReclamation.Statut::"En cours");
        NbEnCours := RecReclamation.Count;

        // Clôturées
        RecReclamation.Reset();
        RecReclamation.SetRange(Statut, RecReclamation.Statut::Cloturee);
        NbCloturees := RecReclamation.Count;

        // Priorité haute
        RecReclamation.Reset();
        RecReclamation.SetRange(Priorite, RecReclamation.Priorite::Haute);
        NbPrioriteHaute := RecReclamation.Count;

        // Gravité critique
        RecReclamation.Reset();
        RecReclamation.SetRange(Gravite, RecReclamation.Gravite::Critique);
        NbGraviteCritique := RecReclamation.Count;

        // Styles
        if NbOuvertes > 0 then
            StyleOuvertes := 'Unfavorable'
        else
            StyleOuvertes := 'Favorable';

        if NbPriseEnCharge > 0 then
            StylePriseEnCharge := 'Ambiguous'
        else
            StylePriseEnCharge := 'Standard';

        if NbEnCours > 0 then
            StyleEnCours := 'Ambiguous'
        else
            StyleEnCours := 'Standard';

        if NbCloturees > 0 then
            StyleCloturees := 'Favorable'
        else
            StyleCloturees := 'Standard';

        if NbPrioriteHaute > 0 then
            StylePrioriteHaute := 'Unfavorable'
        else
            StylePrioriteHaute := 'Standard';

        if NbGraviteCritique > 0 then
            StyleGraviteCritique := 'Unfavorable'
        else
            StyleGraviteCritique := 'Standard';
    end;

    var
        TotalReclamations: Integer;
        NbOuvertes: Integer;
        NbPriseEnCharge: Integer;
        NbEnCours: Integer;
        NbCloturees: Integer;
        NbPrioriteHaute: Integer;
        NbGraviteCritique: Integer;
        StyleOuvertes: Text;
        StylePriseEnCharge: Text;
        StyleEnCours: Text;
        StyleCloturees: Text;
        StylePrioriteHaute: Text;
        StyleGraviteCritique: Text;
}