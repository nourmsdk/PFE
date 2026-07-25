page 65033 "Rec Cue Part SAV"
{
    Caption = 'Réclamations à traiter';
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

                field("A Qualifier"; Rec."A Qualifier")
                {
                    ApplicationArea = All;
                    Caption = 'À qualifier';
                    DrillDownPageId = "Reclamation List PFE";
                    ToolTip = 'Réclamations en attente de qualification (Gravité, Priorité, Catégorie).';
                }
                field("En Investigation"; Rec."En Investigation")
                {
                    ApplicationArea = All;
                    Caption = 'En cours (affectation/investigation/action corrective)';
                    DrillDownPageId = "Reclamation List PFE";
                    ToolTip = 'Réclamations affectées, en investigation ou en action corrective.';
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
        Rec.CalcFields("A Qualifier", "En Investigation");
    end;
}
