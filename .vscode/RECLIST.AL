page 65001 "Reclamation List PFE"
{
    Caption = 'Liste Réclamations Client Auto';
    PageType = List;
    SourceTable = Reclamation;
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "Reclamation Card PFE";

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field("No. Client"; Rec."No. Client")
                {
                    ApplicationArea = All;
                    Caption = 'N° Client';
                }
                field("Nom Client"; Rec."Nom Client")
                {
                    ApplicationArea = All;
                    Caption = 'Nom Client';
                }
                field("No. Serie Vehicule"; Rec."No. Serie Vehicule")
                {
                    ApplicationArea = All;
                    Caption = 'N° Série Véhicule';
                }
                field("No. Telephone"; Rec."No. Telephone")
                {
                    ApplicationArea = All;
                    Caption = 'N° Téléphone';
                }
                field(Canal; Rec.Canal)
                {
                    ApplicationArea = All;
                    Caption = 'Canal';
                }
                field("Type Reclamation"; Rec."Type Reclamation")
                {
                    ApplicationArea = All;
                    Caption = 'Type Réclamation';
                }
                field("Code Categorie"; Rec."Code Categorie")
                {
                    ApplicationArea = All;
                    Caption = 'Code Catégorie';
                }
                field(Gravite; Rec.Gravite)
                {
                    ApplicationArea = All;
                    Caption = 'Gravité';
                }
                field(Responsabilite; Rec.Responsabilite)
                {
                    ApplicationArea = All;
                    Caption = 'Responsabilité';
                }
                field("Attribue A"; Rec."Attribue A")
                {
                    ApplicationArea = All;
                    Caption = 'Attribué à';
                }
                field(Agence; Rec.Agence)
                {
                    ApplicationArea = All;
                    Caption = 'Agence';
                }
                field("Date Creation"; Rec."Date Creation")
                {
                    ApplicationArea = All;
                    Caption = 'Date Création';
                }
                field(Priorite; Rec.Priorite)
                {
                    ApplicationArea = All;
                    Caption = 'Priorité';
                    StyleExpr = PrioriteStyle;
                }
                field(Statut; Rec.Statut)
                {
                    ApplicationArea = All;
                    Caption = 'Statut';
                    StyleExpr = StatutStyle;
                }
                field("Date Cloture"; Rec."Date Cloture")
                {
                    ApplicationArea = All;
                    Caption = 'Date Clôture';
                }
                field("Delai Traitement"; Rec."Delai Traitement")
                {
                    ApplicationArea = All;
                    Caption = 'Délai (jours)';
                }
                field(Cloturee; Rec.Cloturee)
                {
                    ApplicationArea = All;
                    Caption = 'Clôturée';
                    Visible = false;
                }
                field("Retour Client"; Rec."Retour Client")
                {
                    ApplicationArea = All;
                    Caption = 'Retour Client';
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
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewReclamation)
            {
                ApplicationArea = All;
                Caption = 'Nouvelle Réclamation';
                Image = New;
                Promoted = true;
                PromotedCategory = New;

                trigger OnAction()
                begin
                    PAGE.Run(PAGE::"Reclamation Card PFE");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case Rec.Statut of
            Rec.Statut::" ":
                StatutStyle := 'Standard';
            Rec.Statut::Ouverte:
                StatutStyle := 'Unfavorable';
            Rec.Statut::"Prise en charge",
            Rec.Statut::"En cours":
                StatutStyle := 'Ambiguous';
            Rec.Statut::Cloturee:
                StatutStyle := 'Favorable';
        end;

        case Rec.Priorite of
            Rec.Priorite::" ":
                PrioriteStyle := 'Standard';
            Rec.Priorite::Faible:
                PrioriteStyle := 'Favorable';
            Rec.Priorite::Moyenne:
                PrioriteStyle := 'Ambiguous';
            Rec.Priorite::Haute:
                PrioriteStyle := 'Unfavorable';
        end;
    end;

    var
        StatutStyle: Text;
        PrioriteStyle: Text;
}