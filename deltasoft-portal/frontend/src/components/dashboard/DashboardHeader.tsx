import type { ComponentType } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";
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
  const navigate = useNavigate();
  const { logout } = useAuth();

  function handleLogout() {
    logout();
    navigate("/");
  }

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
      <button type="button" className={styles.logout} onClick={handleLogout}>
        Déconnexion
      </button>
    </div>
  );
}
