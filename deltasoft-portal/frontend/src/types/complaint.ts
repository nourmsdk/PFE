export type ComplaintCategory = "Matériel" | "Logiciel" | "Livraison" | "Facturation" | "Autre";
export type ComplaintPriority = "Basse" | "Normale" | "Haute" | "Urgente";
export type ComplaintStatus = "Nouvelle" | "En cours" | "Résolue" | "Clôturée";

export interface Complaint {
  id: string;
  reference: string;
  client: string;
  subject: string;
  description: string;
  category: ComplaintCategory;
  priority: ComplaintPriority;
  status: ComplaintStatus;
  createdAt: string;
  assignedTo?: string;
  qualityCompliant?: boolean | null;
}
