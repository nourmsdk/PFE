import { useState } from "react";
import { flushSync } from "react-dom";
import type { FormEvent } from "react";
import { useNavigate } from "react-router-dom";
import { Reveal } from "@/components/ui/Reveal";
import { MicrosoftLogo } from "@/components/ui/MicrosoftLogo";
import { useAuth } from "@/context/AuthContext";
import { login } from "@/services/auth";
import { ROLE_PROFILES } from "@/types/auth";
import type { DecisionRole, RoleProfile } from "@/types/auth";
import logo from "@/assets/logo-deltasoft.png";
import styles from "./LoginPage.module.css";

const CHART_BARS = [38, 62, 48, 82, 58, 70];

export function LoginPage() {
  const navigate = useNavigate();
  const { setSession } = useAuth();
  const [selectedRole, setSelectedRole] = useState<RoleProfile | null>(null);
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setError("");

    if (!username.trim() || !password.trim()) {
      setError("Veuillez renseigner votre identifiant et votre mot de passe.");
      return;
    }

    if (!selectedRole) {
      return;
    }

    setSubmitting(true);
    try {
      const result = await login(username.trim(), password);

      if (result.role !== selectedRole.id) {
        setError(
          `Ce compte correspond au profil "${result.full_name}". Reviens en arrière et sélectionne ce profil.`,
        );
        return;
      }

      flushSync(() => {
        setSession({
          token: result.access_token,
          role: result.role as DecisionRole,
          fullName: result.full_name,
        });
      });
      navigate(`/espace/${result.role}`);
    } catch {
      setError("Identifiant ou mot de passe incorrect.");
    } finally {
      setSubmitting(false);
    }
  }

  function handleBack() {
    setSelectedRole(null);
    setUsername("");
    setPassword("");
    setShowPassword(false);
    setError("");
  }

  return (
    <main className={styles.page}>
      <div className={styles.split}>
        {/* Left branding panel */}
        <div className={styles.brandPanel}>
          <div className={styles.blobOne} aria-hidden="true" />
          <div className={styles.blobTwo} aria-hidden="true" />

          <div className={styles.brandInner}>
            <img src={logo} alt="DeltaSoft International" className={styles.brandLogo} />

            <h1 className={styles.brandTitle}>
              L'intelligence
              <br />
              au service de <span>votre SAV</span>
            </h1>
            <p className={styles.brandText}>
              Portail SAV &amp; Qualité DeltaSoft — réclamations, tableaux de
              bord et intelligence artificielle réunis pour accélérer vos
              décisions.
            </p>
          </div>

          <div className={styles.dashboardMock} aria-hidden="true">
            <div className={styles.mockHeader}>
              <span />
              <span />
              <span />
            </div>
            <div className={styles.mockStats}>
              <div className={styles.mockStat}>
                <strong>128</strong>
                <span>Réclamations</span>
              </div>
              <div className={styles.mockStat}>
                <strong>96%</strong>
                <span>Conformité</span>
              </div>
            </div>
            <div className={styles.mockChart}>
              {CHART_BARS.map((h, i) => (
                <span key={i} style={{ height: `${h}%` }} />
              ))}
            </div>
          </div>
        </div>

        {/* Right auth panel */}
        <div className={styles.authPanel}>
          <div className={styles.authInner}>
            {!selectedRole ? (
              <>
                <Reveal>
                  <div className={styles.head}>
                    <div className={styles.kicker}>
                      <span className={styles.kickerDot} /> Accès sécurisé
                    </div>
                    <h2 className={styles.title}>Connexion</h2>
                    <p className={styles.subtitle}>
                      Sélectionnez votre profil pour continuer.
                    </p>
                  </div>
                </Reveal>

                <div className={styles.profileStack}>
                  {ROLE_PROFILES.map((profile, index) => (
                    <Reveal key={profile.id} delay={index * 80}>
                      <button
                        type="button"
                        className={`${styles.profileCard} ${styles["accent-" + profile.accent]}`}
                        onClick={() => setSelectedRole(profile)}
                      >
                        <div className={styles.profileIcon}>
                          <profile.Icon size={24} />
                        </div>
                        <div className={styles.profileBody}>
                          <h3 className={styles.profileTitle}>{profile.title}</h3>
                          <p className={styles.profileText}>{profile.description}</p>
                        </div>
                        <span className={styles.ctaArrow}>→</span>
                      </button>
                    </Reveal>
                  ))}
                </div>
              </>
            ) : (
              <Reveal>
                <div className={styles["accent-" + selectedRole.accent]}>
                  <button type="button" className={styles.backLink} onClick={handleBack}>
                    ← Changer de profil
                  </button>

                  <div className={styles.selectedProfile}>
                    <div className={styles.selectedIcon}>
                      <selectedRole.Icon size={22} />
                    </div>
                    <div>
                      <div className={styles.selectedTitle}>{selectedRole.title}</div>
                      <div className={styles.selectedHint}>Connexion sécurisée</div>
                    </div>
                  </div>

                  <button type="button" className={styles.ssoButton}>
                    <MicrosoftLogo size={18} />
                    Se connecter avec Microsoft
                  </button>

                  <div className={styles.divider}>
                    <span />
                    ou avec vos identifiants
                    <span />
                  </div>

                  <form onSubmit={handleSubmit}>
                    <div className={styles.field}>
                      <label className={styles.label} htmlFor="username">
                        Email
                      </label>
                      <input
                        id="username"
                        className={styles.input}
                        type="email"
                        placeholder="vous@deltasoft.com"
                        autoComplete="username"
                        value={username}
                        onChange={(e) => setUsername(e.target.value)}
                      />
                    </div>

                    <div className={styles.field}>
                      <label className={styles.label} htmlFor="password">
                        Mot de passe
                      </label>
                      <div className={styles.passwordRow}>
                        <input
                          id="password"
                          className={styles.input}
                          type={showPassword ? "text" : "password"}
                          autoComplete="current-password"
                          value={password}
                          onChange={(e) => setPassword(e.target.value)}
                        />
                        <button
                          type="button"
                          className={styles.togglePassword}
                          onClick={() => setShowPassword((v) => !v)}
                          aria-label={showPassword ? "Masquer le mot de passe" : "Afficher le mot de passe"}
                        >
                          {showPassword ? "🙈" : "👁️"}
                        </button>
                      </div>
                    </div>

                    {error && <p className={styles.error}>{error}</p>}

                    <button type="submit" className={styles.submit} disabled={submitting}>
                      {submitting ? "Connexion..." : "Se connecter →"}
                    </button>

                    <p className={styles.helpText}>
                      Identifiants oubliés ? Contactez votre administrateur.
                    </p>

                    <p className={styles.demoHint}>
                      Démo : {selectedRole.id}@deltasoft.com
                    </p>
                  </form>
                </div>
              </Reveal>
            )}
          </div>
        </div>
      </div>

      <div className={styles.pageFooter}>
        © {new Date().getFullYear()} DeltaSoft International ·{" "}
        <a href="#contact">Mentions légales</a> ·{" "}
        <a href="#contact">Support</a>
      </div>
    </main>
  );
}
