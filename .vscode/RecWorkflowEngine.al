codeunit 65000 "Rec Workflow Engine"
{
    procedure EvaluerReclamation(var Rec: Record Reclamation)
    var
        Rule: Record "Rec Workflow Rule";
        RecParam: Record "Rec Parametres";
        SLAJours: Integer;
        DelaiPct: Integer;
        AnyChange: Boolean;
    begin
        if Rec.Cloturee then exit;

        SLAJours := 7;
        if RecParam.Get('DEFAULT') then
            if RecParam."SLA Jours" > 0 then
                SLAJours := RecParam."SLA Jours";

        if SLAJours > 0 then
            DelaiPct := Round((Rec."Delai En Cours" / SLAJours) * 100, 1)
        else
            DelaiPct := 0;

        Rule.Reset();
        Rule.SetRange(Actif, true);
        Rule.SetCurrentKey(Actif, "Ordre Evaluation");
        if not Rule.FindSet() then exit;

        AnyChange := false;

        repeat
            if Rule."Une Seule Fois" then begin
                if not RuleDejaAppliquee(Rec."No_", Rule."Code") then begin
                    if ConditionsRemplies(Rec, Rule, DelaiPct) then begin
                        ExecuterActions(Rec, Rule);
                        AnyChange := true;
                        MarquerRuleAppliquee(Rec."No_", Rule."Code");
                        Rule."Nb Executions" += 1;
                        Rule.Modify(false);
                    end;
                end;
            end else begin
                if ConditionsRemplies(Rec, Rule, DelaiPct) then begin
                    ExecuterActions(Rec, Rule);
                    AnyChange := true;
                    Rule."Nb Executions" += 1;
                    Rule.Modify(false);
                end;
            end;
        until Rule.Next() = 0;

        if AnyChange then begin
            Rec.CalculerDelaiTraitement();
            Rec.Modify(false);
        end;
    end;

    local procedure ConditionsRemplies(
        Rec: Record Reclamation;
        Rule: Record "Rec Workflow Rule";
        DelaiPct: Integer): Boolean
    begin
        if Rule."Condition Statut" <> 0 then
            if Rec.Statut <> Rule."Condition Statut" then
                exit(false);

        if Rule."Condition Etape" <> 0 then
            if Rec."Etape Workflow" <> Rule."Condition Etape" then
                exit(false);

        if Rule."Condition Gravite" <> 0 then
            if Rec.Gravite <> Rule."Condition Gravite" then
                exit(false);

        if Rule."Condition Priorite" <> 0 then
            if Rec.Priorite <> Rule."Condition Priorite" then
                exit(false);

        if Rule."Condition Delai Pct Min" > 0 then
            if DelaiPct < Rule."Condition Delai Pct Min" then
                exit(false);

        if Rule."Condition Agence" <> '' then
            if Rec.Agence <> Rule."Condition Agence" then
                exit(false);

        if Rule."Condition Categorie" <> '' then
            if Rec."Code Categorie" <> Rule."Condition Categorie" then
                exit(false);

        exit(true);
    end;

    local procedure ExecuterActions(var Rec: Record Reclamation; Rule: Record "Rec Workflow Rule")
    var
        OldEtape: Option;
        OldStatut: Option;
        HistLine: Record "Rec Workflow History";
        NotifLog: Record "Rec Notification Log";
        MsgNotif: Text[500];
        ChangementDetecte: Boolean;
    begin
        OldEtape := Rec."Etape Workflow";
        OldStatut := Rec.Statut;
        ChangementDetecte := false;

        if Rule."Action Etape" <> 0 then
            if Rec."Etape Workflow" <> Rule."Action Etape" then begin
                Rec."Etape Workflow" := Rule."Action Etape";
                ChangementDetecte := true;
            end;

        if Rule."Action Statut" <> 0 then
            if Rec.Statut <> Rule."Action Statut" then begin
                Rec.Statut := Rule."Action Statut";
                case Rec.Statut of
                    Rec.Statut::"Prise en charge":
                        if Rec."Date Prise En Charge" = 0D then
                            Rec."Date Prise En Charge" := Today();
                    Rec.Statut::"En cours":
                        if Rec."Date Mise En Cours" = 0D then
                            Rec."Date Mise En Cours" := Today();
                end;
                ChangementDetecte := true;
            end;

        if Rule."Action Priorite" <> 0 then
            if Rec.Priorite <> Rule."Action Priorite" then begin
                Rec.Priorite := Rule."Action Priorite";
                ChangementDetecte := true;
            end;

        if Rule."Action Attribuer A" <> '' then
            if Rec."Attribue A" <> Rule."Action Attribuer A" then begin
                Rec."Attribue A" := Rule."Action Attribuer A";
                ChangementDetecte := true;
            end;

        if Rule."Action Forcer Hors Delai" then
            if not Rec."Hors Delai" then begin
                Rec."Hors Delai" := true;
                ChangementDetecte := true;
            end;

        if ChangementDetecte then begin
            HistLine.Init();
            HistLine."No. Reclamation" := Rec."No_";
            HistLine."Date Heure" := CurrentDateTime();
            HistLine."Etape Precedente" := OldEtape;
            HistLine."Etape Suivante" := Rec."Etape Workflow";
            HistLine."Statut Precedent" := OldStatut;
            HistLine."Statut Suivant" := Rec.Statut;
            HistLine."User ID" := 'SYSTEM';
            HistLine.Commentaire := CopyStr(
                StrSubstNo('Regle auto : %1 - %2', Rule."Code", Rule.Description), 1, 250);
            HistLine.Insert(true);
        end;

        if Rule."Action Notification" <> 0 then begin
            if Rule."Action Message" <> '' then
                MsgNotif := CopyStr(StrSubstNo(
                    Rule."Action Message",
                    Rec."No_",
                    Rec."Nom Client",
                    Rec."Delai En Cours",
                    Rec.Agence), 1, 500)
            else
                MsgNotif := BuildDefaultMessage(Rec, Rule."Action Notification");

            NotifLog.Init();
            NotifLog."No. Reclamation" := Rec."No_";
            NotifLog."Date Heure" := CurrentDateTime();
            NotifLog."Type Notification" := Rule."Action Notification";
            NotifLog.Message := MsgNotif;
            NotifLog.Destinataire := Rec."Attribue A";
            NotifLog."No. Client" := Rec."No. Client";
            NotifLog.Processed := false;
            NotifLog.Insert(true);
            ChangementDetecte := true;
            if Rule."Action Notification" = 1 then
                Rec."Notification Envoyee" := true;
        end;
    end;

    local procedure BuildDefaultMessage(
        Rec: Record Reclamation;
        TypeNotif: Integer): Text[500]
    begin
        case TypeNotif of
            1:
                exit(CopyStr(StrSubstNo(
                    'ALERTE : Reclamation %1 depasse le SLA (%2 jours). Client : %3. Agence : %4.',
                    Rec."No_", Rec."Delai En Cours", Rec."Nom Client", Rec.Agence), 1, 500));
            2:
                exit(CopyStr(StrSubstNo(
                    'Attention : Reclamation %1 a atteint 75pct du SLA (%2 jours ecoules). Client : %3.',
                    Rec."No_", Rec."Delai En Cours", Rec."Nom Client"), 1, 500));
            3:
                exit(CopyStr(StrSubstNo(
                    'ESCALADE : Reclamation %1 (Gravite : %2) necessite intervention manager. Client : %3.',
                    Rec."No_", Format(Rec.Gravite), Rec."Nom Client"), 1, 500));
            7:
                exit(CopyStr(StrSubstNo(
                    'Relance client pour reclamation %1 en attente depuis %2 jours. Contact : %3.',
                    Rec."No_", Rec."Delai En Cours", Rec."No. Telephone"), 1, 500));
            else
                exit(CopyStr(StrSubstNo(
                    'Notification automatique - Reclamation %1 / Client : %2.',
                    Rec."No_", Rec."Nom Client"), 1, 500));
        end;
    end;

    local procedure RuleDejaAppliquee(NoRec: Code[20]; RuleCode: Code[20]): Boolean
    var
        Applied: Record "Rec Workflow Rule Applied";
    begin
        exit(Applied.Get(NoRec, RuleCode));
    end;

    local procedure MarquerRuleAppliquee(NoRec: Code[20]; RuleCode: Code[20])
    var
        Applied: Record "Rec Workflow Rule Applied";
    begin
        Message('MarquerRuleAppliquee appelée : %1 / %2', NoRec, RuleCode); // ← debug
        if Applied.Get(NoRec, RuleCode) then begin
            Message('Applied existe deja pour %1 / %2', NoRec, RuleCode); // ← debug
            exit;
        end;
        Applied.Init();
        Applied."No. Reclamation" := NoRec;
        Applied."Rule Code" := RuleCode;
        Applied."Date Heure" := CurrentDateTime();
        if not Applied.Insert(true) then
            Message('ERREUR Insert Applied : Rec=%1 Rule=%2', NoRec, RuleCode)
        else
            Message('Insert Applied REUSSI : %1 / %2', NoRec, RuleCode); // ← debug
    end;

    procedure EvaluerManuellement(var Rec: Record Reclamation)
    var
        NotifLog: Record "Rec Notification Log";
        HistLine: Record "Rec Workflow History";
        Applied: Record "Rec Workflow Rule Applied";
        NotifBefore: Integer;
        HistBefore: Integer;
    begin
        // Debug — affiche ce qui est dans Applied pour cette réclamation
        Applied.SetRange("No. Reclamation", Rec."No_");
        if Applied.FindSet() then
            repeat
                Message('Applied existe : Rec=[%1] Rule=[%2]',
                    Applied."No. Reclamation",
                    Applied."Rule Code");
            until Applied.Next() = 0
        else
            Message('Aucune Applied trouvee pour [%1]', Rec."No_");


        NotifLog.SetRange("No. Reclamation", Rec."No_");
        NotifBefore := NotifLog.Count();
        HistLine.SetRange("No. Reclamation", Rec."No_");
        HistBefore := HistLine.Count();

        Rec.CalculerDelaiTraitement();
        EvaluerReclamation(Rec);

        NotifLog.Reset();
        NotifLog.SetRange("No. Reclamation", Rec."No_");
        HistLine.Reset();
        HistLine.SetRange("No. Reclamation", Rec."No_");

        Message('Evaluation terminee.\Nouvelles notifications : %1\Nouvelles transitions : %2',
            NotifLog.Count() - NotifBefore,
            HistLine.Count() - HistBefore);
    end;
}

table 65009 "Rec Workflow Rule Applied"
{
    Caption = 'Regles workflow appliquees';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No. Reclamation"; Code[20])
        {
            Caption = 'No. Reclamation';
            DataClassification = CustomerContent;
            TableRelation = Reclamation."No_";
            NotBlank = true;
        }
        field(2; "Rule Code"; Code[20])
        {
            Caption = 'Code Regle';
            DataClassification = CustomerContent;
            TableRelation = "Rec Workflow Rule"."Code";
            NotBlank = true;
        }
        field(3; "Date Heure"; DateTime)
        {
            Caption = 'Date Heure execution';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No. Reclamation", "Rule Code") { Clustered = true; }
    }
}

page 65015 "Rec Workflow Rule Applied List"
{
    PageType = List;
    SourceTable = "Rec Workflow Rule Applied";
    Caption = 'Regles Workflow Appliquees';
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("No. Reclamation"; Rec."No. Reclamation")
                {
                    ApplicationArea = All;
                }
                field("Rule Code"; Rec."Rule Code")
                {
                    ApplicationArea = All;
                }
                field("Date Heure"; Rec."Date Heure")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SupprimerLigne)
            {
                Caption = 'Supprimer ligne';
                Image = Delete;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Supprimer cette ligne Applied ?') then
                        Rec.Delete(true);
                end;
            }
            action(ResetTout)
            {
                Caption = 'Reset toutes les lignes';
                Image = DeleteAllBreakpoints;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    if Confirm('Supprimer TOUTES les lignes Applied ? (permet de retester toutes les regles)') then
                        Rec.DeleteAll(true);
                end;
            }
        }
    }
}
