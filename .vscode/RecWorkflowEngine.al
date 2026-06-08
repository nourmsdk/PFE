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
                if not RuleDejaAppliquee(Rec."No_", Rule."Code") then
                    if ConditionsRemplies(Rec, Rule, DelaiPct) then begin
                        ExecuterActions(Rec, Rule);
                        AnyChange := true;
                        MarquerRuleAppliquee(Rec."No_", Rule."Code");
                        Rule."Nb Executions" += 1;
                        Rule.Modify(false);
                    end;
            end else
                if ConditionsRemplies(Rec, Rule, DelaiPct) then begin
                    ExecuterActions(Rec, Rule);
                    AnyChange := true;
                    Rule."Nb Executions" += 1;
                    Rule.Modify(false);
                end;
        until Rule.Next() = 0;

        if AnyChange then begin
            Rec.CalculerDelaiTraitement();
            Rec.Modify(false);
        end;
    end;

    // ─────────────────────────────────────────────────────────────────────────
    // Vérifie si toutes les conditions de la règle sont remplies
    // ─────────────────────────────────────────────────────────────────────────
    local procedure ConditionsRemplies(
        Rec: Record Reclamation;
        Rule: Record "Rec Workflow Rule";
        DelaiPct: Integer): Boolean
    begin
        // Comparaisons via l'option " " (vide = pas de condition)
        if Rule."Condition Statut" <> Rule."Condition Statut"::" " then
            if Rec.Statut <> Rule."Condition Statut" then
                exit(false);

        if Rule."Condition Etape" <> Rule."Condition Etape"::" " then
            if Rec."Etape Workflow" <> Rule."Condition Etape" then
                exit(false);

        if Rule."Condition Gravite" <> Rule."Condition Gravite"::" " then
            if Rec.Gravite <> Rule."Condition Gravite" then
                exit(false);

        if Rule."Condition Priorite" <> Rule."Condition Priorite"::" " then
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

    // ─────────────────────────────────────────────────────────────────────────
    // Exécute les actions définies dans la règle
    // ─────────────────────────────────────────────────────────────────────────
    local procedure ExecuterActions(var Rec: Record Reclamation; Rule: Record "Rec Workflow Rule")
    var
        OldEtape: Enum "Etape Workflow Reclamation";
        OldStatut: Enum "Statut Reclamation";
        HistLine: Record "Rec Workflow History";
        NotifLog: Record "Rec Notification Log";
        MsgNotif: Text[500];
        ChangementDetecte: Boolean;
    begin
        OldEtape := Rec."Etape Workflow";
        OldStatut := Rec.Statut;
        ChangementDetecte := false;

        // ── Changement d'étape ──────────────────────────────────────────────
        if Rule."Action Etape" <> Rule."Action Etape"::" " then
            if Rec."Etape Workflow" <> Rule."Action Etape" then begin
                Rec."Etape Workflow" := Rule."Action Etape";
                ChangementDetecte := true;
            end;

        // ── Changement de statut ────────────────────────────────────────────
        if Rule."Action Statut" <> Rule."Action Statut"::" " then
            if Rec.Statut <> Rule."Action Statut" then begin
                Rec.Statut := Rule."Action Statut";
                case Rec.Statut of
                    Rec.Statut::"PriseEnCharge":
                        if Rec."Date Prise En Charge" = 0D then
                            Rec."Date Prise En Charge" := Today();
                    Rec.Statut::"EnCours":
                        if Rec."Date Mise En Cours" = 0D then
                            Rec."Date Mise En Cours" := Today();
                end;
                ChangementDetecte := true;
            end;

        // ── Changement de priorité ──────────────────────────────────────────
        if Rule."Action Priorite" <> Rule."Action Priorite"::" " then
            if Rec.Priorite <> Rule."Action Priorite" then begin
                Rec.Priorite := Rule."Action Priorite";
                ChangementDetecte := true;
            end;

        // ── Attribution à un utilisateur ────────────────────────────────────
        if Rule."Action Attribuer A" <> '' then
            if Rec."Attribue A" <> Rule."Action Attribuer A" then begin
                Rec."Attribue A" := Rule."Action Attribuer A";
                ChangementDetecte := true;
            end;

        // ── Forcer hors délai ───────────────────────────────────────────────
        if Rule."Action Forcer Hors Delai" then
            if not Rec."Hors Delai" then begin
                Rec."Hors Delai" := true;
                ChangementDetecte := true;
            end;

        // ── Historique workflow ─────────────────────────────────────────────
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
                StrSubstNo('Règle auto : %1 — %2', Rule."Code", Rule.Description), 1, 250);
            HistLine.Insert(true);
        end;

        // ── Notification ────────────────────────────────────────────────────
        if Rule."Action Notification" <> Rule."Action Notification"::" " then begin
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

            if Rule."Action Notification" = Rule."Action Notification"::"Hors SLA" then
                Rec."Notification Envoyee" := true;
        end;
    end;

    // ─────────────────────────────────────────────────────────────────────────
    // Construit le message de notification par défaut selon le type
    // ─────────────────────────────────────────────────────────────────────────
    local procedure BuildDefaultMessage(
        Rec: Record Reclamation;
        TypeNotif: Option): Text[500]
    var
        NotifLog: Record "Rec Notification Log";
    begin
        case TypeNotif of
            NotifLog."Type Notification"::"Hors SLA":
                exit(CopyStr(StrSubstNo(
                    'ALERTE SLA : Réclamation %1 dépasse le SLA (%2 jours écoulés). Client : %3. Agence : %4.',
                    Rec."No_", Rec."Delai En Cours", Rec."Nom Client", Rec.Agence), 1, 500));

            NotifLog."Type Notification"::Alerte75pct:
                exit(CopyStr(StrSubstNo(
                    'Attention : Réclamation %1 a atteint 75%% du SLA (%2 jours écoulés). Client : %3.',
                    Rec."No_", Rec."Delai En Cours", Rec."Nom Client"), 1, 500));

            NotifLog."Type Notification"::"Escalade Manager":
                exit(CopyStr(StrSubstNo(
                    'ESCALADE : Réclamation %1 (Gravité : %2) nécessite intervention manager. Client : %3.',
                    Rec."No_", Format(Rec.Gravite), Rec."Nom Client"), 1, 500));

            NotifLog."Type Notification"::"Relance Client":
                exit(CopyStr(StrSubstNo(
                    'Relance client pour réclamation %1 en attente depuis %2 jours. Contact : %3.',
                    Rec."No_", Rec."Delai En Cours", Rec."No. Telephone"), 1, 500));

            else
                exit(CopyStr(StrSubstNo(
                    'Notification automatique — Réclamation %1 / Client : %2.',
                    Rec."No_", Rec."Nom Client"), 1, 500));
        end;
    end;

    // ─────────────────────────────────────────────────────────────────────────
    // Vérifie si une règle a déjà été appliquée à cette réclamation
    // ─────────────────────────────────────────────────────────────────────────
    local procedure RuleDejaAppliquee(NoRec: Code[20]; RuleCode: Code[20]): Boolean
    var
        Applied: Record "Rec Workflow Rule Applied";
    begin
        exit(Applied.Get(NoRec, RuleCode));
    end;

    // ─────────────────────────────────────────────────────────────────────────
    // Enregistre qu'une règle "Une seule fois" a été appliquée
    // ─────────────────────────────────────────────────────────────────────────
    local procedure MarquerRuleAppliquee(NoRec: Code[20]; RuleCode: Code[20])
    var
        Applied: Record "Rec Workflow Rule Applied";
    begin
        if Applied.Get(NoRec, RuleCode) then exit;

        Applied.Init();
        Applied."No. Reclamation" := NoRec;
        Applied."Rule Code" := RuleCode;
        Applied."Date Heure" := CurrentDateTime();
        Applied.Insert(true);
    end;

    // ─────────────────────────────────────────────────────────────────────────
    // Évaluation manuelle depuis la fiche réclamation
    // Retourne un résumé des actions effectuées
    // ─────────────────────────────────────────────────────────────────────────
    procedure EvaluerManuellement(var Rec: Record Reclamation)
    var
        NotifLog: Record "Rec Notification Log";
        HistLine: Record "Rec Workflow History";
        NotifBefore: Integer;
        HistBefore: Integer;
    begin
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

        Message(
            'Évaluation terminée.\\Nouvelles notifications : %1\\Nouvelles transitions workflow : %2',
            NotifLog.Count() - NotifBefore,
            HistLine.Count() - HistBefore);
    end;
}

// =============================================================================
// Table : Règles workflow appliquées (traçabilité des règles "Une seule fois")
// =============================================================================
table 65009 "Rec Workflow Rule Applied"
{
    Caption = 'Règles Workflow Appliquées';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No. Reclamation"; Code[20])
        {
            Caption = 'N° Réclamation';
            DataClassification = CustomerContent;
            TableRelation = Reclamation."No_";
            NotBlank = true;
        }
        field(2; "Rule Code"; Code[20])
        {
            Caption = 'Code Règle';
            DataClassification = CustomerContent;
            TableRelation = "Rec Workflow Rule"."Code";
            NotBlank = true;
        }
        field(3; "Date Heure"; DateTime)
        {
            Caption = 'Date / Heure Exécution';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No. Reclamation", "Rule Code") { Clustered = true; }
        key(K2; "Rule Code") { }
    }
}

// =============================================================================
// Page : Liste des règles appliquées (outil admin / debug)
// =============================================================================
page 65015 "Rec Workflow Rule Applied List"
{
    PageType = List;
    SourceTable = "Rec Workflow Rule Applied";
    Caption = 'Règles Workflow Appliquées';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTableView = sorting("No. Reclamation", "Rule Code");
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("No. Reclamation"; Rec."No. Reclamation")
                {
                    ApplicationArea = All;
                    Caption = 'N° Réclamation';
                }
                field("Rule Code"; Rec."Rule Code")
                {
                    ApplicationArea = All;
                    Caption = 'Code Règle';
                }
                field("Date Heure"; Rec."Date Heure")
                {
                    ApplicationArea = All;
                    Caption = 'Date / Heure';
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
                Caption = 'Supprimer cette ligne';
                ToolTip = 'Permet de réappliquer cette règle sur cette réclamation.';
                Image = Delete;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Supprimer cette entrée ? La règle pourra être réappliquée à cette réclamation.', false) then
                        Rec.Delete(true);
                end;
            }
            action(ResetTout)
            {
                Caption = 'Réinitialiser tout';
                ToolTip = 'Supprime toutes les entrées pour permettre de retester toutes les règles.';
                Image = DeleteAllBreakpoints;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Supprimer TOUTES les entrées ? Toutes les règles "Une seule fois" seront réapplicables.', false) then
                        Rec.DeleteAll(true);
                end;
            }
        }
    }
}
