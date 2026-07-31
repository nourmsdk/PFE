import type { ComplaintCategory, ComplaintPriority } from "@/types/complaint";

export interface ClassificationResult {
  category: ComplaintCategory;
  priority: ComplaintPriority;
  note: string;
}

const CATEGORY_KEYWORDS: Array<{ category: ComplaintCategory; keywords: string[] }> = [
  { category: "Facturation", keywords: ["facture", "tva", "paiement", "montant", "prix"] },
  { category: "Livraison", keywords: ["livraison", "retard", "colis", "livré", "expédition"] },
  { category: "Matériel", keywords: ["écran", "lecteur", "imprimante", "terminal", "matériel", "caisse", "scanner"] },
  { category: "Logiciel", keywords: ["bug", "erreur", "bloqu", "figé", "connexion", "module", "logiciel", "application", "planté"] },
];

const URGENT_KEYWORDS = ["urgent", "bloqu", "impossible de travailler", "arrêt total", "plus aucun"];
const HIGH_KEYWORDS = ["important", "rapidement", "plusieurs fois", "répété"];

export function classifyComplaint(text: string): ClassificationResult {
  const normalized = text.toLowerCase();

  const match = CATEGORY_KEYWORDS.find(({ keywords }) =>
    keywords.some((keyword) => normalized.includes(keyword)),
  );
  const category: ComplaintCategory = match?.category ?? "Autre";

  let priority: ComplaintPriority = "Normale";
  if (URGENT_KEYWORDS.some((keyword) => normalized.includes(keyword))) {
    priority = "Urgente";
  } else if (HIGH_KEYWORDS.some((keyword) => normalized.includes(keyword))) {
    priority = "Haute";
  } else if (normalized.length < 40) {
    priority = "Basse";
  }

  const note = `Classée en "${category}" avec une priorité "${priority}" d'après les mots-clés détectés.`;

  return { category, priority, note };
}
