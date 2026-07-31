import { POWERBI_ACCESS, POWERBI_PAGES, powerBiServiceUrl } from "@/data/powerbiPages";
import type { DecisionRole } from "@/types/auth";
import styles from "./PowerBiNavigator.module.css";

export function PowerBiNavigator({ role }: { role: DecisionRole }) {
  const access = POWERBI_ACCESS[role];
  const cards = access
    .map((entry) => {
      const page = POWERBI_PAGES.find((p) => p.id === entry.pageId);
      if (!page) return null;
      return { ...page, lightened: entry.lightened, serviceUrl: powerBiServiceUrl(page) };
    })
    .filter((p): p is NonNullable<typeof p> => p !== null);

  return (
    <div className={styles.wrap}>
      <p className={styles.hint}>
        Ces rapports s'ouvrent dans Power BI (connexion Microsoft requise). Clique sur une page pour l'ouvrir dans un
        nouvel onglet.
      </p>

      <div className={styles.grid}>
        {cards.map((card) => (
          <a
            key={card.id}
            href={card.serviceUrl}
            target="_blank"
            rel="noopener noreferrer"
            className={styles.card}
          >
            <span className={styles.cardIcon} aria-hidden="true">📊</span>
            <span className={styles.cardBody}>
              <span className={styles.cardTitle}>
                {card.label}
                {card.lightened && <span className={styles.cardBadge}>allégée</span>}
              </span>
              <span className={styles.cardLink}>Ouvrir dans Power BI ↗</span>
            </span>
          </a>
        ))}
      </div>
    </div>
  );
}
