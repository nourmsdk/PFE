page 65000 "Reclamation Card PFE"
{
    Caption = 'Fiche Réclamation Client Auto';
    PageType = Card;
    SourceTable = Reclamation;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Général';

                group(ColonneGauche)
                {
                    ShowCaption = false;

                    field("No_"; Rec."No_")
                    {
                        ApplicationArea = All;
                    }

                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                        MultiLine = true;
                    }

                    field("No. Client"; Rec."No. Client")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                        trigger OnValidate()
                        begin
                            CurrPage.Update(true);
                        end;
                    }
                    field("Nom Client"; Rec."Nom Client")
                    {
                        ApplicationArea = All;
                    }
                    field(NbReclamationsClient; NbReclamationsClient)
                    {
                        ApplicationArea = All;
                        Caption = 'Total réclamations client';
                        Editable = false;
                        StyleExpr = NbReclamStyle;
                    }

                    field("No. Serie Vehicule"; Rec."No. Serie Vehicule")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field(VIN; Rec.VIN)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("No. Enregistrement Vehicule"; Rec."No. Enregistrement Vehicule")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("No. Telephone"; Rec."No. Telephone")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("Code Categorie"; Rec."Code Categorie")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }
                    field("Code Sous Categorie"; Rec."Code Sous Categorie")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }
                    field("Description Sous Categorie"; Rec."Description Sous Categorie")
                    {
                        ApplicationArea = All;
                    }

                    field("Description Categorie"; Rec."Description Categorie")
                    {
                        ApplicationArea = All;
                    }

                    field("No. Facture"; Rec."No. Facture")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }
                    field("Date Creation"; Rec."Date Creation")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }

                group(ColonneDroite)
                {
                    ShowCaption = false;

                    field(Statut; Rec.Statut)
                    {
                        ApplicationArea = All;
                        StyleExpr = StatutStyle;
                        Editable = EstModifiable;
                    }
                    field("Etape Workflow"; Rec."Etape Workflow")
                    {
                        ApplicationArea = All;
                        Caption = 'Étape Workflow';
                        Editable = false;
                    }

                    field(Priorite; Rec.Priorite)
                    {
                        ApplicationArea = All;
                        StyleExpr = PrioriteStyle;
                        Editable = EstModifiable and PeutSAV;
                    }

                    field("Description Action Prise"; Rec."Description Action Prise")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                        MultiLine = true;
                    }

                    field("Date Prise En Charge"; Rec."Date Prise En Charge")
                    {
                        ApplicationArea = All;
                    }

                    field("Date Cloture"; Rec."Date Cloture")
                    {
                        ApplicationArea = All;
                    }
                    field("Retour Client"; Rec."Retour Client")
                    {
                        ApplicationArea = All;
                        Editable = (Rec.Cloturee) or
               (Rec."Etape Workflow" = "Etape Workflow Reclamation"::Validation);
                    }
                    field("Date Mise En Cours"; Rec."Date Mise En Cours")
                    {
                        ApplicationArea = All;
                    }
                    field("Delai En Cours"; Rec."Delai En Cours")
                    {
                        ApplicationArea = All;
                        StyleExpr = DelaiStyle;
                    }

                    field("Statut SLA"; HorsDelaiTexte)
                    {
                        ApplicationArea = All;
                        StyleExpr = HorsDelaiStyle;
                        Editable = false;
                    }
                    field(Canal; Rec.Canal)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("Type Reclamation"; Rec."Type Reclamation")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field(Gravite; Rec.Gravite)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable and PeutSAV;
                        StyleExpr = GraviteStyle;
                    }

                    field(Responsabilite; Rec.Responsabilite)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }

                    field("Attribue A"; Rec."Attribue A")
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }
                    field(NbActionsTotales; NbActionsTotales)
                    {
                        ApplicationArea = All;
                        Caption = 'Nb actions totales';
                        Editable = false;
                    }
                    field(NbActionsTerminees; NbActionsTerminees)
                    {
                        ApplicationArea = All;
                        Caption = 'Nb actions terminées';
                        Editable = false;
                        StyleExpr = NbActionsStyle;
                    }
                    field(NbActionsEnRetard; NbActionsEnRetard)
                    {
                        ApplicationArea = All;
                        Caption = 'Nb actions en retard';
                        Editable = false;
                        StyleExpr = NbRetardStyle;
                    }

                    field(Agence; Rec.Agence)
                    {
                        ApplicationArea = All;
                        Editable = EstModifiable;
                    }
                    field("Nom Agence"; Rec."Nom Agence")
                    {
                        ApplicationArea = All;
                    }
                }
            }

            group(ActionsCorrectivesGroup)
            {
                Caption = 'Actions Correctives';

                part(ActionsCorrectivesPart; "Rec Action Corrective Subpage")
                {
                    ApplicationArea = All;
                    Caption = 'Actions Correctives';
                    SubPageLink = "No Reclamation" = field("No_");
                    UpdatePropagation = Both;
                }
            }
        }
        area(FactBoxes)
        {
            part(HistoriqueClientFB; "Rec Historique Client FB")
            {
                ApplicationArea = All;
                Caption = 'Historique Client';
                SubPageLink = "No. Client" = field("No. Client");
            }
            part(WorkflowHistoryFB; "Rec Workflow History FB")
            {
                ApplicationArea = All;
                Caption = 'Historique Workflow';
                SubPageLink = "No. Reclamation" = field("No_");
            }
            part(NotificationLogFB; "Rec Notification Log FB")
            {
                ApplicationArea = All;
                Caption = 'Notifications';
                SubPageLink = "No. Reclamation" = field("No_");
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(PrendreEnChargePFE)
            {
                Enabled = (Rec.Statut = Rec.Statut::Ouverte) and PeutSAV;
                ApplicationArea = All;
                Caption = 'Prendre en Charge';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    NotifLog: Record "Rec Notification Log";
                begin
                    RoleMgt.EnsureSAV('Prendre en Charge');
                    if Rec.Description = '' then
                        Error('Vous devez renseigner la Description de la réclamation.');
                    if Rec."Description Action Prise" = '' then
                        Error('Vous devez renseigner la Description Action Prise.');

                    // Notification
                    NotifLog.Init();
                    NotifLog."No. Reclamation" := Rec."No_";
                    NotifLog."Date Heure" := CurrentDateTime();
                    NotifLog."Type Notification" := NotifLog."Type Notification"::"Confirmation Client";
                    NotifLog.Message := CopyStr(StrSubstNo(
                        'Réclamation %1 prise en charge par %2',
                        Rec."No_", UserId()), 1, 500);
                    NotifLog.Destinataire := Rec."Attribue A";
                    NotifLog."No. Client" := Rec."No. Client";
                    NotifLog.Processed := false;
                    NotifLog.Insert(true);

                    Rec.Statut := "Statut Reclamation"::PriseEnCharge;
                    Rec."Date Prise En Charge" := Today();
                    if not Rec.Cloturee then Rec.CalculerDelaiTraitement();
                    Rec.Modify(true);
                    CurrPage.Update(true);
                end;
            }

            action(MettreEnCoursPFE)
            {
                Enabled = (Rec.Statut = "Statut Reclamation"::PriseEnCharge) and PeutSAV;
                ApplicationArea = All;
                Caption = 'Mettre En Cours';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    NotifLog: Record "Rec Notification Log";
                begin
                    RoleMgt.EnsureSAV('Mettre En Cours');
                    if Rec.Statut <> "Statut Reclamation"::PriseEnCharge then
                        Error('La réclamation doit être "Prise en charge" avant de la mettre En Cours.');

                    // Notification
                    NotifLog.Init();
                    NotifLog."No. Reclamation" := Rec."No_";
                    NotifLog."Date Heure" := CurrentDateTime();
                    NotifLog."Type Notification" := NotifLog."Type Notification"::"Confirmation Client";
                    NotifLog.Message := CopyStr(StrSubstNo(
                        'Réclamation %1 mise En Cours par %2',
                        Rec."No_", UserId()), 1, 500);
                    NotifLog.Destinataire := Rec."Attribue A";
                    NotifLog."No. Client" := Rec."No. Client";
                    NotifLog.Processed := false;
                    NotifLog.Insert(true);

                    Rec.Statut := "Statut Reclamation"::EnCours;
                    Rec."Date Mise En Cours" := Today();
                    Rec.Modify(true);
                    CurrPage.Update(true);
                    Message('Réclamation passée En Cours.');
                end;
            }

            action(CloturerPFE)
            {
                ApplicationArea = All;
                Caption = 'Clôturer';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = (Rec.Statut <> Rec.Statut::Cloturee) and (Rec."Code Categorie" <> '') and PeutQualite;

                trigger OnAction()
                var
                    NotifLog: Record "Rec Notification Log";
                begin
                    RoleMgt.EnsureQualite('Clôturer');
                    // ── VerifierConditionsCloture : bloquant + warning Confirm() ─────
                    if not WorkflowEngine.VerifierConditionsCloture(Rec) then exit;

                    if not Confirm('Clôturer définitivement cette réclamation ?', false) then exit;

                    // ── Notification HORS SLA si applicable ──────────────────────────
                    if Rec."Hors Delai" and (not Rec."Notification Envoyee") then begin
                        NotifLog.Init();
                        NotifLog."No. Reclamation" := Rec."No_";
                        NotifLog."Date Heure" := CurrentDateTime();
                        NotifLog."Type Notification" := NotifLog."Type Notification"::"Hors SLA";
                        NotifLog.Message := CopyStr(StrSubstNo(
                            'Clôture — Réclamation %1 était HORS SLA (%2 jours). Client : %3',
                            Rec."No_", Rec."Delai En Cours", Rec."Nom Client"), 1, 500);
                        NotifLog.Destinataire := Rec."Attribue A";
                        NotifLog."No. Client" := Rec."No. Client";
                        NotifLog.Processed := true;
                        NotifLog.Insert(true);
                        Rec."Notification Envoyee" := true;
                    end;

                    // ── Notification de clôture ───────────────────────────────────────
                    NotifLog.Init();
                    NotifLog."No. Reclamation" := Rec."No_";
                    NotifLog."Date Heure" := CurrentDateTime();
                    NotifLog."Type Notification" := NotifLog."Type Notification"::Cloture;
                    NotifLog.Message := CopyStr(StrSubstNo(
                        'Réclamation %1 clôturée après %2 jours. Retour client : %3',
                        Rec."No_", Rec."Delai En Cours", Format(Rec."Retour Client")), 1, 500);
                    NotifLog.Destinataire := Rec."Attribue A";
                    NotifLog."No. Client" := Rec."No. Client";
                    NotifLog.Processed := true;
                    NotifLog.Insert(true);

                    Rec.Statut := Rec.Statut::Cloturee;
                    Rec."Date Cloture" := Today();
                    Rec.Cloturee := true;
                    Rec.Modify(true);
                    CurrPage.Update(true);
                end;
            }

            action(RouvrirPFE)
            {
                ApplicationArea = All;
                Caption = 'Rouvrir';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = (Rec.Statut = Rec.Statut::Cloturee) and PeutQualite;

                trigger OnAction()
                var
                    NotifLog: Record "Rec Notification Log";
                begin
                    RoleMgt.EnsureQualite('Rouvrir');
                    // Notification
                    NotifLog.Init();
                    NotifLog."No. Reclamation" := Rec."No_";
                    NotifLog."Date Heure" := CurrentDateTime();
                    NotifLog."Type Notification" := NotifLog."Type Notification"::"Relance Client";
                    NotifLog.Message := CopyStr(StrSubstNo(
                        'Réclamation %1 réouverte par %2',
                        Rec."No_", UserId()), 1, 500);
                    NotifLog.Destinataire := Rec."Attribue A";
                    NotifLog."No. Client" := Rec."No. Client";
                    NotifLog.Processed := false;
                    NotifLog.Insert(true);

                    Rec.Statut := Rec.Statut::Ouverte;
                    Rec."Date Cloture" := 0D;
                    Rec.Cloturee := false;
                    Rec."Notification Envoyee" := false;
                    Rec.CalculerDelaiTraitement();
                    Rec.Modify(true);
                    CurrPage.Update(true);
                    Message('Réclamation réouverte avec succès.');
                end;
            }

            action(NotifierClientPFE)
            {
                ApplicationArea = All;
                Caption = 'Notifier Client';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = (Rec."No. Client" <> '');

                trigger OnAction()
                var
                    Cust: Record Customer;
                begin
                    if Rec."No. Client" = '' then
                        Error('Aucun client associé à cette réclamation.');

                    if Cust.Get(Rec."No. Client") then begin
                        if Cust."E-Mail" = '' then
                            Error('Le client %1 n''a pas d''adresse email.', Cust.Name);

                        HyperLink(
                            'mailto:' + Cust."E-Mail" +
                            '?subject=Réclamation ' + Rec."No_" +
                            '&body=Bonjour ' + Rec."Nom Client" +
                            ', suite à votre réclamation ' + Rec."No_" + '.'
                        );
                    end;
                end;
            }

            action(PasserQualification)
            {
                Caption = 'Envoyer pour qualification';
                Image = Approval;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = (Rec."Etape Workflow" = "Etape Workflow Reclamation"::Ouverture) and PeutOuvrir;

                trigger OnAction()
                begin
                    RoleMgt.EnsureReceptionnaireOuSAV('Envoyer pour qualification');
                    // ── Gardes Ouverture → Qualification ──────────────────
                    if Rec."No. Client" = '' then
                        Error('Ouverture : veuillez renseigner le client.');
                    if Rec."No. Serie Vehicule" = '' then
                        Error('Ouverture : veuillez renseigner le véhicule.');
                    if Rec.Description = '' then
                        Error('Ouverture : veuillez renseigner la description.');
                    if Rec.Canal = Rec.Canal::" " then
                        Error('Ouverture : veuillez renseigner le canal.');
                    if Rec."Code Categorie" = '' then
                        Error('Ouverture : veuillez renseigner la catégorie.');
                    if Rec."Code Sous Categorie" = '' then
                        Error('Ouverture : veuillez renseigner la sous-catégorie.');
                    if Rec.Agence = '' then
                        Error('Ouverture : veuillez renseigner l''agence.');

                    WorkflowEngine.PasserEtapeSuivante(
                        Rec,
                        "Etape Workflow Reclamation"::Qualification,
                        '');
                    CurrPage.Update(false);
                end;
            }

            action(PasserAffectation)
            {
                Caption = '→ Affecter';
                Image = UserSetup;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = (Rec."Etape Workflow" = "Etape Workflow Reclamation"::Qualification) and PeutSAV;
                trigger OnAction()
                begin
                    RoleMgt.EnsureSAV('Affecter');
                    // ── Gardes Qualification → Affectation ────────────────
                    if Rec.Gravite = Rec.Gravite::" " then
                        Error('Qualification : veuillez renseigner la gravité.');
                    if Rec."Type Reclamation" = Rec."Type Reclamation"::" " then
                        Error('Qualification : veuillez renseigner le type de réclamation.');
                    if Rec.Responsabilite = Rec.Responsabilite::" " then
                        Error('Qualification : veuillez renseigner la responsabilité.');

                    // ── Évaluation auto des règles (ex. ESCALADE si Gravité Critique) ─
                    WorkflowEngine.EvaluerReclamation(Rec);

                    WorkflowEngine.PasserEtapeSuivante(
                        Rec,
                        "Etape Workflow Reclamation"::Affectation,
                        '');
                    CurrPage.Update(false);
                end;
            }

            action(PasserInvestigation)
            {
                Caption = '→ Investigation';
                Image = Find;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = (Rec."Etape Workflow" = "Etape Workflow Reclamation"::Affectation) and PeutSAV;

                trigger OnAction()
                var
                    ActionCorr: Record "Rec Action Corrective";
                begin
                    RoleMgt.EnsureSAV('Passer en Investigation');
                    // ── Gardes Affectation → Investigation ────────────────
                    if Rec."Attribue A" = '' then
                        Error('Affectation : veuillez attribuer la réclamation à un agent avant de lancer l''investigation.');

                    // Vérifier qu'au moins une action corrective existe
                    ActionCorr.Reset();
                    ActionCorr.SetRange("No Reclamation", Rec."No_");
                    if ActionCorr.IsEmpty() then
                        Error('Affectation : aucune action corrective définie. Vérifiez la catégorie/sous-catégorie.');

                    WorkflowEngine.PasserEtapeSuivante(
                         Rec,
                         "Etape Workflow Reclamation"::Investigation,
                         '');
                    CurrPage.Update(false);
                end;
            }

            action(PasserActionCorrective)
            {
                Caption = '→ Action corrective';
                Image = Tools;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = (Rec."Etape Workflow" = "Etape Workflow Reclamation"::Investigation) and PeutSAV;

                trigger OnAction()
                begin
                    RoleMgt.EnsureSAV('Passer en Action corrective');
                    // ── Gardes Investigation → Action corrective ───────────
                    if Rec."Description Action Prise" = '' then
                        Error('Investigation : veuillez renseigner la description de l''action prise.');
                    if Rec.Statut = "Statut Reclamation"::Ouverte then
                        Error('Investigation : la réclamation doit être au minimum "Prise en charge".');

                    WorkflowEngine.PasserEtapeSuivante(
                        Rec,
                        "Etape Workflow Reclamation"::ActionCorrective,
                        '');
                    CurrPage.Update(false);
                end;
            }
            action(PasserValidation)
            {
                Caption = '→ Soumettre validation';
                Image = ReleaseDoc;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = (Rec."Etape Workflow" = "Etape Workflow Reclamation"::ActionCorrective) and PeutSAV;

                trigger OnAction()
                var
                    ActionCorr: Record "Rec Action Corrective";
                    NbTotal: Integer;
                    NbTerminees: Integer;
                begin
                    RoleMgt.EnsureSAV('Soumettre validation');
                    // ── Gardes Action corrective → Validation ─────────────
                    // Vérifier qu'il n'y a pas d'actions en retard non traitées
                    ActionCorr.Reset();
                    ActionCorr.SetRange("No Reclamation", Rec."No_");
                    ActionCorr.SetRange("Indicateur Retard", true);
                    ActionCorr.SetFilter(Statut, '<>%1&<>%2',
                        "Statut Action Corrective"::Terminee,
                        "Statut Action Corrective"::Annulee);
                    if not ActionCorr.IsEmpty() then
                        if not Confirm(
                            'Attention : %1 action(s) corrective(s) en retard non clôturée(s).\Voulez-vous quand même soumettre à validation ?',
                            false,
                            ActionCorr.Count())
                        then
                            exit;

                    // Vérifier qu'au moins une action est terminée
                    ActionCorr.Reset();
                    ActionCorr.SetRange("No Reclamation", Rec."No_");
                    NbTotal := ActionCorr.Count();

                    ActionCorr.SetRange(Statut, "Statut Action Corrective"::Terminee);
                    NbTerminees := ActionCorr.Count();

                    if NbTerminees = 0 then
                        Error('Action corrective : au moins une action corrective doit être terminée avant de soumettre à validation.');

                    WorkflowEngine.PasserEtapeSuivante(
                         Rec,
                         "Etape Workflow Reclamation"::Validation,
                         '');
                    CurrPage.Update(false);
                end;
            }

            action(RejeterVersInvestigation)
            {
                Caption = '↩ Rejeter → Investigation';
                Image = ReOpen;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = (Rec."Etape Workflow" = "Etape Workflow Reclamation"::Validation) and PeutQualite;

                trigger OnAction()
                var
                    MotifDialog: Page "Rec Motif Rejet Dialog";
                    Motif: Text[250];
                begin
                    RoleMgt.EnsureQualite('Rejeter vers Investigation');

                    // ── Garde Validation → Rejet : commentaire obligatoire ─
                    if MotifDialog.RunModal() <> Action::OK then exit;
                    Motif := MotifDialog.GetMotif();
                    if Motif = '' then
                        Error('Le motif du rejet est obligatoire.');

                    WorkflowEngine.PasserEtapeSuivante(
                         Rec,
                         "Etape Workflow Reclamation"::Investigation,
                         'Rejeté par ' + UserId() + ' : ' + Motif);
                    CurrPage.Update(false);
                end;
            }

            action(PasserCloture)
            {
                Caption = '→ Clôturer (workflow)';
                Image = Approve;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = (Rec."Etape Workflow" = "Etape Workflow Reclamation"::Validation) and PeutQualite;

                trigger OnAction()
                var
                    ActionCorr: Record "Rec Action Corrective";
                    NbOuvertes: Integer;
                begin
                    RoleMgt.EnsureQualite('Clôturer (workflow)');
                    // ── Gardes Validation → Clôture ───────────────────────
                    // 1. Vérifier conditions de clôture (méthode centralisée)
                    if not WorkflowEngine.VerifierConditionsCloture(Rec) then exit;

                    // 2. Vérifier actions correctives non terminées
                    ActionCorr.Reset();
                    ActionCorr.SetRange("No Reclamation", Rec."No_");
                    ActionCorr.SetFilter(Statut, '<>%1&<>%2',
                        "Statut Action Corrective"::Terminee,
                        "Statut Action Corrective"::Annulee);
                    NbOuvertes := ActionCorr.Count();
                    if NbOuvertes > 0 then
                        if not Confirm(
                            '%1 action(s) corrective(s) non terminée(s).\Clôturer quand même ?',
                            false,
                            NbOuvertes)
                        then
                            exit;

                    // 3. Retour client obligatoire à la clôture
                    if Rec."Retour Client" = Rec."Retour Client"::" " then
                        Error('Clôture : veuillez renseigner le retour client avant de clôturer.');

                    // 4. Confirmation finale
                    if not Confirm('Clôturer définitivement cette réclamation ?', false) then
                        exit;

                    WorkflowEngine.PasserEtapeSuivante(
                        Rec,
                        "Etape Workflow Reclamation"::Cloture,
                        'Clôture validée par ' + UserId());
                    CurrPage.Update(false);
                end;
            }

        }
    }

    trigger OnOpenPage()
    begin
        PeutOuvrir := RoleMgt.IsReceptionnaireOuSAV();
        PeutSAV := RoleMgt.IsSAV();
        PeutQualite := RoleMgt.IsQualite();
    end;

    trigger OnAfterGetRecord()
    begin

        if not Rec.Cloturee then
            Rec.CalculerDelaiTraitement();

        // Style Statut
        case Rec.Statut of
            Rec.Statut::Ouverte:
                StatutStyle := 'Unfavorable';

            "Statut Reclamation"::PriseEnCharge,
"Statut Reclamation"::EnCours:
                StatutStyle := 'Ambiguous';

            Rec.Statut::Cloturee:
                StatutStyle := 'Favorable';
        end;

        // Style Priorité
        case Rec.Priorite of
            Rec.Priorite::Faible:
                PrioriteStyle := 'Favorable';

            Rec.Priorite::Moyenne:
                PrioriteStyle := 'Ambiguous';

            Rec.Priorite::Haute:
                PrioriteStyle := 'Unfavorable';
        end;
        case Rec.Gravite of
            Rec.Gravite::Critique:
                GraviteStyle := 'Unfavorable';
            Rec.Gravite::Haute:
                GraviteStyle := 'Attention';
            Rec.Gravite::Moyenne:
                GraviteStyle := 'Ambiguous';
            Rec.Gravite::Faible:
                GraviteStyle := 'Favorable';
        end;

        // Style Délai + Hors Délai (dont palier 75% SLA)
        if Rec."Hors Delai" then begin
            DelaiStyle := 'Unfavorable';
            HorsDelaiStyle := 'Unfavorable';
        end else if CalculerDelaiPct(Rec) >= 75 then begin
            DelaiStyle := 'Attention';
            HorsDelaiStyle := 'Attention';
        end else if Rec."Delai En Cours" > 5 then begin
            DelaiStyle := 'Ambiguous';
            HorsDelaiStyle := 'Standard';
        end else begin
            DelaiStyle := 'Favorable';
            HorsDelaiStyle := 'Favorable';
        end;

        // Texte badge SLA
        if Rec."Hors Delai" then
            HorsDelaiTexte := ' HORS SLA'
        else
            HorsDelaiTexte := ' Dans les délais';


        if Rec."No. Client" <> '' then begin
            Rec2.Reset();
            Rec2.SetRange("No. Client", Rec."No. Client");
            NbReclamationsClient := Rec2.Count();
        end else
            NbReclamationsClient := 0;




        // Couleur selon le nombre
        if NbReclamationsClient >= 5 then
            NbReclamStyle := 'Unfavorable'    // rouge — client récidiviste
        else if NbReclamationsClient >= 2 then
            NbReclamStyle := 'Ambiguous'      // orange — à surveiller
        else
            NbReclamStyle := 'Favorable';     // vert — client tranquille


        EstModifiable := (Rec.Statut <> Rec.Statut::Cloturee);
        // Compteurs actions correctives
        ActionCorr.Reset();
        ActionCorr.SetRange("No Reclamation", Rec."No_");
        NbActionsTotales := ActionCorr.Count();

        ActionCorr.SetRange(Statut, "Statut Action Corrective"::Terminee);
        NbActionsTerminees := ActionCorr.Count();

        ActionCorr.Reset();
        ActionCorr.SetRange("No Reclamation", Rec."No_");
        ActionCorr.SetRange("Indicateur Retard", true);
        NbActionsEnRetard := ActionCorr.Count();

        // Styles
        if NbActionsEnRetard > 0 then
            NbRetardStyle := 'Unfavorable'
        else
            NbRetardStyle := 'Favorable';

        if (NbActionsTotales > 0) and (NbActionsTerminees = NbActionsTotales) then
            NbActionsStyle := 'Favorable'
        else if NbActionsTerminees > 0 then
            NbActionsStyle := 'Ambiguous'
        else
            NbActionsStyle := 'Standard';
        CurrPage.ActionsCorrectivesPart.Page.SetNoReclamation(Rec."No_");
        CurrPage.HistoriqueClientFB.Page.Update(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        CurrPage.Editable := true;
        EstModifiable := true;
        CurrPage.ActionsCorrectivesPart.Page.SetNoReclamation(Rec."No_");
    end;

    local procedure CalculerDelaiPct(RecReclam: Record Reclamation): Integer
    var
        RecParam: Record "Rec Parametres";
        SLAJours: Integer;
    begin
        SLAJours := 7;
        if RecParam.Get('DEFAULT') then
            if RecParam."SLA Jours" > 0 then
                SLAJours := RecParam."SLA Jours";

        if SLAJours > 0 then
            exit(Round((RecReclam."Delai En Cours" / SLAJours) * 100, 1))
        else
            exit(0);
    end;

    var
        StatutStyle: Text;
        PrioriteStyle: Text;
        DelaiStyle: Text;
        HorsDelaiStyle: Text;
        HorsDelaiTexte: Text;
        GraviteStyle: Text;
        EstModifiable: Boolean;
        NbReclamationsClient: Integer;
        NbReclamStyle: Text;
        Rec2: Record Reclamation;
        NbActionsTotales: Integer;
        NbActionsTerminees: Integer;
        NbActionsEnRetard: Integer;
        NbActionsStyle: Text;
        NbRetardStyle: Text;
        ActionCorr: Record "Rec Action Corrective";
        WorkflowEngine: Codeunit "Rec Workflow Engine";
        RoleMgt: Codeunit "Rec Role Mgt";
        PeutOuvrir: Boolean;
        PeutSAV: Boolean;
        PeutQualite: Boolean;
}
