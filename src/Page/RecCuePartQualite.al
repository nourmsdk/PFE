page 65034 "Rec Cue Part Qualite"
{
    Caption = 'Contrôle qualité';
    PageType = CardPart;
    SourceTable = "Reclamation Cue";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            cuegroup(Reclamations)
            {
                Caption = 'Réclamations';

                field("En Attente Validation"; Rec."En Attente Validation")
                {
                    ApplicationArea = All;
                    Caption = 'En attente de validation';
                    DrillDownPageId = "Reclamation List PFE";
                    ToolTip = 'Réclamations à l''étape Validation : à approuver (clôture) ou rejeter (retour investigation).';
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
        Rec.CalcFields("En Attente Validation");
    end;
}
