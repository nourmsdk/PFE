page 65000 "Reclamation Card"
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
                group(ColonneGuauche)
                {
                    Caption = '';
                    ShowCaption = false;
                    field("No_"; Rec."No_")
                    {
                        ApplicationArea = ALL;
                        Caption = 'N° Réclamation';
                        Importance = Promoted;
                    }
                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;
                        Caption = 'Description';
                        MultiLine = true;

                    }
                    field("No. Serie Vehicule"; Rec."No. Serie Vehicule")
                    {
                        ApplicationArea = All;
                        Caption = 'N° Série Véhicule';

                    }
                    field(VIN; Rec.VIN)
                    {
                        ApplicationArea = All;
                        Caption = 'VIN';
                    }
                    field("No. Enregistrement Vehicule"; Rec."No. Enregistrement Vehicule")
                    {
                        ApplicationArea = All;
                        Caption = 'N° Enregistrement Véhicule';

                    }
                    field("No. Telephone"; Rec."No. Telephone")
                    {
                        ApplicationArea = All;
                        Caption = 'N° Téléphone';
                    }
                    field("No. Telephone 2"; Rec."No. Telephone 2")
                    {
                        ApplicationArea = All;
                        Caption = 'N° Téléphone 2';

                    }
                    field("Code Categorie"; Rec."Code Categorie")
                    {
                        ApplicationArea = All;
                        Caption = 'Code Catégorie';

                    }
                    field("Description Categorie"; Rec."Description Categorie")
                    {
                        ApplicationArea = All;
                        Caption = 'Description Catégorie';

                    }
                    field("Code Sous Categorie"; Rec."Code Sous Categorie")
                    {
                        ApplicationArea = All;
                        Caption = 'Code Sous-Catégorie';

                    }
                    field("Description Sous Categorie"; Rec."Description Sous Categorie")
                    {
                        ApplicationArea = All;
                        Caption = 'Description Sous-Catégorie';

                    }
                    field("Groupe Utilisateur"; Rec."Groupe Utilisateur")
                    {
                        ApplicationArea = All;
                        Caption = 'Groupe Utilisateur';
                    }

                }
                group(ColonneDroite)
                {
                    Caption = '';
                    ShowCaption = false;
                    field("Attribue A"; Rec."Attribue A")
                    {
                        ApplicationArea = All;
                        Caption = 'Centre de Gestion';
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
                    field("Description Action Prise"; Rec."Description Action Prise")
                    {
                        ApplicationArea = All;
                        Caption = 'Description Action Prise';
                        MultiLine = true;

                    }
                    field("Date Prise En Charge"; Rec."Date Prise En Charge")
                    {
                        ApplicationArea = All;
                        Caption = 'Date de Prise en Charge';
                    }
                    field("Date Validite"; Rec."Date Validite")
                    {
                        ApplicationArea = All;
                        Caption = 'Date Validité';
                    }
                    field("Date Cloture"; Rec."Date Cloture")
                    {
                        ApplicationArea = All;
                        Caption = 'Date Clôture';
                    }
                    field("Cloture Sans Action"; Rec."Cloture Sans Action")
                    {
                        ApplicationArea = All;
                        Caption = 'Clôture sans Action';

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
                    field("Commande Service"; Rec."Commande Service")
                    {
                        ApplicationArea = All;
                        Caption = 'Commande Service';
                    }
                    field("Commande Service Enregistre"; Rec."Commande Service Enregistre")
                    {
                        ApplicationArea = All;
                        Caption = 'Commande Service Enregistré';
                    }
                }
            }


        }
    }
    actions
    {
        area(Processing)
        {
            action(PrendreEnCharge)
            {
                ApplicationArea = All;
                Caption = 'Prendre en Charge';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Statut := Rec.Statut::"Prise en charge";
                    Rec."Date Prise En Charge" := Today();
                    Rec.Modify(true);
                end;
            }
            action(Cloturer)
            {
                ApplicationArea = All;
                Caption = 'Clôturer';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Statut := Rec.Statut::Cloturee;
                    Rec."Date Cloture" := Today();
                    Rec.Cloturee := true;
                    Rec.Modify(true);
                end;
            }
        }


    }



}
