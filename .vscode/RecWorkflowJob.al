// ============================================================
//  CODEUNIT 65001 — Rec Workflow Job
//
//  C'est le DÉCLENCHEUR AUTOMATIQUE du système.
//  Il est enregistré comme Job Queue Entry dans Business Central
//  et tourne à intervalles réguliers (ex: toutes les 2 heures)
//  SANS intervention humaine.
//
//  Ce qu'il fait à chaque exécution :
//    1. Récupère toutes les réclamations actives (non clôturées)
//    2. Met à jour le délai de chaque réclamation
//    3. Appelle le moteur (Rec Workflow Engine) pour chacune
//    4. Journalise le résultat dans Rec Job Log
//
//  CONFIGURATION dans Business Central :
//    Administration → Planification des tâches → Entrées file d'attente
//    → Nouveau → Codeunit → ID : 65001
//    → Récurrence : toutes les 120 minutes (ou selon votre besoin)
// ============================================================
codeunit 65001 "Rec Workflow Job"
{
    // Propriété obligatoire pour être utilisé comme Job Queue
    Subtype = Normal;

    trigger OnRun()
    begin
        ExecuterTreatementAutomatique();
    end;

    // ──────────────────────────────────────────────────────────
    //  TRAITEMENT PRINCIPAL
    //  Point d'entrée appelé par le Job Queue scheduler de BC.
    // ──────────────────────────────────────────────────────────
    local procedure ExecuterTreatementAutomatique()
    var
        Rec: Record Reclamation;
        Engine: Codeunit "Rec Workflow Engine";
        JobLog: Record "Rec Job Log";
        NbTraitees: Integer;
        NbErreurs: Integer;
        StartTime: DateTime;
        ErrorMsg: Text;
    begin
        StartTime := CurrentDateTime();
        NbTraitees := 0;
        NbErreurs := 0;

        // ── Boucle sur toutes les réclamations actives ─────────
        Rec.Reset();
        Rec.SetRange(Cloturee, false); // exclure les clôturées
        Rec.SetFilter(Statut, '<>%1', Rec.Statut::" "); // exclure les vides

        if not Rec.FindSet(true) then begin
            // Aucune réclamation active — journaliser quand même
            InsererJobLog(StartTime, 0, 0, 'Aucune réclamation active à traiter.');
            exit;
        end;

        repeat
            // Traiter chaque réclamation dans un bloc protégé
            // pour qu'une erreur sur une réclamation n'arrête pas
            // le traitement des suivantes.
            if TryTraiterReclamation(Rec, Engine) then
                NbTraitees += 1
            else begin
                NbErreurs += 1;
                ErrorMsg := GetLastErrorText();
                InsererErreurLog(Rec."No_", ErrorMsg);
                ClearLastError();
            end;
        until Rec.Next() = 0;

        // ── Journaliser le résultat global ────────────────────
        InsererJobLog(
            StartTime,
            NbTraitees,
            NbErreurs,
            StrSubstNo('%1 réclamation(s) traitée(s), %2 erreur(s). Durée : %3 ms.',
                NbTraitees,
                NbErreurs,
                // Durée en millisecondes
                Format(CurrentDateTime() - StartTime)));
    end;

    // ──────────────────────────────────────────────────────────
    //  TRAITEMENT D'UNE SEULE RÉCLAMATION
    //  [TryFunction] : si une erreur se produit, elle est
    //  capturée et ne fait PAS planter tout le job.
    // ──────────────────────────────────────────────────────────
    [TryFunction]
    local procedure TryTraiterReclamation(var Rec: Record Reclamation; var Engine: Codeunit "Rec Workflow Engine")
    begin
        // 1. Recalculer le délai (age de la réclamation)
        Rec.CalculerDelaiTraitement();

        // 2. Appeler le moteur de règles
        Engine.EvaluerReclamation(Rec);
    end;

    // ──────────────────────────────────────────────────────────
    //  JOURNALISATION
    // ──────────────────────────────────────────────────────────
    local procedure InsererJobLog(StartTime: DateTime; NbTraitees: Integer; NbErreurs: Integer; Msg: Text)
    var
        JobLog: Record "Rec Job Log";
    begin
        JobLog.Init();
        JobLog."Date Heure Debut" := StartTime;
        JobLog."Date Heure Fin" := CurrentDateTime();
        JobLog."Nb Reclamations" := NbTraitees;
        JobLog."Nb Erreurs" := NbErreurs;
        JobLog.Message := CopyStr(Msg, 1, 500);
        JobLog.Succes := (NbErreurs = 0);
        JobLog.Insert(true);
    end;

    local procedure InsererErreurLog(NoRec: Code[20]; ErrMsg: Text)
    var
        JobLog: Record "Rec Job Log";
    begin
        JobLog.Init();
        JobLog."Date Heure Debut" := CurrentDateTime();
        JobLog."Date Heure Fin" := CurrentDateTime();
        JobLog."Nb Reclamations" := 0;
        JobLog."Nb Erreurs" := 1;
        JobLog.Message := CopyStr(
            StrSubstNo('ERREUR sur réclamation %1 : %2', NoRec, ErrMsg), 1, 500);
        JobLog.Succes := false;
        JobLog.Insert(true);
    end;
}

// ============================================================
//  TABLE 65010 — Rec Job Log
//  Journal d'exécution du Job Queue.
//  Permet au jury (et à l'admin) de voir que le système
//  tourne automatiquement en arrière-plan.
// ============================================================
table 65010 "Rec Job Log"
{
    Caption = 'Journal execution automatique';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'N° Entrée';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; "Date Heure Debut"; DateTime)
        {
            Caption = 'Début';
            DataClassification = CustomerContent;
        }
        field(3; "Date Heure Fin"; DateTime)
        {
            Caption = 'Fin';
            DataClassification = CustomerContent;
        }
        field(4; "Nb Reclamations"; Integer)
        {
            Caption = 'Réclamations traitées';
            DataClassification = CustomerContent;
        }
        field(5; "Nb Erreurs"; Integer)
        {
            Caption = 'Erreurs';
            DataClassification = CustomerContent;
        }
        field(6; Message; Text[500])
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
        field(7; Succes; Boolean)
        {
            Caption = 'Succes';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(K2; "Date Heure Debut") { }
    }
}

// ============================================================
//  PAGE 65010 — Journal d'exécution (pour l'admin et le jury)
// ============================================================
page 65010 "Rec Job Log List"
{
    Caption = 'Journal execution automatique';
    PageType = List;
    SourceTable = "Rec Job Log";
    UsageCategory = Administration;
    ApplicationArea = All;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Date Heure Debut"; Rec."Date Heure Debut")
                {
                    ApplicationArea = All;
                    Caption = 'Demarre a';
                }
                field("Date Heure Fin"; Rec."Date Heure Fin")
                {
                    ApplicationArea = All;
                    Caption = 'Termine a';
                }
                field("Nb Reclamations"; Rec."Nb Reclamations")
                {
                    ApplicationArea = All;
                    Caption = 'Reclamations';
                }
                field("Nb Erreurs"; Rec."Nb Erreurs")
                {
                    ApplicationArea = All;
                    Caption = 'Erreurs';
                    StyleExpr = ErreurStyle;
                }
                field(Succes; Rec.Succes)
                {
                    ApplicationArea = All;
                    Caption = 'Succes';
                    StyleExpr = SuccesStyle;
                }
                field(Message; Rec.Message)
                {
                    ApplicationArea = All;
                    Caption = 'Detail';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // Permet de lancer le job manuellement pour tester
            action(LancerManuellement)
            {
                ApplicationArea = All;
                Caption = 'Lancer maintenant test';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Job: Codeunit "Rec Workflow Job";
                begin
                    Job.Run();
                    Message('Traitement automatique execute. Actualisez la page.');
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec.Succes then begin
            SuccesStyle := 'Favorable';
            ErreurStyle := 'Standard';
        end else begin
            SuccesStyle := 'Unfavorable';
            ErreurStyle := 'Unfavorable';
        end;
        if Rec."Nb Erreurs" > 0 then
            ErreurStyle := 'Unfavorable';
    end;

    var
        SuccesStyle: Text;
        ErreurStyle: Text;
}

pageextension 65003 "Rec Card Workflow Ext" extends "Reclamation Card PFE"
{
    actions
    {
        addlast(Processing)
        {
            action(EvaluerRegles)
            {
                ApplicationArea = All;
                Caption = 'Evaluer regles auto';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Evalue les regles workflow sur cette reclamation.';

                trigger OnAction()
                var
                    Engine: Codeunit "Rec Workflow Engine";
                begin
                    Engine.EvaluerManuellement(Rec);
                    CurrPage.Update(true);
                end;
            }
        }
    }
}

// ============================================================
//  EXTENSION ROLECENTER — Ajouter les nouvelles pages
//  au menu de navigation existant
// ============================================================
pageextension 65004 "Rec RoleCenter Workflow Ext" extends "DLT Complaint RoleCenter"
{
    actions
    {
        addlast(Sections)
        {
            group(WorkflowAutoGroup)
            {
                Caption = 'Workflow Automatise';

                action(ReglesWorkflow)
                {
                    ApplicationArea = All;
                    Caption = 'Regles Workflow';
                    RunObject = page "Rec Workflow Rule List";
                    Image = Setup;
                }
                action(JournalJobQueue)
                {
                    ApplicationArea = All;
                    Caption = 'Journal execution';
                    RunObject = page "Rec Job Log List";
                    Image = History;
                }
            }
        }
    }
}
