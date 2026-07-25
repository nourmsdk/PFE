page 65032 "Rec RC Responsable Qualite"
{
    PageType = RoleCenter;
    Caption = 'Responsable Qualité';

    layout
    {
        area(RoleCenter)
        {
            part(CuePart; "Rec Cue Part Qualite")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(ControleQualiteGroup)
            {
                Caption = 'Contrôle qualité';

                action(ActionsCorrectivesMgr)
                {
                    ApplicationArea = All;
                    Caption = 'Actions correctives — Vue managériale';
                    Image = Approvals;
                    RunObject = page "Rec Action Corrective Mgr";
                }
                action(ListeReclamations)
                {
                    ApplicationArea = All;
                    Caption = 'Liste des réclamations';
                    Image = List;
                    RunObject = page "Reclamation List PFE";
                }
            }
        }
    }
}
