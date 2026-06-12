// =============================================================================
// Page 65016 — Vue managériale globale des actions correctives
// Toutes les actions de toutes les réclamations
// Filtres : Statut, Responsable, Retard
// KPI intégrés pour Power BI
// =============================================================================
page 65016 "Rec Action Corrective Mgr"
{
    PageType = List;
    SourceTable = "Rec Action Corrective";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Actions Correctives — Vue Managériale';
    CardPageId = "Reclamation Card PFE";
    Editable = false;
    SourceTableView = sorting("No Reclamation", "Statut");

    layout
    {
        area(Content)
        {
            // ── KPI en haut de page ──────────────────────────────────────
            group(KPI)
            {
                Caption = 'Indicateurs';
                ShowCaption = true;

                field(KpiTotales; KpiTotales)
                {
                    ApplicationArea = All;
                    Caption = 'Total actions';
                    Editable = false;
                    ToolTip = 'Nombre total d''actions correctives visibles (selon filtres actifs).';
                }
                field(KpiPlanifiees; KpiPlanifiees)
                {
                    ApplicationArea = All;
                    Caption = 'Planifiées';
                    Editable = false;
                    StyleExpr = 'Standard';
                }
                field(KpiEnCours; KpiEnCours)
                {
                    ApplicationArea = All;
                    Caption = 'En cours';
                    Editable = false;
                    StyleExpr = 'Ambiguous';
                }
                field(KpiTerminees; KpiTerminees)
                {
                    ApplicationArea = All;
                    Caption = 'Terminées';
                    Editable = false;
                    StyleExpr = 'Favorable';
                }
                field(KpiAnnulees; KpiAnnulees)
                {
                    ApplicationArea = All;
                    Caption = 'Annulées';
                    Editable = false;
                    StyleExpr = 'Subordinate';
                }
                field(KpiEnRetard; KpiEnRetard)
                {
                    ApplicationArea = All;
                    Caption = 'En retard';
                    Editable = false;
                    StyleExpr = KpiRetardStyle;
                    ToolTip = 'Actions Planifiées ou En cours dont la date prévue est dépassée.';
                }
                field(KpiPctTerminees; KpiPctTerminees)
                {
                    ApplicationArea = All;
                    Caption = '% Terminées';
                    Editable = false;
                    DecimalPlaces = 1 : 1;
                    StyleExpr = KpiPctStyle;
                    ToolTip = 'Taux de complétion = Terminées / (Total - Annulées).';
                }
            }

            // ── Liste principale ─────────────────────────────────────────
            repeater(Lines)
            {
                field("No Reclamation"; Rec."No Reclamation")
                {
                    ApplicationArea = All;
                    Caption = 'N° Réclamation';
                    StyleExpr = 'Strong';
                }
                field(NomClient; NomClient)
                {
                    ApplicationArea = All;
                    Caption = 'Client';
                    Editable = false;
                }
                field(AgenceReclamation; AgenceReclamation)
                {
                    ApplicationArea = All;
                    Caption = 'Agence';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description action';
                }
                field(Statut; Rec.Statut)
                {
                    ApplicationArea = All;
                    Caption = 'Statut';
                    StyleExpr = StatutStyle;
                }
                field(Responsable; Rec.Responsable)
                {
                    ApplicationArea = All;
                    Caption = 'Responsable';
                }
                field("Date Prevue"; Rec."Date Prevue")
                {
                    ApplicationArea = All;
                    Caption = 'Date prévue';
                    StyleExpr = DatePrevueStyle;
                }
                field("Date Realisee"; Rec."Date Realisee")
                {
                    ApplicationArea = All;
                    Caption = 'Date réalisée';
                }
                field("Jours Restants"; Rec."Jours Restants")
                {
                    ApplicationArea = All;
                    Caption = 'Jours restants';
                    StyleExpr = JoursRestantsStyle;
                    ToolTip = 'Négatif = en retard, positif = jours restants avant échéance.';
                }
                field("Indicateur Retard"; Rec."Indicateur Retard")
                {
                    ApplicationArea = All;
                    Caption = 'Retard';
                    StyleExpr = RetardStyle;
                }
                field("Delai Realisation"; Rec."Delai Realisation")
                {
                    ApplicationArea = All;
                    Caption = 'Délai réalisation (j)';
                }
                field(Commentaire; Rec.Commentaire)
                {
                    ApplicationArea = All;
                    Caption = 'Commentaire';
                }
            }
        }

        area(FactBoxes)
        {
            systempart(Links; Links) { ApplicationArea = All; }
            systempart(Notes; Notes) { ApplicationArea = All; }
        }
    }

    actions
    {
        area(Processing)
        {
            // ── Filtres rapides ──────────────────────────────────────────
            action(FiltrerEnRetard)
            {
                ApplicationArea = All;
                Caption = '⚠ En retard uniquement';
                Image = Warning;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Affiche uniquement les actions en retard.';

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange("Indicateur Retard", true);
                    Rec.SetFilter(Statut, '%1|%2',
                        "Statut Action Corrective"::Planifiee,
                        "Statut Action Corrective"::EnCours);
                    CurrPage.Update(false);
                    CalculerKPI();
                end;
            }

            action(FiltrerEnCours)
            {
                ApplicationArea = All;
                Caption = 'En cours';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Affiche uniquement les actions En cours.';

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange(Statut, "Statut Action Corrective"::EnCours);
                    CurrPage.Update(false);
                    CalculerKPI();
                end;
            }

            action(FiltrerPlanifiees)
            {
                ApplicationArea = All;
                Caption = 'Planifiées';
                Image = Planning;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Affiche uniquement les actions Planifiées.';

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange(Statut, "Statut Action Corrective"::Planifiee);
                    CurrPage.Update(false);
                    CalculerKPI();
                end;
            }

            action(EffacerFiltres)
            {
                ApplicationArea = All;
                Caption = 'Tous';
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Supprime tous les filtres et affiche toutes les actions.';

                trigger OnAction()
                begin
                    Rec.Reset();
                    CurrPage.Update(false);
                    CalculerKPI();
                end;
            }

            // ── Actions métier ───────────────────────────────────────────
            action(RecalculerTout)
            {
                ApplicationArea = All;
                Caption = 'Recalculer retards';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Recalcule les indicateurs de retard et jours restants pour toutes les actions visibles.';

                trigger OnAction()
                var
                    ActionCorr: Record "Rec Action Corrective";
                begin
                    ActionCorr.Reset();
                    if ActionCorr.FindSet(true) then
                        repeat
                            ActionCorr.CalculerDelaiEtRetard();
                            ActionCorr.Modify(false);
                        until ActionCorr.Next() = 0;
                    CurrPage.Update(false);
                    CalculerKPI();
                    Message('Recalcul terminé — %1 action(s) mise(s) à jour.', ActionCorr.Count());
                end;
            }

            action(OuvrirReclamation)
            {
                ApplicationArea = All;
                Caption = 'Ouvrir réclamation';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Ouvre la fiche réclamation liée à cette action.';

                trigger OnAction()
                var
                    Reclamation: Record Reclamation;
                    RecCard: Page "Reclamation Card PFE";
                begin
                    if Rec."No Reclamation" = '' then exit;
                    if Reclamation.Get(Rec."No Reclamation") then begin
                        RecCard.SetRecord(Reclamation);
                        RecCard.Run();
                    end;
                end;
            }
        }

        area(Reporting)
        {
            action(ExporterKPI)
            {
                ApplicationArea = All;
                Caption = 'Exporter KPI';
                Image = Export;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Affiche un résumé KPI pour export Power BI.';

                trigger OnAction()
                begin
                    Message(
                        'KPI Actions Correctives\' +
                        '─────────────────────────\' +
                        'Total         : %1\' +
                        'Planifiées    : %2\' +
                        'En cours      : %3\' +
                        'Terminées     : %4\' +
                        'Annulées      : %5\' +
                        'En retard     : %6\' +
                        'Taux complétion : %7 %%',
                        KpiTotales, KpiPlanifiees, KpiEnCours,
                        KpiTerminees, KpiAnnulees, KpiEnRetard,
                        KpiPctTerminees);
                end;
            }
        }
    }

    // ── Filtres rapides natifs BC (panneau filtre latéral) ───────────────
    views
    {
        view(ViewEnRetard)
        {
            Caption = 'En retard';
            Filters = where("Indicateur Retard" = const(true));
            SharedLayout = true;
        }
        view(ViewPlanifiees)
        {
            Caption = 'Planifiées';
            Filters = where(Statut = const(Planifiee));
            SharedLayout = true;
        }
        view(ViewEnCours)
        {
            Caption = 'En cours';
            Filters = where(Statut = const(EnCours));
            SharedLayout = true;
        }
        view(ViewTerminees)
        {
            Caption = 'Terminées';
            Filters = where(Statut = const(Terminee));
            SharedLayout = true;
        }
        view(ViewActives)
        {
            Caption = 'Actives (non clôturées)';
            Filters = where(Statut = filter(Planifiee | EnCours));
            SharedLayout = true;
        }
    }

    // ── Triggers page ────────────────────────────────────────────────────
    trigger OnOpenPage()
    begin
        CalculerKPI();
    end;

    trigger OnAfterGetRecord()
    var
        Reclamation: Record Reclamation;
    begin
        // Récupérer client et agence depuis la réclamation liée
        if Reclamation.Get(Rec."No Reclamation") then begin
            NomClient := Reclamation."Nom Client";
            AgenceReclamation := Reclamation.Agence;
        end else begin
            NomClient := '';
            AgenceReclamation := '';
        end;

        // Style Statut
        case Rec.Statut of
            "Statut Action Corrective"::Planifiee:
                StatutStyle := 'Standard';
            "Statut Action Corrective"::EnCours:
                StatutStyle := 'Ambiguous';
            "Statut Action Corrective"::Terminee:
                StatutStyle := 'Favorable';
            "Statut Action Corrective"::Annulee:
                StatutStyle := 'Subordinate';
        end;

        // Style Retard
        if Rec."Indicateur Retard" then
            RetardStyle := 'Unfavorable'
        else
            RetardStyle := 'Favorable';

        // Style Jours Restants
        if Rec."Jours Restants" < 0 then
            JoursRestantsStyle := 'Unfavorable'
        else if Rec."Jours Restants" <= 3 then
            JoursRestantsStyle := 'Ambiguous'
        else
            JoursRestantsStyle := 'Favorable';

        // Style Date Prévue
        if (Rec."Date Prevue" <> 0D) and (Rec."Date Prevue" < Today()) and
           (Rec.Statut in ["Statut Action Corrective"::Planifiee, "Statut Action Corrective"::EnCours])
        then
            DatePrevueStyle := 'Unfavorable'
        else
            DatePrevueStyle := 'Standard';
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculerKPI();
    end;

    // ── Calcul KPI ───────────────────────────────────────────────────────
    local procedure CalculerKPI()
    var
        ActionCorr: Record "Rec Action Corrective";
        NbActives: Integer;
    begin
        ActionCorr.Reset();
        KpiTotales := ActionCorr.Count();

        ActionCorr.SetRange(Statut, "Statut Action Corrective"::Planifiee);
        KpiPlanifiees := ActionCorr.Count();

        ActionCorr.SetRange(Statut, "Statut Action Corrective"::EnCours);
        KpiEnCours := ActionCorr.Count();

        ActionCorr.SetRange(Statut, "Statut Action Corrective"::Terminee);
        KpiTerminees := ActionCorr.Count();

        ActionCorr.SetRange(Statut, "Statut Action Corrective"::Annulee);
        KpiAnnulees := ActionCorr.Count();

        ActionCorr.Reset();
        ActionCorr.SetRange("Indicateur Retard", true);
        ActionCorr.SetFilter(Statut, '%1|%2',
            "Statut Action Corrective"::Planifiee,
            "Statut Action Corrective"::EnCours);
        KpiEnRetard := ActionCorr.Count();

        // Taux complétion = Terminées / (Total - Annulées)
        NbActives := KpiTotales - KpiAnnulees;
        if NbActives > 0 then
            KpiPctTerminees := Round((KpiTerminees / NbActives) * 100, 0.1)
        else
            KpiPctTerminees := 0;

        // Style KPI retard
        if KpiEnRetard > 0 then
            KpiRetardStyle := 'Unfavorable'
        else
            KpiRetardStyle := 'Favorable';

        // Style % terminées
        if KpiPctTerminees >= 80 then
            KpiPctStyle := 'Favorable'
        else if KpiPctTerminees >= 50 then
            KpiPctStyle := 'Ambiguous'
        else
            KpiPctStyle := 'Unfavorable';
    end;

    // ── Variables ────────────────────────────────────────────────────────
    var
        // Colonnes calculées
        NomClient: Text[100];
        AgenceReclamation: Code[20];

        // Styles lignes
        StatutStyle: Text;
        RetardStyle: Text;
        JoursRestantsStyle: Text;
        DatePrevueStyle: Text;

        // KPI
        KpiTotales: Integer;
        KpiPlanifiees: Integer;
        KpiEnCours: Integer;
        KpiTerminees: Integer;
        KpiAnnulees: Integer;
        KpiEnRetard: Integer;
        KpiPctTerminees: Decimal;

        // Styles KPI
        KpiRetardStyle: Text;
        KpiPctStyle: Text;
}
