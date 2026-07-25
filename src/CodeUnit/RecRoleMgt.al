codeunit 65002 "Rec Role Mgt"
{
    procedure GetCurrentUserRole(): Enum "Rec Role"
    var
        RoleSetup: Record "Rec Role Setup";
    begin
        RoleSetup.SetRange("User ID", UserId());
        RoleSetup.SetRange(Actif, true);
        if RoleSetup.FindFirst() then
            exit(RoleSetup.Role);
        exit("Rec Role"::" ");
    end;

    procedure IsAdmin(): Boolean
    begin
        exit(GetCurrentUserRole() = "Rec Role"::Admin);
    end;

    procedure IsReceptionnaire(): Boolean
    begin
        exit(GetCurrentUserRole() = "Rec Role"::ReceptionnaireSAV);
    end;

    procedure IsResponsableSAV(): Boolean
    begin
        exit(GetCurrentUserRole() = "Rec Role"::ResponsableSAV);
    end;

    procedure IsResponsableQualite(): Boolean
    begin
        exit(GetCurrentUserRole() = "Rec Role"::ResponsableQualite);
    end;

    // ── Groupes d'autorisation utilisés côté fiche réclamation ─────────────
    procedure IsReceptionnaireOuSAV(): Boolean
    begin
        exit(IsReceptionnaire() or IsResponsableSAV() or IsAdmin());
    end;

    procedure IsSAV(): Boolean
    begin
        exit(IsResponsableSAV() or IsAdmin());
    end;

    procedure IsQualite(): Boolean
    begin
        exit(IsResponsableQualite() or IsAdmin());
    end;

    // ── Gardes serveur : lèvent une erreur bloquante, indépendantes de l'UI ─
    procedure EnsureReceptionnaireOuSAV(ActionDesc: Text)
    begin
        if not IsReceptionnaireOuSAV() then
            Error(
                'Action non autorisée : "%1" nécessite le rôle Réceptionnaire SAV ou Responsable SAV.\Votre rôle actuel : %2.',
                ActionDesc, Format(GetCurrentUserRole()));
    end;

    procedure EnsureSAV(ActionDesc: Text)
    begin
        if not IsSAV() then
            Error(
                'Action non autorisée : "%1" nécessite le rôle Responsable SAV.\Votre rôle actuel : %2.',
                ActionDesc, Format(GetCurrentUserRole()));
    end;

    procedure EnsureQualite(ActionDesc: Text)
    begin
        if not IsQualite() then
            Error(
                'Action non autorisée : "%1" nécessite le rôle Responsable Qualité.\Votre rôle actuel : %2.',
                ActionDesc, Format(GetCurrentUserRole()));
    end;
}
