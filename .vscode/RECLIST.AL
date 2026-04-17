page 65001 "Reclamation List"
{
    Caption = 'Liste Réclamations Client Auto';
    PageType = List;
    SourceTable = Reclamation;
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "Reclamation Card";

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
                }
                field(Statut; Rec.Statut)
                {
                    ApplicationArea = All;
                    Caption = 'Statut';
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
                    PAGE.Run(PAGE::"Reclamation Card");
                end;
            }
        }
    }

}