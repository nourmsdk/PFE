page 65014 "Rec Action Corrective Subpage"
{
    PageType = ListPart;
    SourceTable = "Rec Action Corrective";
    Caption = 'Actions Correctives';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = not Rec."Genere Automatiquement";
                }
                field("Statut"; Rec.Statut)
                {
                    ApplicationArea = All;
                    Caption = 'Statut';
                    StyleExpr = StatutStyle;
                }

                field("Date Prevue"; Rec."Date Prevue")
                {
                    ApplicationArea = All;
                    Caption = 'Date prévue';
                }
                field("Date Realisee"; Rec."Date Realisee")
                {
                    ApplicationArea = All;
                    Caption = 'Date réalisée';
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
                    Caption = 'Délai (j)';
                }
                field("Jours Restants"; Rec."Jours Restants")
                {
                    ApplicationArea = All;
                    Caption = 'Jours restants';
                    StyleExpr = JoursRestantsStyle;
                    ToolTip = 'Négatif = en retard, positif = jours restants avant échéance';
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Demarrer)
            {
                ApplicationArea = All;
                Caption = 'Démarrer';
                Image = Start;
                Enabled = Rec.Statut = "Statut Action Corrective"::Planifiee;

                trigger OnAction()
                begin
                    Rec.Statut := "Statut Action Corrective"::EnCours;
                    Rec.CalculerDelaiEtRetard();
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }

            action(Terminer)
            {
                ApplicationArea = All;
                Caption = 'Terminer';
                Image = Completed;
                Enabled = Rec.Statut = "Statut Action Corrective"::EnCours;

                trigger OnAction()
                begin
                    if Rec."Date Realisee" = 0D then
                        Rec."Date Realisee" := Today();
                    Rec.Statut := "Statut Action Corrective"::Terminee;
                    Rec.CalculerDelaiEtRetard();
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }

            action(AnnulerAction)
            {
                ApplicationArea = All;
                Caption = 'Annuler action';
                Image = Cancel;
                Enabled = Rec.Statut <> "Statut Action Corrective"::Terminee;

                trigger OnAction()
                begin
                    if not Confirm('Voulez-vous vraiment annuler cette action ?', false) then
                        exit;
                    Rec.Statut := "Statut Action Corrective"::Annulee;
                    Rec.CalculerDelaiEtRetard();
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }

            action(RecalculerRetards)
            {
                ApplicationArea = All;
                Caption = 'Recalculer retards';
                Image = Refresh;

                trigger OnAction()
                var
                    ActionCorr: Record "Rec Action Corrective";
                begin
                    ActionCorr.Reset();
                    ActionCorr.SetRange("No Reclamation", Rec."No Reclamation");
                    if ActionCorr.FindSet(true) then
                        repeat
                            ActionCorr.CalculerDelaiEtRetard();
                            ActionCorr.Modify(false);
                        until ActionCorr.Next() = 0;
                    CurrPage.Update(false);
                end;
            }
        }
    }


    var
        RetardStyle: Text;
        StatutStyle: Text;
        NoReclamation: Code[20];
        JoursRestantsStyle: Text;

    procedure SetNoReclamation(NoRec: Code[20])
    begin
        NoReclamation := NoRec;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."No Reclamation" = '' then
            Rec."No Reclamation" := NoReclamation;
    end;

    trigger OnAfterGetRecord()
    begin
        // Style retard
        if Rec."Indicateur Retard" then
            RetardStyle := 'Unfavorable'
        else
            RetardStyle := 'Favorable';

        // Style statut
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
        // Style jours restants
        if Rec."Jours Restants" < 0 then
            JoursRestantsStyle := 'Unfavorable'   // rouge — en retard
        else if Rec."Jours Restants" <= 3 then
            JoursRestantsStyle := 'Ambiguous'     // orange — urgent
        else
            JoursRestantsStyle := 'Favorable';    // vert — OK
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage.Update(false);
        exit(true);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage.Update(false);
        exit(true);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update(false);
        exit(true);
    end;
}