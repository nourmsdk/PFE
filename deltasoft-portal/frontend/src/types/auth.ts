import type { ComponentType } from "react";
import { InboxIcon, WrenchIcon, ShieldCheckIcon } from "@/components/ui/ServiceIcons";

export type DecisionRole = "reception" | "sav" | "qualite";
export type RoleAccent = "blue" | "amber" | "green";

export interface RoleProfile {
  id: DecisionRole;
  title: string;
  description: string;
  Icon: ComponentType<{ size?: number }>;
  accent: RoleAccent;
}

export const ROLE_PROFILES: RoleProfile[] = [
  {
    id: "reception",
    title: "Réceptionnaire SAV",
    description: "Enregistre et qualifie les réclamations clients à leur arrivée.",
    Icon: InboxIcon,
    accent: "blue",
  },
  {
    id: "sav",
    title: "Responsable SAV",
    description: "Pilote le traitement et le suivi des interventions.",
    Icon: WrenchIcon,
    accent: "amber",
  },
  {
    id: "qualite",
    title: "Responsable Qualité",
    description: "Contrôle la conformité et la qualité de service.",
    Icon: ShieldCheckIcon,
    accent: "green",
  },
];
