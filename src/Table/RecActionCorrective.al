table 65012 "Rec Action Corrective"
{
    DataClassification = CustomerContent;
    Caption = 'Action Corrective';

    fields
    {
        field(1; "No Ligne"; Integer)
        {
            Caption = 'N° Ligne';
            AutoIncrement = true;
        }
        field(2; "No Reclamation"; Code[20])
        {
            Caption = 'N° Réclamation';
            TableRelation = "Reclamation"."No_";
            NotBlank = true;
        }
        field(3; "Description"; Text[250])
        {
            Caption = 'Description de l''action';
            NotBlank = true;
        }
        field(4; "Responsable"; Code[50])
        {
            Caption = 'Responsable';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(5; "Date Prevue"; Date)
        {
            Caption = 'Date prévue';
        }
        field(6; "Date Realisee"; Date)
        {
            Caption = 'Date réalisée';

            trigger OnValidate()
            begin
                // Si date réalisée remplie → passer automatiquement à Terminée
                if "Date Realisee" <> 0D then
                    Statut := "Statut Action Corrective"::Terminee;
                CalculerDelaiEtRetard();
            end;
        }
        field(7; "Statut"; Enum "Statut Action Corrective")
        {
            Caption = 'Statut';

            trigger OnValidate()
            begin
                CalculerDelaiEtRetard();
            end;
        }
        field(8; "Commentaire"; Text[500])
        {
            Caption = 'Commentaire / Résultat';
        }
        field(9; "Delai Realisation"; Integer)
        {
            Caption = 'Délai réalisation (jours)';
            Editable = false;
        }
        field(10; "Indicateur Retard"; Boolean)
        {
            Caption = 'En retard';
            Editable = false;
        }
        field(11; "Jours Restants"; Integer)
        {
            Caption = 'Jours restants';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(12; "Genere Automatiquement"; Boolean)
        {
            Caption = 'Généré Automatiquement';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No Ligne") { Clustered = true; }
        key(K1; "No Reclamation") { }
        key(K2; "No Reclamation", "Statut") { }
    }

    trigger OnInsert()
    begin
        CalculerDelaiEtRetard();
    end;

    trigger OnModify()
    begin
        CalculerDelaiEtRetard();
    end;

    procedure CalculerDelaiEtRetard()
    begin
        // Calcul délai réalisation (écart entre date prévue et date réalisée)
        if ("Date Realisee" <> 0D) and ("Date Prevue" <> 0D) then
            "Delai Realisation" := "Date Realisee" - "Date Prevue"
        else
            "Delai Realisation" := 0;

        // Indicateur retard + Jours restants selon statut
        case Statut of
            "Statut Action Corrective"::Terminee:
                begin
                    "Indicateur Retard" := "Delai Realisation" > 0;
                    "Jours Restants" := 0;
                end;
            "Statut Action Corrective"::Annulee:
                begin
                    "Indicateur Retard" := false;
                    "Jours Restants" := 0;
                end;
            else
                // Statut vide, Planifiée ou En cours
                if "Date Prevue" <> 0D then begin
                    "Indicateur Retard" := Today() > "Date Prevue";
                    "Jours Restants" := "Date Prevue" - Today();
                end else begin
                    "Indicateur Retard" := false;
                    "Jours Restants" := 0;
                end;
        end;
    end;

    procedure RecalculerToutesLesLignes(NoRec: Code[20])
    var
        ActionCorr: Record "Rec Action Corrective";
    begin
        ActionCorr.Reset();
        ActionCorr.SetRange("No Reclamation", NoRec);
        if ActionCorr.FindSet(true) then
            repeat
                ActionCorr.CalculerDelaiEtRetard();
                ActionCorr.Modify(false);
            until ActionCorr.Next() = 0;
    end;
}