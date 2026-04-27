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
                field("Code Categorie"; Rec."Code Categorie")
                {
                    ApplicationArea = All;
                    Caption = 'Code Catégorie';
                }
                field("Groupe Utilisateur"; Rec."Groupe Utilisateur")
                {
                    ApplicationArea = All;
                    Caption = 'Groupe Utilisateur';
                }
                field("Attribue A"; Rec."Attribue A")
                {
                    ApplicationArea = All;
                    Caption = 'Attribué à';
                }
                field("Centre Gestion"; Rec."Centre Gestion")
                {
                    ApplicationArea = All;
                    Caption = 'Centre de Gestion';
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
                field(Cloturee; Rec.Cloturee)
                {
                    ApplicationArea = All;
                    Caption = 'Clôturée';
                }
                field("Retour Client"; Rec."Retour Client")
                {
                    ApplicationArea = All;
                    Caption = 'Retour Client';
                }
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
        // Couleurs Statut
        case Rec.Statut of
            Rec.Statut::" ":
                StatutStyle := 'Standard';
            Rec.Statut::Ouverte:
                StatutStyle := 'Unfavorable';
            Rec.Statut::"Prise en charge":
                StatutStyle := 'Ambiguous';
            Rec.Statut::"En cours":
                StatutStyle := 'Ambiguous';
            Rec.Statut::Cloturee:
                StatutStyle := 'Favorable';
        end;

        // Couleurs Priorité
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