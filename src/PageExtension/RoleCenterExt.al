pageextension 65002 "DLT RoleCenter Ext PFE" extends "DLT Complaint RoleCenter"
{
    layout
    {
        modify("DLT Complaint Cue")
        {
            visible = false;
        }

    }

    actions
    {
        addlast(Creation)
        {
            action(NouvelleReclamationPFE)
            {
                ApplicationArea = All;
                Caption = 'Nouvelle réclamation';
                Image = New;
                RunObject = page "Reclamation Card PFE";
                RunPageMode = Create;
                ToolTip = 'Ouvrir une fiche pour saisir une nouvelle réclamation client.';
            }
        }

        // ── Masquer les raccourcis du module Réclamation d'origine (ELVA STD) ──
        modify(Complaint)
        {
            Visible = false;
        }
        modify(ComplaintListEmbedded)
        {
            Visible = false;
        }

        // ── Masquer les menus hors-périmètre PFE (Catalogues, Ventes, Documents…) ─
        modify(Catalogues)
        {
            Visible = false;
        }
        modify(sales)
        {
            Visible = false;
        }
        modify("DLT ServiceDocument")
        {
            Visible = false;
        }
        modify("Posted Documents")
        {
            Visible = false;
        }
        modify("DLT ServiceOrder")
        {
            Visible = false;
        }
        modify("<Action60>")
        {
            Visible = false;
        }

        addlast(Sections)
        {
            group(ReclamationsPFE)
            {
                Caption = 'Réclamations PFE';
                action(ListeReclamationsPFE)
                {
                    ApplicationArea = All;
                    Caption = 'Réclamations PFE';
                    RunObject = page "Reclamation List PFE";
                }
                action(RolesReclamationPFE)
                {
                    ApplicationArea = All;
                    Caption = 'Rôles utilisateurs Réclamation';
                    RunObject = page "Rec Role Setup List";
                }
                action(TableauBordPowerBI)
                {
                    ApplicationArea = All;
                    Caption = 'Tableau de bord Power BI';
                    Image = ElectronicDoc;
                    ToolTip = 'Ouvre le tableau de bord Power BI des réclamations dans un nouvel onglet.';
                    RunObject = codeunit "Rec Open PowerBI Dashboard";
                }
            }
        }
    }
}