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
    // ─────────────────────────────────────────────────────────────────────────
    // Valide qu'une transition d'étape workflow est légale
    // Lève une erreur bloquante si la transition est interdite
    // ─────────────────────────────────────────────────────────────────────────
    procedure ValiderTransition(EtapeActuelle: Enum "Etape Workflow Reclamation"; NouvelleEtape: Enum "Etape Workflow Reclamation")
    var
        OK: Boolean;
    begin
        OK := false;

        case EtapeActuelle of
            "Etape Workflow Reclamation"::Ouverture:
                OK := (NouvelleEtape = "Etape Workflow Reclamation"::Qualification);

            "Etape Workflow Reclamation"::Qualification:
                OK := (NouvelleEtape = "Etape Workflow Reclamation"::Affectation);

            "Etape Workflow Reclamation"::Affectation:
                OK := (NouvelleEtape = "Etape Workflow Reclamation"::Investigation);

            "Etape Workflow Reclamation"::Investigation:
                OK := (NouvelleEtape = "Etape Workflow Reclamation"::ActionCorrective);

            "Etape Workflow Reclamation"::ActionCorrective:
                OK := (NouvelleEtape = "Etape Workflow Reclamation"::Validation);

            "Etape Workflow Reclamation"::Validation:
                // Approbation → Clôture  OU  Rejet → Investigation (flèche rouge)
                OK := (NouvelleEtape = "Etape Workflow Reclamation"::Cloture) or
                      (NouvelleEtape = "Etape Workflow Reclamation"::Investigation);

            "Etape Workflow Reclamation"::Cloture:
                OK := false; // état terminal, aucune transition possible
        end;

        if not OK then
            Error(
                'Transition interdite : "%1" → "%2".\Transitions autorisées :\' +
                '  Ouverture → Qualification\' +
                '  Qualification → Affectation\' +
                '  Affectation → Investigation\' +
                '  Investigation → Action corrective\' +
                '  Action corrective → Validation\' +
                '  Validation → Clôture  (approbation)\' +
                '  Validation → Investigation  (rejet)',
                EtapeActuelle, NouvelleEtape);
    end;

    // ─────────────────────────────────────────────────────────────────────────
    // Point d'entrée unique pour toute transition manuelle depuis la card page
    // Utilise "Modif Par Moteur" = true pour éviter le doublon d'historique
    // que OnModify() créerait sinon
    // ─────────────────────────────────────────────────────────────────────────
    procedure PasserEtapeSuivante(var Rec: Record Reclamation; NouvelleEtape: Enum "Etape Workflow Reclamation"; Commentaire: Text[250])
    var
        HistLine: Record "Rec Workflow History";
        OldEtape: Enum "Etape Workflow Reclamation";
        OldStatut: Enum "Statut Reclamation";
    begin
        // ── Garde : bloque si transition illégale ────────────────────────────
        ValiderTransition(Rec."Etape Workflow", NouvelleEtape);

        OldEtape := Rec."Etape Workflow";
        OldStatut := Rec.Statut;

        // ── Flag pour neutraliser OnModify (évite doublon historique) ────────
        Rec."Modif Par Moteur" := true;

        // ── Changement d'étape ───────────────────────────────────────────────
        Rec."Etape Workflow" := NouvelleEtape;

        // ── Mise à jour automatique du Statut selon l'étape ──────────────────
        case NouvelleEtape of
            "Etape Workflow Reclamation"::Qualification,
            "Etape Workflow Reclamation"::Affectation:
                Rec.Statut := "Statut Reclamation"::PriseEnCharge;

            "Etape Workflow Reclamation"::Investigation,
            "Etape Workflow Reclamation"::ActionCorrective,
            "Etape Workflow Reclamation"::Validation:
                Rec.Statut := "Statut Reclamation"::EnCours;

            "Etape Workflow Reclamation"::Cloture:
                begin
                    Rec.Statut := "Statut Reclamation"::Cloturee;
                    Rec.Cloturee := true;
                    if Rec."Date Cloture" = 0D then
                        Rec."Date Cloture" := Today();
                end;
        end;

        // ── Date prise en charge à la première sortie d'Ouverture ────────────
        if (OldEtape = "Etape Workflow Reclamation"::Ouverture) then
            if Rec."Date Prise En Charge" = 0D then
                Rec."Date Prise En Charge" := Today();

        // ── Historique workflow (on l'écrit nous-mêmes, OnModify ne le fera pas)
        HistLine.Init();
        HistLine."No. Reclamation" := Rec."No_";
        HistLine."Date Heure" := CurrentDateTime();
        HistLine."Etape Precedente" := OldEtape;
        HistLine."Etape Suivante" := NouvelleEtape;
        HistLine."Statut Precedent" := OldStatut;
        HistLine."Statut Suivant" := Rec.Statut;
        HistLine."User ID" := UserId();
        HistLine.Commentaire := CopyStr(
            StrSubstNo('Manuel : %1 → %2. %3', OldEtape, NouvelleEtape, Commentaire), 1, 250);
        HistLine.Insert(false);

        // ── Sauvegarde (OnModify voit Modif Par Moteur = true → skip historique)
        Rec.Modify(true);

        // ── Remettre le flag à false après sauvegarde ────────────────────────
        Rec."Modif Par Moteur" := false;
        Rec.Modify(false);
    end;
    // ─────────────────────────────────────────────────────────────────────────
    // VerifierConditionsCloture — aligné avec diagramme de séquence
    // Retourne true si clôture possible, false si warning accepté,
    // lève Error() si bloquant strict
    // ─────────────────────────────────────────────────────────────────────────
    procedure VerifierConditionsCloture(var Rec: Record Reclamation): Boolean
    var
        ActionCorr: Record "Rec Action Corrective";
        NbOuvertes: Integer;
        NbPlanifiees: Integer;
        NbEnCours: Integer;
    begin
        // ── Vérifications bloquantes strictes ────────────────────────────────
        if Rec."No. Client" = '' then
            Error('Impossible de clôturer : aucun client associé.');

        if Rec."Code Categorie" = '' then
            Error('Impossible de clôturer : Code Catégorie obligatoire.');

        if Rec."Description Action Prise" = '' then
            Error('Impossible de clôturer : Description Action Prise obligatoire.');

        if Rec."Etape Workflow" <> "Etape Workflow Reclamation"::Validation then
            Error('Impossible de clôturer : la réclamation doit être à l''étape Validation (étape actuelle : %1).',
                Rec."Etape Workflow");

        // ── Compter actions par statut ────────────────────────────────────────
        ActionCorr.Reset();
        ActionCorr.SetRange("No Reclamation", Rec."No_");

        ActionCorr.SetRange(Statut, "Statut Action Corrective"::Planifiee);
        NbPlanifiees := ActionCorr.Count();

        ActionCorr.SetRange(Statut, "Statut Action Corrective"::EnCours);
        NbEnCours := ActionCorr.Count();

        NbOuvertes := NbPlanifiees + NbEnCours;

        // ── Warning avec Confirm() si actions Planifiée ou EnCours ───────────
        if NbOuvertes > 0 then begin
            if not Confirm(
                'ATTENTION : %1 action(s) corrective(s) encore active(s) :\' +
                '  - Planifiées : %2\' +
                '  - En cours   : %3\\' +
                'Clôturer quand même ?',
                false,
                NbOuvertes, NbPlanifiees, NbEnCours)
            then
                exit(false); // utilisateur a annulé
        end;

        exit(true); // tout OK, clôture autorisée
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
