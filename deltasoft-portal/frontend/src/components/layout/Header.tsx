import { useEffect, useState } from "react";
import { Link, useLocation } from "react-router-dom";
import logo from "@/assets/logo-deltasoft.png";
import styles from "./Header.module.css";

const TOOLS_SUBMENU = [
  { label: "Assistant IA", href: "#chatbot" },
  { label: "Tableaux de bord", href: "#dashboards" },
  { label: "Machine Learning", href: "#ml" },
];

const SECTION_IDS = ["apropos", "solutions", "services", "contact"];

export function Header() {
  const location = useLocation();
  const isHome = location.pathname === "/";
  const [scrolled, setScrolled] = useState(!isHome);
  const [mobileOpen, setMobileOpen] = useState(false);
  const [activeSection, setActiveSection] = useState<string | null>(null);

  useEffect(() => {
    if (!isHome) {
      setScrolled(true);
      return;
    }

    const OFFSET = 140;

    function onScroll() {
      setScrolled(window.scrollY > 40);

      let current: string | null = null;
      for (const id of SECTION_IDS) {
        const el = document.getElementById(id);
        if (el && el.getBoundingClientRect().top <= OFFSET) {
          current = id;
        }
      }
      setActiveSection(current);
    }

    onScroll();
    window.addEventListener("scroll", onScroll);
    return () => window.removeEventListener("scroll", onScroll);
  }, [isHome]);

  useEffect(() => {
    setMobileOpen(false);
  }, [location.pathname]);

  const transparent = isHome && !scrolled && !mobileOpen;
  const isAccueilActive = isHome && activeSection === null;

  function linkClass(active: boolean) {
    return `${styles.navLink} ${active ? styles.navLinkActive : ""}`;
  }

  return (
    <header className={`${styles.header} ${transparent ? styles.transparent : ""}`}>
      <div className={`container ${styles.inner}`}>
        <Link to="/" className={styles.logo}>
          <img src={logo} alt="DeltaSoft International" className={styles.logoImg} />
        </Link>

        <nav className={styles.nav} aria-label="Navigation principale">
          <Link to="/" className={linkClass(isAccueilActive)}>
            Accueil
          </Link>
          <a href="#apropos" className={linkClass(activeSection === "apropos")}>
            À propos
          </a>

          <div className={styles.navItem}>
            <a href="#solutions" className={linkClass(activeSection === "solutions")}>
              Nos outils <span className={styles.caret}>▾</span>
            </a>
            <div className={styles.submenu}>
              {TOOLS_SUBMENU.map((item) => (
                <a key={item.href} href={item.href} className={styles.submenuLink}>
                  {item.label}
                </a>
              ))}
            </div>
          </div>

          <a href="#services" className={linkClass(activeSection === "services")}>
            Services
          </a>
          <a href="#contact" className={linkClass(activeSection === "contact")}>
            Contact
          </a>
        </nav>

        <div className={styles.actions}>
          <Link to="/login" className={styles.loginButton}>
            Se connecter
          </Link>

          <button
            type="button"
            className={`${styles.burger} ${mobileOpen ? styles.burgerOpen : ""}`}
            aria-label="Ouvrir le menu"
            aria-expanded={mobileOpen}
            onClick={() => setMobileOpen((open) => !open)}
          >
            <span />
            <span />
            <span />
          </button>
        </div>
      </div>

      {mobileOpen && (
        <div className={styles.mobilePanel}>
          <Link to="/" className={styles.mobileLink} onClick={() => setMobileOpen(false)}>
            Accueil
          </Link>
          <a href="#apropos" className={styles.mobileLink} onClick={() => setMobileOpen(false)}>
            À propos
          </a>
          <div className={styles.mobileGroupLabel}>Nos outils</div>
          {TOOLS_SUBMENU.map((item) => (
            <a
              key={item.href}
              href={item.href}
              className={styles.mobileSublink}
              onClick={() => setMobileOpen(false)}
            >
              {item.label}
            </a>
          ))}
          <a href="#services" className={styles.mobileLink} onClick={() => setMobileOpen(false)}>
            Services
          </a>
          <a href="#contact" className={styles.mobileLink} onClick={() => setMobileOpen(false)}>
            Contact
          </a>
          <Link to="/login" className={styles.mobileLoginButton} onClick={() => setMobileOpen(false)}>
            Se connecter
          </Link>
        </div>
      )}
    </header>
  );
}
