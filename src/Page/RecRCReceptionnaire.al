page 65030 "Rec RC Receptionnaire"
{
    PageType = RoleCenter;
    Caption = 'Réceptionnaire SAV';

    layout
    {
        area(RoleCenter)
        {
            group(Activites)
            {
                Caption = ' ';
                ShowCaption = false;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(NouvelleReclamation)
            {
                ApplicationArea = All;
                Caption = 'Nouvelle réclamation';
                Image = New;
                RunObject = page "Reclamation Card PFE";
                RunPageMode = Create;
                ToolTip = 'Ouvrir une fiche pour saisir une nouvelle réclamation client.';
            }
        }
    }
}
