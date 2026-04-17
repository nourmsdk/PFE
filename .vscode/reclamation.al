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
        }
        field(9; "Description Categorie"; Text[100])
        {
            Caption = 'Description Catégorie';
            DataClassification = CustomerContent;
        }
        field(10; "Code Sous Categorie"; Code[20])
        {
            Caption = 'Code Sous-Catégorie';
            DataClassification = CustomerContent;
        }
        field(11; "Description Sous Categorie"; Text[100])
        {
            Caption = 'Description Sous-Catégorie';
            DataClassification = CustomerContent;
        }
        field(12; "Groupe Utilisateur"; Code[20])
        {
            Caption = 'Groupe Utilisateur';
            DataClassification = CustomerContent;
        }
        field(13; "Attribue A"; Code[50])
        {
            Caption = 'Attribué à';
            DataClassification = CustomerContent;
            TableRelation = User."User Name";
        }
        field(14; "Centre Gestion"; Code[20])
        {
            Caption = 'Centre de Gestion';
            DataClassification = CustomerContent;
        }
        field(15; "Date Creation"; Date)
        {
            Caption = 'Date Création';
            DataClassification = CustomerContent;
        }
        field(16; Priorite; Option)
        {
            Caption = 'Priorité';
            DataClassification = CustomerContent;
            OptionMembers = " ",Faible,Moyenne,Haute;
            OptionCaption = ' ,Faible,Moyenne,Haute';
        }
        field(17; Statut; Option)
        {
            Caption = 'Statut';
            DataClassification = CustomerContent;
            OptionMembers = " ","Ouverte","Prise en charge","En cours","Cloturee";
            OptionCaption = ' ,Ouverte,Prise en charge,En cours,Clôturée';
        }
        field(18; "Description Action Prise"; Text[250])
        {
            Caption = 'Description Action Prise';
            DataClassification = CustomerContent;
        }
        field(19; "Date Prise En Charge"; Date)
        {
            Caption = 'Date de Prise en Charge';
            DataClassification = CustomerContent;
        }
        field(20; "Date Validite"; Date)
        {
            Caption = 'Date Validité';
            DataClassification = CustomerContent;
        }
        field(21; "Date Cloture"; Date)
        {
            Caption = 'Date Clôture';
            DataClassification = CustomerContent;
        }
        field(22; "Cloture Sans Action"; Boolean)
        {
            Caption = 'Clôture sans Action';
            DataClassification = CustomerContent;
        }
        field(23; Cloturee; Boolean)
        {
            Caption = 'Clôturée';
            DataClassification = CustomerContent;
        }
        field(24; "Retour Client"; Option)
        {
            Caption = 'Retour Client';
            DataClassification = CustomerContent;
            OptionMembers = " ",Satisfait,Insatisfait,"Sans retour";
            OptionCaption = ' ,Satisfait,Insatisfait,Sans retour';
        }
        field(25; "Commande Service"; Code[20])
        {
            Caption = 'Commande Service';
            DataClassification = CustomerContent;
        }
        field(26; "Commande Service Enregistre"; Code[20])
        {
            Caption = 'Commande Service Enregistré';
            DataClassification = CustomerContent;
        }
        field(27; "No. Series"; Code[20])
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
    end;

    local procedure GetNoSeriesCode(): Code[20]
    begin
        exit('RECPFE');
    end;
}