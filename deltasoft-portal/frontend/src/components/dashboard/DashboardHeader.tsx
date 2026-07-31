import type { ComponentType } from "react";
import { Link } from "react-router-dom";
import styles from "@/styles/dashboard.module.css";

export function DashboardHeader({
  Icon,
  title,
  subtitle,
}: {
  Icon: ComponentType<{ size?: number }>;
  title: string;
  subtitle: string;
}) {
  return (
    <div className={styles.head}>
      <div className={styles.headLeft}>
        <div className={styles.icon}>
          <Icon size={26} />
        </div>
        <div>
          <h1 className={styles.title}>{title}</h1>
          <p className={styles.subtitle}>{subtitle}</p>
        </div>
      </div>
      <Link to="/" className={styles.logout}>
        Déconnexion
      </Link>
    </div>
  );
}
