import type { ComplaintPriority, ComplaintStatus } from "@/types/complaint";

type StyleMap = Record<string, string>;

const PRIORITY_KEY: Record<ComplaintPriority, string> = {
  Basse: "badgePriorityBasse",
  Normale: "badgePriorityNormale",
  Haute: "badgePriorityHaute",
  Urgente: "badgePriorityUrgente",
};

const STATUS_KEY: Record<ComplaintStatus, string> = {
  Nouvelle: "badgeStatusNouvelle",
  "En cours": "badgeStatusEnCours",
  Résolue: "badgeStatusRésolue",
  Clôturée: "badgeStatusClôturée",
};

export function priorityBadgeClass(styles: StyleMap, priority: ComplaintPriority) {
  return `${styles.badge} ${styles[PRIORITY_KEY[priority]]}`;
}

export function statusBadgeClass(styles: StyleMap, status: ComplaintStatus) {
  return `${styles.badge} ${styles[STATUS_KEY[status]]}`;
}

export function complianceBadgeClass(styles: StyleMap, compliant: boolean | null | undefined) {
  if (compliant === true) return `${styles.badge} ${styles.badgeCompliant}`;
  if (compliant === false) return `${styles.badge} ${styles.badgeNonCompliant}`;
  return `${styles.badge} ${styles.badgePending}`;
}

export function complianceLabel(compliant: boolean | null | undefined) {
  if (compliant === true) return "Conforme";
  if (compliant === false) return "Non conforme";
  return "À contrôler";
}
