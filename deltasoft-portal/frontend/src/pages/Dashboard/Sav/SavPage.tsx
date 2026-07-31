import { useMemo, useState } from "react";
import { DashboardHeader } from "@/components/dashboard/DashboardHeader";
import { PowerBiNavigator } from "@/components/dashboard/PowerBiNavigator";
import { WrenchIcon } from "@/components/ui/ServiceIcons";
import { StatusBarChart } from "@/components/charts/StatusBarChart";
import { MOCK_COMPLAINTS } from "@/data/mockComplaints";
import type { Complaint, ComplaintStatus } from "@/types/complaint";
import { priorityBadgeClass } from "@/utils/dashboardBadges";
import styles from "@/styles/dashboard.module.css";

const STATUS_OPTIONS: ComplaintStatus[] = ["Nouvelle", "En cours", "Résolue", "Clôturée"];

function formatDate(iso: string) {
  return new Date(iso).toLocaleDateString("fr-FR", { day: "2-digit", month: "short" });
}

export function SavPage() {
  const [complaints, setComplaints] = useState<Complaint[]>(MOCK_COMPLAINTS);
  const [statusFilter, setStatusFilter] = useState<string>("all");
  const [search, setSearch] = useState("");

  const kpis = useMemo(() => {
    const enCours = complaints.filter((c) => c.status === "En cours").length;
    const nouvelles = complaints.filter((c) => c.status === "Nouvelle").length;
    const urgentes = complaints.filter((c) => c.priority === "Urgente").length;
    const resolues = complaints.filter((c) => c.status === "Résolue" || c.status === "Clôturée").length;
    return { enCours, nouvelles, urgentes, resolues };
  }, [complaints]);

  const statusChartData = useMemo(
    () =>
      STATUS_OPTIONS.map((status) => ({
        status,
        count: complaints.filter((c) => c.status === status).length,
      })),
    [complaints],
  );

  const filtered = complaints.filter((c) => {
    const matchesStatus = statusFilter === "all" || c.status === statusFilter;
    const query = search.trim().toLowerCase();
    const matchesSearch =
      !query ||
      c.subject.toLowerCase().includes(query) ||
      c.client.toLowerCase().includes(query) ||
      c.reference.toLowerCase().includes(query);
    return matchesStatus && matchesSearch;
  });

  function updateStatus(id: string, status: ComplaintStatus) {
    setComplaints((prev) => prev.map((c) => (c.id === id ? { ...c, status } : c)));
  }

  return (
    <main className={styles.page}>
      <div className="container">
        <DashboardHeader
          Icon={WrenchIcon}
          title="Espace Responsable SAV"
          subtitle="Suivi et pilotage des interventions en cours"
        />

        <div className={styles.kpiGrid}>
          <div className={styles.kpiCard}>
            <div className={styles.kpiIcon} aria-hidden="true">🆕</div>
            <div>
              <div className={styles.kpiValue}>{kpis.nouvelles}</div>
              <div className={styles.kpiLabel}>Nouvelles réclamations</div>
            </div>
          </div>
          <div className={styles.kpiCard}>
            <div className={styles.kpiIcon} aria-hidden="true">⏳</div>
            <div>
              <div className={styles.kpiValue}>{kpis.enCours}</div>
              <div className={styles.kpiLabel}>Interventions en cours</div>
            </div>
          </div>
          <div className={styles.kpiCard}>
            <div className={styles.kpiIcon} aria-hidden="true">🔥</div>
            <div>
              <div className={styles.kpiValue}>{kpis.urgentes}</div>
              <div className={styles.kpiLabel}>Priorité urgente</div>
            </div>
          </div>
          <div className={styles.kpiCard}>
            <div className={styles.kpiIcon} aria-hidden="true">✅</div>
            <div>
              <div className={styles.kpiValue}>{kpis.resolues}</div>
              <div className={styles.kpiLabel}>Résolues / clôturées</div>
            </div>
          </div>
        </div>

        <div style={{ marginBottom: "1.5rem" }}>
          <div className={styles.panelTitle} style={{ marginBottom: "0.75rem" }}>Tableau de bord Power BI</div>
          <PowerBiNavigator role="sav" />
        </div>

        <div className={styles.panel}>
          <div className={styles.panelHead}>
            <div className={styles.panelTitle}>Répartition par statut</div>
          </div>
          <StatusBarChart data={statusChartData} />
        </div>

        <div className={styles.panel}>
          <div className={styles.panelHead}>
            <div className={styles.panelTitle}>Réclamations</div>
            <div className={styles.filterBar}>
              <input
                type="text"
                className={styles.searchInput}
                placeholder="Rechercher (client, sujet, référence)"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
              />
              <select
                className={styles.filterSelect}
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
              >
                <option value="all">Tous les statuts</option>
                {STATUS_OPTIONS.map((status) => (
                  <option key={status} value={status}>
                    {status}
                  </option>
                ))}
              </select>
            </div>
          </div>

          <div className={styles.list}>
            {filtered.map((c) => (
              <div key={c.id} className={styles.listItem}>
                <div className={styles.listRef}>{c.reference}</div>
                <div>
                  <div className={styles.listSubject}>{c.subject}</div>
                  <div className={styles.listClient}>{c.client}</div>
                </div>
                <div className={styles.listMeta}>
                  {c.category} · {formatDate(c.createdAt)}
                </div>
                <span className={priorityBadgeClass(styles, c.priority)}>{c.priority}</span>
                <select
                  className={styles.statusSelect}
                  value={c.status}
                  onChange={(e) => updateStatus(c.id, e.target.value as ComplaintStatus)}
                >
                  {STATUS_OPTIONS.map((status) => (
                    <option key={status} value={status}>
                      {status}
                    </option>
                  ))}
                </select>
              </div>
            ))}
            {filtered.length === 0 && (
              <p style={{ color: "var(--color-text-muted)", fontSize: "var(--fs-sm)" }}>
                Aucune réclamation ne correspond à ces critères.
              </p>
            )}
          </div>
        </div>
      </div>
    </main>
  );
}
