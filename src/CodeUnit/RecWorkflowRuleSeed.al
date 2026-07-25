codeunit 65003 "Rec Workflow Rule Seed"
{
    procedure SeedDefaultRules()
    var
        Rule: Record "Rec Workflow Rule";
    begin
        if not Rule.Get('ALERTE75') then begin
            Rule.Init();
            Rule."Code" := 'ALERTE75';
            Rule.Description := 'Alerte automatique à 75% du délai SLA';
            Rule.Actif := true;
            Rule."Ordre Evaluation" := 10;
            Rule."Condition Delai Pct Min" := 75;
            Rule."Action Notification" := Rule."Action Notification"::Alerte75pct;
            Rule."Une Seule Fois" := true;
            Rule.Insert(true);
        end;

        if not Rule.Get('ESCALADE') then begin
            Rule.Init();
            Rule."Code" := 'ESCALADE';
            Rule.Description := 'Escalade Responsable Qualité si Gravité Critique';
            Rule.Actif := true;
            Rule."Ordre Evaluation" := 20;
            Rule."Condition Gravite" := Rule."Condition Gravite"::Critique;
            Rule."Action Notification" := Rule."Action Notification"::"Escalade Manager";
            Rule."Action Notifier Role" := Rule."Action Notifier Role"::ResponsableQualite;
            Rule."Une Seule Fois" := true;
            Rule.Insert(true);
        end;
    end;
}
