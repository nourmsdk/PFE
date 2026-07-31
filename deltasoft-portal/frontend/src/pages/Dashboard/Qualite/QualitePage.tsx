import { useMemo, useState } from "react";
import { DashboardHeader } from "@/components/dashboard/DashboardHeader";
import { PowerBiNavigator } from "@/components/dashboard/PowerBiNavigator";
import { ShieldCheckIcon } from "@/components/ui/ServiceIcons";
import { ComplianceDonutChart } from "@/components/charts/ComplianceDonutChart";
import { CategoryBarChart } from "@/components/charts/CategoryBarChart";
import { MOCK_COMPLAINTS } from "@/data/mockComplaints";
import type { Complaint } from "@/types/complaint";
import { complianceBadgeClass, complianceLabel } from "@/utils/dashboardBadges";
import styles from "@/styles/dashboard.module.css";

function formatDate(iso: string) {
  return new Date(iso).toLocaleDateString("fr-FR", { day: "2-digit", month: "short" });
}

export function QualitePage() {
  const [complaints, setComplaints] = useState<Complaint[]>(MOCK_COMPLAINTS);

  const resolved = complaints.filter((c) => c.status === "Résolue" || c.status === "Clôturée");

  const kpis = useMemo(() => {
    const checked = resolved.filter((c) => c.qualityCompliant !== null);
    const compliant = resolved.filter((c) => c.qualityCompliant === true).length;
    const nonCompliant = resolved.filter((c) => c.qualityCompliant === false).length;
    const pending = resolved.filter((c) => c.qualityCompliant === null || c.qualityCompliant === undefined).length;
    const rate = checked.length === 0 ? 0 : Math.round((compliant / checked.length) * 100);
    return { rate, nonCompliant, pending, resolvedCount: resolved.length };
  }, [resolved]);

  const alerts = useMemo(() => {
    const counts = new Map<string, number>();
    resolved
      .filter((c) => c.qualityCompliant === false)
      .forEach((c) => counts.set(c.category, (counts.get(c.category) ?? 0) + 1));
    return Array.from(counts.entries()).filter(([, count]) => count >= 1);
  }, [resolved]);

  const complianceChartData = useMemo(
    () => [
      { label: "Conforme", value: resolved.filter((c) => c.qualityCompliant === true).length },
      { label: "Non conforme", value: resolved.filter((c) => c.qualityCompliant === false).length },
      {
        label: "À contrôler",
        value: resolved.filter((c) => c.qualityCompliant === null || c.qualityCompliant === undefined).length,
      },
    ],
    [resolved],
  );

  const categoryChartData = useMemo(
    () => alerts.map(([category, count]) => ({ category, count })),
    [alerts],
  );

  function setCompliance(id: string, compliant: boolean) {
    setComplaints((prev) => prev.map((c) => (c.id === id ? { ...c, qualityCompliant: compliant } : c)));
  }

  return (
    <main className={styles.page}>
      <div className="container">
        <DashboardHeader
          Icon={ShieldCheckIcon}
          title="Espace Responsable Qualité"
          subtitle="Contrôle de conformité et suivi des indicateurs qualité"
        />

        <div className={styles.kpiGrid}>
          <div className={styles.kpiCard}>
            <div className={styles.kpiIcon} aria-hidden="true">📈</div>
            <div>
              <div className={styles.kpiValue}>{kpis.rate}%</div>
              <div className={styles.kpiLabel}>Taux de conformité</div>
            </div>
          </div>
          <div className={styles.kpiCard}>
            <div className={styles.kpiIcon} aria-hidden="true">⚠️</div>
            <div>
              <div className={styles.kpiValue}>{kpis.nonCompliant}</div>
              <div className={styles.kpiLabel}>Non conformes</div>
            </div>
          </div>
          <div className={styles.kpiCard}>
            <div className={styles.kpiIcon} aria-hidden="true">🔍</div>
            <div>
              <div className={styles.kpiValue}>{kpis.pending}</div>
              <div className={styles.kpiLabel}>À contrôler</div>
            </div>
          </div>
          <div className={styles.kpiCard}>
            <div className={styles.kpiIcon} aria-hidden="true">✅</div>
            <div>
              <div className={styles.kpiValue}>{kpis.resolvedCount}</div>
              <div className={styles.kpiLabel}>Résolues / clôturées</div>
            </div>
          </div>
        </div>

        <div style={{ marginBottom: "1.5rem" }}>
          <div className={styles.panelTitle} style={{ marginBottom: "0.75rem" }}>Tableau de bord Power BI</div>
          <PowerBiNavigator role="qualite" />
        </div>

        <div style={{ display: "grid", gridTemplateColumns: alerts.length > 0 ? "1fr 1fr" : "1fr", gap: "1.5rem" }}>
          <div className={styles.panel}>
            <div className={styles.panelHead}>
              <div className={styles.panelTitle}>Taux de conformité</div>
            </div>
            <ComplianceDonutChart data={complianceChartData} />
          </div>

          {alerts.length > 0 && (
            <div className={styles.panel}>
              <div className={styles.panelHead}>
                <div className={styles.panelTitle}>Non-conformités par catégorie</div>
              </div>
              <CategoryBarChart data={categoryChartData} />
            </div>
          )}
        </div>

        {alerts.length > 0 && (
          <div className={styles.panel} style={{ borderColor: "#f3c1bb" }}>
            <div className={styles.panelTitle}>Alertes qualité</div>
            <ul style={{ margin: "0.75rem 0 0", paddingLeft: "1.1rem", color: "var(--gray-700)", fontSize: "var(--fs-sm)" }}>
              {alerts.map(([category, count]) => (
                <li key={category}>
                  {count} réclamation{count > 1 ? "s" : ""} non conforme{count > 1 ? "s" : ""} sur la catégorie{" "}
                  <strong>{category}</strong> — anomalie potentiellement récurrente à surveiller.
                </li>
              ))}
            </ul>
          </div>
        )}

        <div className={styles.panel}>
          <div className={styles.panelHead}>
            <div className={styles.panelTitle}>Réclamations résolues à contrôler</div>
          </div>

          <div className={styles.list}>
            {resolved.map((c) => (
              <div key={c.id} className={styles.listItem}>
                <div className={styles.listRef}>{c.reference}</div>
                <div>
                  <div className={styles.listSubject}>{c.subject}</div>
                  <div className={styles.listClient}>{c.client}</div>
                </div>
                <div className={styles.listMeta}>
                  {c.category} · {formatDate(c.createdAt)}
                </div>
                <span className={complianceBadgeClass(styles, c.qualityCompliant)}>
                  {complianceLabel(c.qualityCompliant)}
                </span>
                <div style={{ display: "flex", gap: "0.4rem" }}>
                  <button
                    type="button"
                    className={styles.statusSelect}
                    onClick={() => setCompliance(c.id, true)}
                  >
                    Conforme
                  </button>
                  <button
                    type="button"
                    className={styles.statusSelect}
                    onClick={() => setCompliance(c.id, false)}
                  >
                    Non conforme
                  </button>
                </div>
              </div>
            ))}
            {resolved.length === 0 && (
              <p style={{ color: "var(--color-text-muted)", fontSize: "var(--fs-sm)" }}>
                Aucune réclamation résolue pour le moment.
              </p>
            )}
          </div>
        </div>
      </div>
    </main>
  );
}
