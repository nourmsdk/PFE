report 65040 "Rec Rapport Cloture"
{
    Caption = 'Rapport de Clôture Réclamation';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './src/report/RecRapportCloture.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(Reclamation; Reclamation)
        {
            RequestFilterFields = "No_";

            column(No_; "No_") { }
            column(Description; Description) { }
            column(NomClient; "Nom Client") { }
            column(NoClient; "No. Client") { }
            column(NoTelephone; "No. Telephone") { }
            column(NoSerieVehicule; "No. Serie Vehicule") { }
            column(VIN; VIN) { }
            column(Agence; Agence) { }
            column(NomAgence; "Nom Agence") { }
            column(DateCreation; Format("Date Creation")) { }
            column(DatePriseEnCharge; Format("Date Prise En Charge")) { }
            column(DateCloture; Format("Date Cloture")) { }
            column(DelaiTraitement; Format("Delai Traitement")) { }
            column(Statut; Format(Statut)) { }
            column(Gravite; Format(Gravite)) { }
            column(Priorite; Format(Priorite)) { }
            column(Responsabilite; Format(Responsabilite)) { }
            column(Canal; Format(Canal)) { }
            column(TypeReclamation; Format("Type Reclamation")) { }
            column(CodeCategorie; "Code Categorie") { }
            column(DescriptionCategorie; "Description Categorie") { }
            column(CodeSousCategorie; "Code Sous Categorie") { }
            column(DescriptionSousCategorie; "Description Sous Categorie") { }
            column(DescriptionActionPrise; "Description Action Prise") { }
            column(RetourClient; Format("Retour Client")) { }
            column(AttribueA; "Attribue A") { }
            column(HorsDelai; Format("Hors Delai")) { }
            column(CompanyPicture; CompanyInfo.Picture) { }

            dataitem(RecActionCorrective; "Rec Action Corrective")
            {
                DataItemLink = "No Reclamation" = field("No_");
                DataItemTableView = sorting("No Reclamation", "No Ligne");

                column(ActDescription; Description) { }
                column(ActResponsable; Responsable) { }
                column(ActDatePrevue; Format("Date Prevue")) { }
                column(ActDateRealisee; Format("Date Realisee")) { }
                column(ActStatut; Format(Statut)) { }
                column(ActCommentaire; Commentaire) { }
                column(ActDelaiRealisation; Format("Delai Realisation")) { }
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    trigger OnPreReport()
    begin
        if Reclamation.GetFilter("No_") = '' then
            Error('Sélectionnez une réclamation avant de lancer le rapport.');
    end;

    var
        CompanyInfo: Record "Company Information";
}
