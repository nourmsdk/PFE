import { useState } from "react";
import type { FormEvent } from "react";
import { FacebookIcon, LinkedInIcon } from "@/components/ui/SocialIcons";
import styles from "./Footer.module.css";

const SOCIAL_LINKS = [
  { label: "Facebook", href: "https://www.facebook.com/deltasoft.international", Icon: FacebookIcon },
  { label: "LinkedIn", href: "https://www.linkedin.com/company/delta-soft-international/", Icon: LinkedInIcon },
];

export function Footer() {
  const year = new Date().getFullYear();
  const [subscribed, setSubscribed] = useState(false);

  function handleSubscribe(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setSubscribed(true);
    event.currentTarget.reset();
  }

  return (
    <footer className={styles.footer}>
      <div className={`container ${styles.inner}`}>
        <div>
          <div className={styles.colTitle}>Menu</div>
          <ul className={styles.linkList}>
            <li><a href="#contact">Contact</a></li>
            <li><a href="#apropos">Partenaires</a></li>
          </ul>

          <div className={styles.colTitle} style={{ marginTop: "1.5rem" }}>
            Newsletter
          </div>
          {subscribed ? (
            <p className={styles.subscribedText}>Merci, votre inscription est confirmée !</p>
          ) : (
            <form className={styles.newsletterForm} onSubmit={handleSubscribe}>
              <label htmlFor="newsletter-email" className={styles.newsletterLabel}>
                E-mail
              </label>
              <div className={styles.newsletterRow}>
                <input
                  id="newsletter-email"
                  type="email"
                  required
                  placeholder="Votre adresse email"
                  className={styles.newsletterInput}
                />
                <button type="submit" className={styles.newsletterButton}>
                  S'abonner
                </button>
              </div>
            </form>
          )}

          <div className={styles.socialRow}>
            {SOCIAL_LINKS.map(({ label, href, Icon }) => (
              <a
                key={label}
                href={href}
                target="_blank"
                rel="noopener noreferrer"
                aria-label={label}
                className={styles.socialButton}
              >
                <Icon />
              </a>
            ))}
          </div>
        </div>

        <div>
          <div className={styles.colTitle}>Siège DeltaSoft International</div>
          <ul className={styles.contactList}>
            <li>
              <span className={styles.contactIcon} aria-hidden="true">📍</span>
              Av. Charles Nicolle - Rés. Maram Palace 6éme Etage - El Menzah IV - 1082 - Tunis - Tunisie
            </li>
            <li>
              <span className={styles.contactIcon} aria-hidden="true">☎️</span>
              Tél: (+216) 71 23 04 66 - (+216) 71 23 04 77
            </li>
            <li>
              <span className={styles.contactIcon} aria-hidden="true">📠</span>
              Fax: (+216) 71 23 04 88
            </li>
            <li>
              <span className={styles.contactIcon} aria-hidden="true">✉️</span>
              Email: info@deltagroup.com.tn
            </li>
          </ul>
        </div>

        <div>
          <div className={styles.colTitle}>Filiale Canada DeltaSoft Solutions</div>
          <ul className={styles.contactList}>
            <li>
              <span className={styles.contactIcon} aria-hidden="true">📍</span>
              9 Rue de Macornet Blainville (Québec) J7C 0M8 Canada
            </li>
            <li>
              <span className={styles.contactIcon} aria-hidden="true">☎️</span>
              Tél: +1 514 250 8411
            </li>
            <li>
              <span className={styles.contactIcon} aria-hidden="true">✉️</span>
              Email: contact@deltasoft-solutions.com
            </li>
          </ul>
        </div>
      </div>

      <div className={`container ${styles.bottom}`}>
        <span>© {year} DeltaSoft. Tous droits réservés.</span>
      </div>
    </footer>
  );
}
