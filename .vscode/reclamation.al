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
        }
        field(4; VIN; Code[20])
        {
            Caption = 'VIN';
            DataClassification = CustomerContent;
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
        }
        field(7; "No. Telephone 2"; Text[20])
        {
            Caption = 'N° Téléphone 2';
            DataClassification = CustomerContent;
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
            begin
                if Cust.Get("No. Client") then
                    "Nom Client" := Cust.Name
                else
                    "Nom Client" := '';
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
        }
        field(31; "No. Facture"; Code[20])
        {
            Caption = 'N° Facture';
            DataClassification = CustomerContent;
        }
        field(32; "No. Series"; Code[20])
        {
            Caption = 'N° Souche';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No_")
        {
            Clustered = true;
        }
        key(K2; Statut) { }
        key(K3; "No. Client") { }
        key(K4; "Date Creation") { }
    }

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
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
    end;

    trigger OnModify()
    begin
        if ("Date Cloture" <> 0D) and ("Date Creation" <> 0D) then
            "Delai Traitement" := "Date Cloture" - "Date Creation";
    end;

    local procedure GetNoSeriesCode(): Code[20]
    begin
        exit('RECPFE');
    end;
}