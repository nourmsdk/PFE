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
                        Caption = 'N° Réclamation';
                        Importance = Promoted;
                    }

                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;
                        Caption = 'Description';
                        Editable = EstModifiable;
                        MultiLine = true;
                    }

                    field("No. Client"; Rec."No. Client")
                    {
                        ApplicationArea = All;
                        Caption = 'N° Client';
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

                    field("No. Telephone 2"; Rec."No. Telephone 2")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("Code Categorie"; Rec."Code Categorie")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("Description Categorie"; Rec."Description Categorie")
                    {
                        ApplicationArea = All;
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
                    }

                    field(Responsabilite; Rec.Responsabilite)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("No. Facture"; Rec."No. Facture")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("No. Ordre Reparation"; Rec."No. Ordre Reparation")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }
                }

                group(ColonneDroite)
                {
                    ShowCaption = false;

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

                    field("Date Creation"; Rec."Date Creation")
                    {
                        ApplicationArea = All;
                    }

                    field(Priorite; Rec.Priorite)
                    {
                        ApplicationArea = All;
                        StyleExpr = PrioriteStyle;
                        Editable = EstModifiable;
                    }

                    field(Statut; Rec.Statut)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                        StyleExpr = StatutStyle;
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

                    field("Date Validite"; Rec."Date Validite")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("Date Cloture"; Rec."Date Cloture")
                    {
                        ApplicationArea = All;
                    }

                    field("Delai Traitement"; Rec."Delai Traitement")
                    {
                        ApplicationArea = All;
                    }

                    // 👇 INVISIBLE
                    field(Cloturee; Rec.Cloturee)
                    {
                        ApplicationArea = All;
                        Visible = false;
                    }

                    field("Retour Client"; Rec."Retour Client")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }
                }
            }
        }

        // 🔥 FACTBOX AJOUTÉ ICI
        area(FactBoxes)
        {
            part(FactBoxRec; "Reclamation FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No_" = FIELD("No_");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PrendreEnChargePFE)
            {
                ApplicationArea = All;
                Caption = 'Prendre en Charge';
                Image = Approve;
                Promoted = true;

                trigger OnAction()
                begin
                    if Rec.Cloturee then
                        Error('Impossible de modifier une réclamation clôturée.');

                    if Rec.Description = '' then
                        Error('Renseigner la Description.');

                    Rec.Statut := Rec.Statut::"Prise en charge";
                    Rec."Date Prise En Charge" := Today();
                    Rec.Modify(true);
                end;
            }

            action(CloturerPFE)
            {
                ApplicationArea = All;
                Caption = 'Clôturer';
                Image = Close;
                Promoted = true;

                trigger OnAction()
                begin
                    if Rec.Cloturee then
                        Error('Déjà clôturée.');

                    if Rec."Description Action Prise" = '' then
                        Error('Renseigner Action.');

                    Rec.Statut := Rec.Statut::Cloturee;
                    Rec."Date Cloture" := Today();
                    Rec.Cloturee := true;
                    Rec.Modify(true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case Rec.Statut of
            Rec.Statut::Ouverte:
                StatutStyle := 'Unfavorable';
            Rec.Statut::"Prise en charge",
            Rec.Statut::"En cours":
                StatutStyle := 'Ambiguous';
            Rec.Statut::Cloturee:
                StatutStyle := 'Favorable';
        end;

        case Rec.Priorite of
            Rec.Priorite::Faible:
                PrioriteStyle := 'Favorable';
            Rec.Priorite::Moyenne:
                PrioriteStyle := 'Ambiguous';
            Rec.Priorite::Haute:
                PrioriteStyle := 'Unfavorable';
        end;

        EstModifiable := not Rec.Cloturee;
    end;

    var
        StatutStyle: Text;
        PrioriteStyle: Text;
        EstModifiable: Boolean;
}