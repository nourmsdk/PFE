pageextension 65002 "DLT RoleCenter Ext PFE" extends "DLT Complaint RoleCenter"
{
    actions
    {
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
            }
        }
    }
}