page 65060 "Reclamation Cue Part"
{
    Caption = 'Réclamation';
    PageType = CardPart;
    SourceTable = "Reclamation Cue";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            cuegroup(General)
            {
                Caption = 'General';

                field("Total Reclamations"; Rec."Total Reclamations")
                {
                    ApplicationArea = All;
                    Caption = 'Total Réclamations';
                    DrillDownPageId = "Reclamation List PFE"; // ta page liste
                    ToolTip = 'Nombre total de réclamations';
                }
                field("Reclamations Ouvertes"; Rec."Reclamations Ouvertes")
                {
                    ApplicationArea = All;
                    Caption = 'Réclamation ouvert';
                    DrillDownPageId = "Reclamation List PFE";
                    ToolTip = 'Réclamations avec statut Ouvert';
                }
                field("Reclamations Prise En Charge"; Rec."Reclamations Prise En Charge")
                {
                    ApplicationArea = All;
                    Caption = 'Réclamation prise en charge';
                    DrillDownPageId = "Reclamation List PFE";
                    ToolTip = 'Réclamations en cours de traitement';
                }
                field("Reclamations Fermees"; Rec."Reclamations Fermees")
                {
                    ApplicationArea = All;
                    Caption = 'Réclamation fermée';
                    DrillDownPageId = "Reclamation List PFE";
                    ToolTip = 'Réclamations clôturées';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        ReclamationCue: Record "Reclamation Cue";
    begin
        if not ReclamationCue.Get() then begin
            ReclamationCue.Init();
            ReclamationCue.Insert();
        end;
        Rec := ReclamationCue;
        Rec.CalcFields(
            "Total Reclamations",
            "Reclamations Ouvertes",
            "Reclamations Prise En Charge",
            "Reclamations Fermees"
        );
    end;
}