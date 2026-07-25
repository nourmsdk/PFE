codeunit 65010 "Rec Migration Texte"
{
    trigger OnRun()
    var
        Reclamation: Record Reclamation;
    begin
        if Reclamation.FindSet(true) then
            repeat
                Reclamation."Canal Texte" := Format(Reclamation.Canal);
                Reclamation."Type Reclamation Texte" := Format(Reclamation."Type Reclamation");
                Reclamation."Responsabilite Texte" := Format(Reclamation.Responsabilite);
                Reclamation."Retour Client Texte" := Format(Reclamation."Retour Client");
                Reclamation."Gravite Texte" := Format(Reclamation.Gravite);
                Reclamation."Priorite Texte" := Format(Reclamation.Priorite);
                Reclamation."Statut Texte" := Format(Reclamation.Statut);
                Reclamation."Etape Workflow Texte" := Format(Reclamation."Etape Workflow");
                Reclamation.Modify(false);
            until Reclamation.Next() = 0;
        Message('Migration terminée.');
    end;
}