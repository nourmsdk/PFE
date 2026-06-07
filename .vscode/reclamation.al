table 65000 "Reclamation"
{
    Caption = 'Réclamation Client Auto';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No_"; Code[20])
        {
            Caption = 'N° Réclamation';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                NoSeries: Codeunit "No. Series";
            begin
                if "No_" <> xRec."No_" then begin
                    NoSeries.TestManual(GetNoSeriesCode());
                    "No. Series" := '';
                end;


            end;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "No. Serie Vehicule"; Code[20])
        {
            Caption = 'N° Série Véhicule';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Veh: Record Vehicle;
                Cust: Record Customer;
            begin
                if "No. Serie Vehicule" = '' then exit;

                if Veh.Get("No. Serie Vehicule") then begin
                    VIN := Veh.VIN;
                    "No. Enregistrement Vehicule" := Veh."Registration No.";

                    // Remplir client si pas déjà renseigné
                    if "No. Client" = '' then begin
                        "No. Client" := Veh."Customer No.";
                        if Cust.Get("No. Client") then begin
                            "Nom Client" := Cust.Name;
                            if "No. Telephone" = '' then
                                "No. Telephone" := Cust."Phone No.";
                        end;
                    end;
                end;
            end;
        }
        field(4; VIN; Code[20])
        {
            Caption = 'VIN';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Veh: Record Vehicle;
                Cust: Record Customer;
            begin
                if VIN = '' then exit;

                Veh.Reset();
                Veh.SetRange(VIN, VIN);
                if Veh.FindFirst() then begin
                    "No. Serie Vehicule" := Veh."Serial No.";
                    "No. Enregistrement Vehicule" := Veh."Registration No.";

                    // Remplir client si pas déjà renseigné
                    if "No. Client" = '' then begin
                        "No. Client" := Veh."Customer No.";
                        if Cust.Get("No. Client") then begin
                            "Nom Client" := Cust.Name;
                            if "No. Telephone" = '' then
                                "No. Telephone" := Cust."Phone No.";
                        end;
                    end;
                end;
            end;
        }
        field(5; "No. Enregistrement Vehicule"; Code[20])
        {
            Caption = 'N° Enregistrement Véhicule';
            DataClassification = CustomerContent;
        }
        field(6; "No. Telephone"; Text[20])
        {
            Caption = 'N° Téléphone';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Cust: Record Customer;
                i: Integer;
            begin
                if "No. Telephone" = '' then
                    exit;

                // 1 — Validation format AVANT la recherche
                for i := 1 to StrLen("No. Telephone") do
                    if not ("No. Telephone"[i] in ['0' .. '9', '+', ' ', '-']) then
                        Error('N° Téléphone invalide. Utilisez uniquement des chiffres, +, espace ou -.');

                // 2 — Recherche client par téléphone principal
                Cust.Reset();
                Cust.SetRange("Phone No.", "No. Telephone");
                if Cust.FindFirst() then begin
                    "No. Client" := Cust."No.";
                    "Nom Client" := Cust.Name;
                    exit;
                end;

                // 3 — Recherche client par mobile
                Cust.Reset();
                Cust.SetRange("Mobile Phone No.", "No. Telephone");
                if Cust.FindFirst() then begin
                    "No. Client" := Cust."No.";
                    "Nom Client" := Cust.Name;
                end;
            end;
        }
        field(7; "No. Telephone 2"; Text[20])
        {
            Caption = 'N° Téléphone 2';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                i: Integer;
            begin
                if "No. Telephone 2" = '' then
                    exit;

                // Validation format
                for i := 1 to StrLen("No. Telephone 2") do
                    if not ("No. Telephone 2"[i] in ['0' .. '9', '+', ' ', '-']) then
                        Error('N° Téléphone 2 invalide. Utilisez uniquement des chiffres, +, espace ou -.');
            end;
        }
        field(8; "Code Categorie"; Code[20])
        {
            Caption = 'Code Catégorie';
            DataClassification = CustomerContent;
            TableRelation = "Rec Categorie".Code;

            trigger OnValidate()
            var
                RecCat: Record "Rec Categorie";
            begin
                if RecCat.Get("Code Categorie") then
                    "Description Categorie" := RecCat.Description
                else
                    "Description Categorie" := '';
                "Code Sous Categorie" := '';
                "Description Sous Categorie" := '';
            end;
        }
        field(9; "Description Categorie"; Text[100])
        {
            Caption = 'Description Catégorie';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Code Sous Categorie"; Code[20])
        {
            Caption = 'Code Sous-Catégorie';
            DataClassification = CustomerContent;
            TableRelation = "Rec Sous Categorie".Code where("Code Categorie" = field("Code Categorie"));

            trigger OnValidate()
            var
                RecSousCat: Record "Rec Sous Categorie";
            begin
                if RecSousCat.Get("Code Categorie", "Code Sous Categorie") then
                    "Description Sous Categorie" := RecSousCat.Description
                else
                    "Description Sous Categorie" := '';
            end;
        }
        field(11; "Description Sous Categorie"; Text[100])
        {
            Caption = 'Description Sous-Catégorie';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "No. Client"; Code[20])
        {
            Caption = 'N° Client';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                Cust: Record Customer;
                Veh: Record Vehicle;
                VehList: Page "Vehicle List";
            begin
                // Nom client
                if Cust.Get("No. Client") then begin
                    "Nom Client" := Cust.Name;
                    if "No. Telephone" = '' then
                        "No. Telephone" := Cust."Phone No.";
                    if "No. Telephone 2" = '' then
                        "No. Telephone 2" := Cust."Mobile Phone No.";
                end else begin
                    "Nom Client" := '';
                    exit;
                end;

                // Recherche véhicules liés au client
                Veh.Reset();
                Veh.SetRange("Customer No.", "No. Client");

                case Veh.Count of
                    0:
                        // Aucun véhicule → rien
                        exit;
                    1:
                        begin
                            // 1 seul véhicule → remplissage auto
                            Veh.FindFirst();
                            "No. Serie Vehicule" := Veh."Serial No.";
                            VIN := Veh.VIN;
                            "No. Enregistrement Vehicule" := Veh."Registration No.";
                        end;
                    else begin
                        // Plusieurs véhicules → liste de choix
                        Veh.FindFirst();
                        VehList.SetTableView(Veh);
                        VehList.LookupMode(true);
                        if VehList.RunModal() = Action::LookupOK then begin
                            VehList.GetRecord(Veh);
                            "No. Serie Vehicule" := Veh."Serial No.";
                            VIN := Veh.VIN;
                            "No. Enregistrement Vehicule" := Veh."Registration No.";
                        end;
                    end;
                end;
            end;
        }
        field(13; "Nom Client"; Text[100])
        {
            Caption = 'Nom Client';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; Canal; Option)
        {
            Caption = 'Canal';
            DataClassification = CustomerContent;
            OptionMembers = " ",SAV,Showroom,"Téléphone",Email,Web;
            OptionCaption = ' ,SAV,Showroom,Téléphone,Email,Web';
        }
        field(15; "Type Reclamation"; Option)
        {
            Caption = 'Type Réclamation';
            DataClassification = CustomerContent;
            OptionMembers = " ",Technique,Commercial,Livraison,Garantie,"Pièce défectueuse";
            OptionCaption = ' ,Technique,Commercial,Livraison,Garantie,Pièce défectueuse';
        }
        field(16; Gravite; Option)
        {
            Caption = 'Gravité';
            DataClassification = CustomerContent;
            OptionMembers = " ",Faible,Moyenne,Haute,Critique;
            OptionCaption = ' ,Faible,Moyenne,Haute,Critique';

            trigger OnValidate()
            begin
                case Gravite of
                    Gravite::Critique:
                        Priorite := Priorite::Haute;

                    Gravite::Haute:
                        Priorite := Priorite::Haute;

                    Gravite::Moyenne:
                        Priorite := Priorite::Moyenne;

                    Gravite::Faible:
                        Priorite := Priorite::Faible;

                    else
                        Priorite := Priorite::" ";
                end;
            end;
        }
        field(17; Responsabilite; Option)
        {
            Caption = 'Responsabilité';
            DataClassification = CustomerContent;
            OptionMembers = " ",Atelier,Vendeur,Constructeur,Fournisseur;
            OptionCaption = ' ,Atelier,Vendeur,Constructeur,Fournisseur';
        }
        field(18; "Attribue A"; Code[50])
        {
            Caption = 'Attribué à';
            DataClassification = CustomerContent;
            TableRelation = User."User Name";
        }
        field(19; Agence; Code[20])
        {
            Caption = 'Agence';
            DataClassification = CustomerContent;
            TableRelation = "Rec Agence".Code;

            trigger OnValidate()
            var
                RecAgence: Record "Rec Agence";
            begin
                if RecAgence.Get(Agence) then
                    "Nom Agence" := RecAgence.Nom
                else
                    "Nom Agence" := '';
            end;
        }
        field(20; "Date Creation"; Date)
        {
            Caption = 'Date Création';
            DataClassification = CustomerContent;
        }
        field(21; Priorite; Option)
        {
            Caption = 'Priorité';
            DataClassification = CustomerContent;
            OptionMembers = " ",Faible,Moyenne,Haute;
            OptionCaption = ' ,Faible,Moyenne,Haute';
        }
        field(22; Statut; Option)
        {
            Caption = 'Statut';
            DataClassification = CustomerContent;
            OptionMembers = " ","Ouverte","Prise en charge","En cours","Cloturee";
            OptionCaption = ' ,Ouverte,Prise en charge,En cours,Clôturée';
        }
        field(23; "Description Action Prise"; Text[250])
        {
            Caption = 'Description Action Prise';
            DataClassification = CustomerContent;
        }
        field(24; "Date Prise En Charge"; Date)
        {
            Caption = 'Date de Prise en Charge';
            DataClassification = CustomerContent;
        }
        field(25; "Date Validite"; Date)
        {
            Caption = 'Date Validité';
            DataClassification = CustomerContent;
        }
        field(26; "Date Cloture"; Date)
        {
            Caption = 'Date Clôture';
            DataClassification = CustomerContent;
        }
        field(27; "Delai Traitement"; Integer)
        {
            Caption = 'Délai Traitement (jours)';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(28; Cloturee; Boolean)
        {
            Caption = 'Clôturée';
            DataClassification = CustomerContent;
        }
        field(29; "Retour Client"; Option)
        {
            Caption = 'Retour Client';
            DataClassification = CustomerContent;
            OptionMembers = " ",Satisfait,Insatisfait,"Sans retour";
            OptionCaption = ' ,Satisfait,Insatisfait,Sans retour';
        }
        field(30; "No. Ordre Reparation"; Code[20])
        {
            Caption = 'N° Ordre Réparation';
            DataClassification = CustomerContent;
            TableRelation = "Service Header"."No." where(
        "Document Type" = const(Order));

            trigger OnValidate()
            var
                SvcHdr: Record "Service Header";
                SvcItem: Record "Service Item Line";
            begin
                if "No. Ordre Reparation" = '' then exit;

                if SvcHdr.Get(SvcHdr."Document Type"::Order, "No. Ordre Reparation") then begin
                    // "Name" est le vrai nom du champ dans Service Header BC
                    if "No. Client" = '' then begin
                        "No. Client" := SvcHdr."Customer No.";
                        "Nom Client" := SvcHdr.Name;   // ← "Name", pas "Customer Name"
                    end;

                    // Chercher le véhicule via les lignes de service (Service Item Lines)
                    if "No. Serie Vehicule" = '' then begin
                        SvcItem.Reset();
                        SvcItem.SetRange("Document Type", SvcHdr."Document Type");
                        SvcItem.SetRange("Document No.", SvcHdr."No.");
                        if SvcItem.FindFirst() then
                            "No. Serie Vehicule" := SvcItem."Serial No.";
                        // ← "Serial No." sur Service Item Line, pas Vehicle Serial No.
                    end;
                end;
            end;
        }
        field(31; "No. Facture"; Code[20])
        {
            Caption = 'N° Facture';
            DataClassification = CustomerContent;
            TableRelation = "Sales Invoice Header"."No." where(
        "Sell-to Customer No." = field("No. Client"));

            trigger OnValidate()
            var
                SalesInv: Record "Sales Invoice Header";
            begin
                if "No. Facture" = '' then exit;

                if SalesInv.Get("No. Facture") then
                    if "No. Client" = '' then begin
                        "No. Client" := SalesInv."Sell-to Customer No.";
                        "Nom Client" := SalesInv."Sell-to Customer Name";
                    end;
            end;
        }
        field(32; "No. Series"; Code[20])
        {
            Caption = 'N° Souche';
            DataClassification = CustomerContent;
        }
        field(33; "Date Mise En Cours"; Date)
        {
            Caption = 'Date Mise En Cours';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(34; "Delai En Cours"; Integer)
        {
            Caption = 'Délai En Cours (jours)';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(35; "Hors Delai"; Boolean)
        {
            Caption = 'Hors Délai SLA';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(36; "Nom Agence"; Text[100])
        {
            Caption = 'Nom Agence';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(37; "Notification Envoyee"; Boolean)
        {
            Caption = 'Notification SLA envoyée';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(38; "Etape Workflow"; Option)
        {
            OptionMembers = " ",Ouverture,Qualification,Affectation,Investigation,"Action corrective",Validation,Cloture;
            OptionCaption = ' ,Ouverture,Qualification,Affectation,Investigation,Action corrective,Validation,Clôture';
        }
        field(39; "Modif Par Moteur"; Boolean)
        {
            Caption = 'Modification par moteur workflow';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "No_") { Clustered = true; }
        key(K2; Statut) { }
        key(K3; "No. Client") { }
        key(K4; "Date Creation") { }
        key(K5; Agence) { }
        key(K6; "Code Categorie") { }

    }

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
        HistLine: Record "Rec Workflow History";
    begin
        if "No_" = '' then begin
            "No_" := NoSeries.GetNextNo(GetNoSeriesCode(), Today(), true);
            "No. Series" := GetNoSeriesCode();
        end;
        if "Date Creation" = 0D then
            "Date Creation" := Today();
        if "Attribue A" = '' then
            "Attribue A" := UserId();
        Statut := Statut::Ouverte;
        Priorite := Priorite::Faible;
        "Etape Workflow" := "Etape Workflow"::Ouverture;

        // Tracer la création
        HistLine.Init();
        HistLine."No. Reclamation" := "No_";
        HistLine."Date Heure" := CurrentDateTime();
        HistLine."Etape Precedente" := "Etape Workflow"::Ouverture;
        HistLine."Etape Suivante" := "Etape Workflow"::Ouverture;
        HistLine."Statut Precedent" := Statut::" ";
        HistLine."Statut Suivant" := Statut::Ouverte;
        HistLine."User ID" := UserId();
        HistLine.Commentaire := 'Création de la réclamation';
        HistLine.Insert(false);
    end;

    trigger OnModify()
    var
        HistLine: Record "Rec Workflow History";
    begin
        // Tracer UNIQUEMENT les modifications manuelles
        if not "Modif Par Moteur" then
            if (Statut <> xRec.Statut) or ("Etape Workflow" <> xRec."Etape Workflow") then begin
                HistLine.Init();
                HistLine."No. Reclamation" := "No_";
                HistLine."Date Heure" := CurrentDateTime();
                HistLine."Etape Precedente" := xRec."Etape Workflow";
                HistLine."Etape Suivante" := "Etape Workflow";
                HistLine."Statut Precedent" := xRec.Statut;
                HistLine."Statut Suivant" := Statut;
                HistLine."User ID" := UserId();
                HistLine.Commentaire := 'Modification manuelle';
                HistLine.Insert(false);
            end;

        CalculerDelaiTraitement();
    end;


    local procedure GetNoSeriesCode(): Code[20]
    begin
        exit('RECPFE');
    end;

    procedure CalculerDelaiTraitement()
    var
        RecParam: Record "Rec Parametres";
        SLAJours: Integer;
        DateDebut: Date;
    begin
        // Choisir la date de départ : Prise en Charge si dispo, sinon Création
        if "Date Prise En Charge" <> 0D then
            DateDebut := "Date Prise En Charge"
        else
            DateDebut := "Date Creation";

        if DateDebut <> 0D then begin
            if ("Date Cloture" <> 0D) and (Cloturee) then
                "Delai En Cours" := "Date Cloture" - DateDebut
            else
                "Delai En Cours" := Today() - DateDebut;
        end;

        if ("Date Cloture" <> 0D) and (Cloturee) then
            "Delai Traitement" := "Date Cloture" - DateDebut;

        // SLA configurable
        if RecParam.Get('DEFAULT') then
            SLAJours := RecParam."SLA Jours"
        else
            SLAJours := 7;

        if ("Delai En Cours" > SLAJours) and (not Cloturee) then
            "Hors Delai" := true
        else
            "Hors Delai" := false;
    end;

    procedure NotifierHorsSLA()
    var
        NotifMsg: Text;
        NotifLog: Record "Rec Notification Log";
    begin
        if not "Hors Delai" then exit;
        if Cloturee then exit;
        if "Attribue A" = '' then exit;
        if "Notification Envoyee" then exit;

        NotifMsg := StrSubstNo(
            'ALERTE SLA — Réclamation %1 du %2 dépasse %3 jours. Client : %4 / Agence : %5',
            "No_", "Date Creation", "Delai En Cours", "Nom Client", Agence
        );

        // Insérer dans le log de notifications
        NotifLog.Init();
        NotifLog."No. Reclamation" := "No_";
        NotifLog."Date Heure" := CurrentDateTime();
        NotifLog."Type Notification" := NotifLog."Type Notification"::"Hors SLA";
        NotifLog.Message := CopyStr(NotifMsg, 1, 500);
        NotifLog.Destinataire := "Attribue A";
        NotifLog."No. Client" := "No. Client";
        NotifLog.Processed := false;
        NotifLog.Insert(true);

        Message(NotifMsg);

        "Notification Envoyee" := true;
        Modify(false);
    end;
}