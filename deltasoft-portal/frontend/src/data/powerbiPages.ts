import type { DecisionRole } from "@/types/auth";

export type PowerBiPageId =
  | "accueil"
  | "pilotage"
  | "portefeuille"
  | "ficheClient"
  | "analyseVehicules"
  | "ficheVehicule"
  | "performancesAgences"
  | "performanceAgents"
  | "sla";

export interface PowerBiPage {
  id: PowerBiPageId;
  label: string;
  sectionId: string;
}

const GROUP_ID = "1fdb4d0a-74e9-4939-9b1f-a55faeb7b6da";
const REPORT_ID = "a354ab36-7660-40c7-9a75-a0877b189151";

export const POWERBI_PAGES: PowerBiPage[] = [
  { id: "accueil", label: "Page d'accueil", sectionId: "a7de1777c081daff5b80" },
  { id: "pilotage", label: "Pilotage global", sectionId: "b5499bb71151805f832e" },
  { id: "portefeuille", label: "Portefeuille clients", sectionId: "ab81f7d7bcd0e2da36d4" },
  { id: "ficheClient", label: "Fiche client", sectionId: "c130fe0cb5de6b541098" },
  { id: "analyseVehicules", label: "Analyse véhicules", sectionId: "10fcb87a331c81b879ee" },
  { id: "ficheVehicule", label: "Fiche véhicule", sectionId: "3e50b164e3597ccb6272" },
  { id: "performancesAgences", label: "Performances agences", sectionId: "0dcaee77ac76835f961e" },
  { id: "performanceAgents", label: "Performance agents", sectionId: "30426aa0c73bd187179e" },
  { id: "sla", label: "SLA", sectionId: "a640921938511f9d9849" },
];

/** The normal Power BI Service browsing URL. */
export function powerBiServiceUrl(page: PowerBiPage): string {
  return `https://app.powerbi.com/groups/${GROUP_ID}/reports/${REPORT_ID}/${page.sectionId}?experience=power-bi`;
}

/**
 * "lightened" = same page, flagged in the UI as a reduced view for reception
 * (no dedicated lightened report page was provided).
 */
export const POWERBI_ACCESS: Record<DecisionRole, { pageId: PowerBiPageId; lightened?: boolean }[]> = {
  reception: [
    { pageId: "accueil" },
    { pageId: "portefeuille", lightened: true },
    { pageId: "ficheClient" },
    { pageId: "ficheVehicule" },
  ],
  sav: [
    { pageId: "accueil" },
    { pageId: "pilotage" },
    { pageId: "portefeuille" },
    { pageId: "ficheClient" },
    { pageId: "analyseVehicules" },
    { pageId: "ficheVehicule" },
    { pageId: "performancesAgences" },
    { pageId: "performanceAgents" },
    { pageId: "sla" },
  ],
  qualite: [
    { pageId: "accueil" },
    { pageId: "pilotage" },
    { pageId: "portefeuille" },
    { pageId: "ficheClient" },
    { pageId: "analyseVehicules" },
    { pageId: "ficheVehicule" },
    { pageId: "performancesAgences" },
    { pageId: "performanceAgents" },
    { pageId: "sla" },
  ],
};
