page 65000 "Reclamation Card PFE"
{
    Caption = 'Fiche Réclamation Client Auto';
    PageType = Card;
    SourceTable = Reclamation;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Général';

                group(ColonneGauche)
                {
                    ShowCaption = false;

                    field("No_"; Rec."No_")
                    {
                        ApplicationArea = All;
                    }

                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                        MultiLine = true;
                    }

                    field("No. Client"; Rec."No. Client")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("Nom Client"; Rec."Nom Client")
                    {
                        ApplicationArea = All;
                    }

                    field("No. Serie Vehicule"; Rec."No. Serie Vehicule")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field(VIN; Rec.VIN)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("No. Enregistrement Vehicule"; Rec."No. Enregistrement Vehicule")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("No. Telephone"; Rec."No. Telephone")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("Code Categorie"; Rec."Code Categorie")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }
                    field("Code Sous Categorie"; Rec."Code Sous Categorie")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }
                    field("Description Sous Categorie"; Rec."Description Sous Categorie")
                    {
                        ApplicationArea = All;
                    }

                    field("Description Categorie"; Rec."Description Categorie")
                    {
                        ApplicationArea = All;
                    }
                    field("No. Ordre Reparation"; Rec."No. Ordre Reparation")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }
                    field("No. Facture"; Rec."No. Facture")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }
                    field("Date Creation"; Rec."Date Creation")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }

                group(ColonneDroite)
                {
                    ShowCaption = false;

                    field(Statut; Rec.Statut)
                    {
                        ApplicationArea = All;
                        StyleExpr = StatutStyle;
                        Editable = EstModifiable;
                    }

                    field(Priorite; Rec.Priorite)
                    {
                        ApplicationArea = All;
                        StyleExpr = PrioriteStyle;
                        Editable = EstModifiable;
                    }

                    field("Description Action Prise"; Rec."Description Action Prise")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                        MultiLine = true;
                    }

                    field("Date Prise En Charge"; Rec."Date Prise En Charge")
                    {
                        ApplicationArea = All;
                    }

                    field("Date Cloture"; Rec."Date Cloture")
                    {
                        ApplicationArea = All;
                    }
                    field("Retour Client"; Rec."Retour Client")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }
                    field("Date Mise En Cours"; Rec."Date Mise En Cours")
                    {
                        ApplicationArea = All;
                    }
                    field("Delai En Cours"; Rec."Delai En Cours")
                    {
                        ApplicationArea = All;
                        StyleExpr = DelaiStyle;
                    }

                    field("Statut SLA"; HorsDelaiTexte)
                    {
                        ApplicationArea = All;
                        StyleExpr = HorsDelaiStyle;
                        Editable = false;
                    }
                    field(Canal; Rec.Canal)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("Type Reclamation"; Rec."Type Reclamation")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field(Gravite; Rec.Gravite)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                        StyleExpr = GraviteStyle;
                    }

                    field(Responsabilite; Rec.Responsabilite)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("Attribue A"; Rec."Attribue A")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field(Agence; Rec.Agence)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }
                    field("Nom Agence"; Rec."Nom Agence")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
        area(FactBoxes)
        {
            part(ReclamationFactBox; "Reclamation FactBox")
            {
                ApplicationArea = All;
                Caption = 'Indicateurs';
            }
            part(HistoriqueClientFB; "Rec Historique Client FB")
            {
                ApplicationArea = All;
                Caption = 'Historique Client';
                SubPageLink = "No. Client" = field("No. Client");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PrendreEnChargePFE)
            {
                Enabled = (Rec.Statut = Rec.Statut::Ouverte);
                ApplicationArea = All;
                Caption = 'Prendre en Charge';
                Image = Approve;

                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec.Description = '' then
                        Error('Vous devez renseigner la Description Action Prise.');

                    Rec.Statut := Rec.Statut::"Prise en charge";
                    Rec."Date Prise En Charge" := Today();
                    if not Rec.Cloturee then Rec.CalculerDelaiTraitement();
                    Rec.Modify(true);
                    CurrPage.Update(true);
                end;
            }
            action(MettreEnCoursPFE)
            {
                Enabled = (Rec.Statut = Rec.Statut::"Prise en charge");  // visible seulement si statut correct
                ApplicationArea = All;
                Caption = 'Mettre En Cours';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;


                trigger OnAction()
                begin
                    // Vérification du statut
                    if Rec.Statut <> Rec.Statut::"Prise en charge" then
                        Error('La réclamation doit être "Prise en charge" avant de la mettre En Cours.');

                    // Changement de statut + date
                    Rec.Statut := Rec.Statut::"En cours";
                    Rec."Date Mise En Cours" := Today();
                    Rec.Modify(true);

                    CurrPage.Update(true);
                    Message('Réclamation passée En Cours.');
                end;
            }

            action(CloturerPFE)
            {
                ApplicationArea = All;
                Caption = 'Clôturer';
                Image = Close;

                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = (Rec.Statut <> Rec.Statut::Cloturee) and (Rec."Code Categorie" <> '');

                trigger OnAction()
                begin
                    if Rec."No. Client" = '' then Error('Vous devez associer un client avant de clôturer.');
                    if Rec."Description Action Prise" = '' then Error('Vous devez renseigner la Description Action Prise avant de clôturer la réclamation');
                    if Rec."Code Categorie" = '' then Error('Vous devez renseigner le Code Catégorie avant de clôturer la réclamation.');

                    Rec.Statut := Rec.Statut::Cloturee;
                    Rec."Date Cloture" := Today();
                    Rec.Cloturee := true;

                    Rec.Modify(true);

                    CurrPage.Update(true);

                end;
            }

            action(RouvrirPFE)
            {
                ApplicationArea = All;
                Caption = 'Rouvrir';
                Image = ReOpen;

                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                Enabled = (Rec.Statut = Rec.Statut::Cloturee);

                trigger OnAction()
                begin
                    Rec.Statut := Rec.Statut::Ouverte;
                    Rec."Date Cloture" := 0D;
                    Rec.Cloturee := false;
                    Rec.CalculerDelaiTraitement();
                    Rec.Modify(true);
                    CurrPage.Update(true);
                    Message('Réclamation réouverte avec succès.');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        if not Rec.Cloturee then
            Rec.CalculerDelaiTraitement();

        // Style Statut
        case Rec.Statut of
            Rec.Statut::Ouverte:
                StatutStyle := 'Unfavorable';

            Rec.Statut::"Prise en charge",
            Rec.Statut::"En cours":
                StatutStyle := 'Ambiguous';

            Rec.Statut::Cloturee:
                StatutStyle := 'Favorable';
        end;

        // Style Priorité
        case Rec.Priorite of
            Rec.Priorite::Faible:
                PrioriteStyle := 'Favorable';

            Rec.Priorite::Moyenne:
                PrioriteStyle := 'Ambiguous';

            Rec.Priorite::Haute:
                PrioriteStyle := 'Unfavorable';
        end;
        case Rec.Gravite of
            Rec.Gravite::Critique:
                GraviteStyle := 'Unfavorable';
            Rec.Gravite::Haute:
                GraviteStyle := 'Attention';
            Rec.Gravite::Moyenne:
                GraviteStyle := 'Ambiguous';
            Rec.Gravite::Faible:
                GraviteStyle := 'Favorable';
        end;

        // Style Délai + Hors Délai
        if Rec."Hors Delai" then begin
            DelaiStyle := 'Unfavorable';
            HorsDelaiStyle := 'Unfavorable';
        end else if Rec."Delai En Cours" > 5 then begin
            DelaiStyle := 'Ambiguous';
            HorsDelaiStyle := 'Standard';
        end else begin
            DelaiStyle := 'Favorable';
            HorsDelaiStyle := 'Favorable';
        end;

        // Texte badge SLA
        if Rec."Hors Delai" then
            HorsDelaiTexte := ' HORS SLA'
        else
            HorsDelaiTexte := ' Dans les délais';

        EstModifiable := (Rec.Statut <> Rec.Statut::Cloturee);
    end;




    var
        StatutStyle: Text;
        PrioriteStyle: Text;
        DelaiStyle: Text;
        HorsDelaiStyle: Text;
        HorsDelaiTexte: Text;
        GraviteStyle: Text;
        EstModifiable: Boolean;
}