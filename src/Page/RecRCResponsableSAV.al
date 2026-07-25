page 65031 "Rec RC Responsable SAV"
{
    PageType = RoleCenter;
    Caption = 'Responsable SAV';

    layout
    {
        area(RoleCenter)
        {
            part(CuePart; "Rec Cue Part SAV")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(ReclamationsGroup)
            {
                Caption = 'Réclamations';

                action(ListeReclamations)
                {
                    ApplicationArea = All;
                    Caption = 'Liste des réclamations';
                    Image = List;
                    RunObject = page "Reclamation List PFE";
                }
                action(ReglesWorkflow)
                {
                    ApplicationArea = All;
                    Caption = 'Règles workflow';
                    Image = Setup;
                    RunObject = page "Rec Workflow Rule List";
                }
            }
        }
        area(Creation)
        {
            action(NouvelleReclamation)
            {
                ApplicationArea = All;
                Caption = 'Nouvelle réclamation';
                Image = New;
                RunObject = page "Reclamation Card PFE";
                RunPageMode = Create;
            }
        }
    }
}
