codeunit 65001 "Rec Workflow Job"
{
    Subtype = Normal;

    trigger OnRun()
    begin
        ExecuterTreatementAutomatique();
    end;

    local procedure ExecuterTreatementAutomatique()
    var
        Rec: Record Reclamation;
        Engine: Codeunit "Rec Workflow Engine";
        NbTraitees: Integer;
        NbErreurs: Integer;
        StartTime: DateTime;
        ErrorMsg: Text;
    begin
        StartTime := CurrentDateTime();
        NbTraitees := 0;
        NbErreurs := 0;

        Rec.Reset();
        Rec.SetRange(Cloturee, false);
        Rec.SetFilter(Statut, '<>%1', Rec.Statut::" ");

        if not Rec.FindSet(true) then begin
            InsererJobLog(StartTime, 0, 0, 'Aucune réclamation active à traiter.');
            exit;
        end;

        repeat
            NbTraitees += 1;
            TryTraiterReclamation(Rec, Engine);
        until Rec.Next() = 0;

        InsererJobLog(
            StartTime,
            NbTraitees,
            NbErreurs,
            StrSubstNo('%1 réclamation(s) traitée(s), %2 erreur(s). Durée : %3 ms.',
                NbTraitees,
                NbErreurs,
                Format(CurrentDateTime() - StartTime)));
    end;

    local procedure TryTraiterReclamation(var Rec: Record Reclamation; var Engine: Codeunit "Rec Workflow Engine")
    begin
        Rec.CalculerDelaiTraitement();
        Engine.EvaluerReclamation(Rec);
    end;

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

table 65016 "Rec Job Log"
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
                action(ReglesAppliquees)
                {
                    ApplicationArea = All;
                    Caption = 'Regles Appliquees';
                    RunObject = page "Rec Workflow Rule Applied List";
                    Image = Approvals;
                }
            }
        }
    }
}
