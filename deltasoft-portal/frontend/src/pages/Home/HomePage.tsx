import { Link } from "react-router-dom";
import { Reveal } from "@/components/ui/Reveal";
import { Counter } from "@/components/ui/Counter";
import { ContactForm } from "@/components/ui/ContactForm";
import { HeroSlideshow } from "@/components/ui/HeroSlideshow";
import { MicrosoftLogo } from "@/components/ui/MicrosoftLogo";
import { InboxIcon, WrenchIcon, ShieldCheckIcon } from "@/components/ui/ServiceIcons";
import hero1 from "@/assets/hero-1.webp";
import hero2 from "@/assets/hero-2.png";
import hero3 from "@/assets/hero-3.png";
import dynamicsImg from "@/assets/dynamics.jpg";
import automobileImg from "@/assets/automobile.jpg";
import retailImg from "@/assets/retrail.jpg";
import styles from "./HomePage.module.css";

const HERO_IMAGES = [hero1, hero2, hero3];

const SOLUTIONS_ERP = [
  {
    image: dynamicsImg,
    title: "MS Dynamics 365 Business Central",
    text: "La solution de gestion d'entreprise tout-en-un, conviviale et modulable, qui centralise finance, ventes et opérations.",
  },
  {
    image: automobileImg,
    title: "Automobile",
    text: "Une solution ERP métier dédiée aux acteurs du secteur automobile, de la vente à l'après-vente.",
  },
  {
    image: retailImg,
    title: "Retail",
    text: "Une solution dédiée à la grande distribution et aux chaînes du retail, de la caisse à la gestion des stocks.",
  },
];

const SERVICES = [
  {
    Icon: InboxIcon,
    num: "01",
    accent: "blue",
    title: "Réception des réclamations",
    text: "Chaque réclamation client est enregistrée, qualifiée et tracée dès son arrivée par l'équipe de réception SAV.",
  },
  {
    Icon: WrenchIcon,
    num: "02",
    accent: "amber",
    title: "Suivi des interventions SAV",
    text: "Le responsable SAV pilote l'avancement des interventions et coordonne les équipes jusqu'à la résolution.",
  },
  {
    Icon: ShieldCheckIcon,
    num: "03",
    accent: "green",
    title: "Contrôle qualité",
    text: "Le responsable qualité supervise la conformité des interventions et le respect des standards DeltaSoft.",
  },
];

const STATS = [
  { value: "3", label: "Profils métiers dédiés" },
  { value: "24/7", label: "Assistant IA disponible" },
  { value: "100%", label: "Traçabilité des réclamations" },
  { value: "Temps réel", label: "Suivi qualité & SAV" },
];


const TESTIMONIALS = [
  {
    icon: "📥",
    role: "Réceptionnaire SAV",
    quote:
      "Je qualifie chaque réclamation en quelques clics, l'assistant IA me fait gagner un temps précieux.",
  },
  {
    icon: "🛠️",
    role: "Responsable SAV",
    quote:
      "Je vois en un coup d'œil l'état de toutes les interventions en cours.",
  },
  {
    icon: "✅",
    role: "Responsable Qualité",
    quote:
      "Les alertes automatiques m'aident à anticiper les non-conformités avant qu'elles ne deviennent critiques.",
  },
];

export function HomePage() {
  return (
    <main>
      {/* Hero */}
      <section className={styles.hero}>
        <HeroSlideshow images={HERO_IMAGES} intervalMs={5000} />
        <div className={`container ${styles.heroInner}`}>
          <h1 className={styles.heroTitle}>
            Notre expertise
            <br />
            au service de votre SAV
          </h1>
        </div>
      </section>

      {/* À propos */}
      <section id="apropos" className={styles.section}>
        <div className="container">
          <div className={styles.aboutGrid}>
            <Reveal>
              <div className={styles.aboutText}>
                <h2 className={styles.aboutTitle}>A propos</h2>
                <p>
                  Acteur majeur de la transformation digitale des entreprises,
                  DeltaSoft propose une large gamme de logiciels de gestion et
                  de services IT à forte valeur ajoutée.
                </p>
                <p>
                  En tant que partenaire Gold Microsoft, DeltaSoft dispose
                  d'une forte expertise sectorielle. Ce portail SAV & Qualité
                  s'appuie sur cette expertise pour offrir à chaque profil
                  métier un espace dédié et des outils intelligents.
                </p>
                <a href="#services" className={styles.outlineButton}>
                  Voir plus
                </a>
              </div>
            </Reveal>

            <Reveal delay={120}>
              <div className={styles.msPartner}>
                <div className={styles.msPartnerTier}>Gold</div>
                <div className={styles.msPartnerTitle}>Microsoft Partner</div>
                <div className={styles.msPartnerBrand}>
                  <MicrosoftLogo size={34} />
                  <span>Microsoft</span>
                </div>
              </div>
            </Reveal>
          </div>
        </div>
      </section>

      {/* Solutions ERP */}
      <section id="nos-solutions" className={styles.section}>
        <div className="container">
          <div className={`${styles.sectionHead} ${styles.centered}`}>
            <div className={styles.sectionKicker}>Solutions</div>
            <h2 className={styles.sectionTitle}>Des solutions ERP dédiées à vos métiers</h2>
            <p className={styles.sectionSubtitle}>
              Créateur de valeur, nous vous accompagnons de bout en bout dans votre projet de transformation digitale.
            </p>
          </div>

          <div className={styles.grid}>
            {SOLUTIONS_ERP.map((item, index) => (
              <Reveal key={item.title} delay={index * 100}>
                <div className={styles.solutionCard}>
                  <img src={item.image} alt={item.title} className={styles.solutionImage} />
                  <div className={styles.solutionBody}>
                    <h3 className={styles.solutionTitle}>{item.title}</h3>
                    <p className={styles.solutionText}>{item.text}</p>
                    <a href="#contact" className={styles.solutionLink}>
                      Voir plus
                    </a>
                  </div>
                </div>
              </Reveal>
            ))}
          </div>
        </div>
      </section>

      {/* Services */}
      <section id="services" className={`${styles.section} ${styles.sectionMuted}`}>
        <div className="container">
          <div className={`${styles.sectionHead} ${styles.centered}`}>
            <div className={styles.sectionKicker}>Services</div>
            <h2 className={styles.sectionTitle}>Un portail pensé pour 3 métiers</h2>
            <p className={styles.sectionSubtitle}>
              Chaque profil dispose d'un espace adapté à ses responsabilités.
            </p>
          </div>

          <div className={styles.grid}>
            {SERVICES.map((item, index) => (
              <Reveal key={item.title} delay={index * 100}>
                <div className={`${styles.card} ${styles["accent-" + item.accent]}`}>
                  <span className={styles.cardNum}>{item.num}</span>
                  <div className={styles.cardIcon}>
                    <item.Icon />
                  </div>
                  <h3 className={styles.cardTitle}>{item.title}</h3>
                  <p className={styles.cardText}>{item.text}</p>
                  <Link to="/login" className={styles.cardLink}>
                    Accéder à mon espace <span className={styles.cardLinkArrow}>→</span>
                  </Link>
                </div>
              </Reveal>
            ))}
          </div>
        </div>
      </section>

      {/* Chiffres clés */}
      <section className={styles.statsBand}>
        <div className={`container ${styles.statsGrid}`}>
          {STATS.map((stat) => (
            <Reveal key={stat.label}>
              <div className={styles.statValue}>
                <Counter value={stat.value} />
              </div>
              <div className={styles.statLabel}>{stat.label}</div>
            </Reveal>
          ))}
        </div>
      </section>

      {/* Outils IA */}
      <section id="solutions" className={styles.section}>
        <div className="container">
          <div className={`${styles.sectionHead} ${styles.centered}`}>
            <div className={styles.sectionKicker}>Nos outils</div>
            <h2 className={styles.sectionTitle}>L'intelligence artificielle au service du SAV</h2>
          </div>

          <Reveal>
            <div id="chatbot" className={styles.featureRow} style={{ marginBottom: "var(--space-10)" }}>
              <div>
                <span className={styles.featureBadge}>Assistant IA</span>
                <h3 className={styles.featureTitle}>
                  Un chatbot qui accélère le traitement des réclamations
                </h3>
                <p className={styles.featureText}>
                  L'assistant aide le réceptionnaire à qualifier chaque
                  réclamation et propose des réponses adaptées au responsable
                  SAV.
                </p>
                <ul className={styles.featureList}>
                  <li><span className={styles.checkDot}>✓</span> Qualification assistée des réclamations</li>
                  <li><span className={styles.checkDot}>✓</span> Réponses contextualisées par profil</li>
                  <li><span className={styles.checkDot}>✓</span> Disponible 24/7</li>
                </ul>
              </div>
              <div className={styles.featureVisual} />
            </div>
          </Reveal>

          <Reveal>
            <div id="dashboards" className={`${styles.featureRow} ${styles.reverse}`} style={{ marginBottom: "var(--space-10)" }}>
              <div>
                <span className={styles.featureBadge}>Tableaux de bord</span>
                <h3 className={styles.featureTitle}>
                  Le SAV et la qualité suivis en temps réel
                </h3>
                <p className={styles.featureText}>
                  Volumes de réclamations, délais de traitement, taux de
                  conformité : chaque responsable visualise ses indicateurs
                  clés en un coup d'œil.
                </p>
                <ul className={styles.featureList}>
                  <li><span className={styles.checkDot}>✓</span> Vues dédiées SAV et Qualité</li>
                  <li><span className={styles.checkDot}>✓</span> Données mises à jour en continu</li>
                  <li><span className={styles.checkDot}>✓</span> Export et partage en un clic</li>
                </ul>
              </div>
              <div className={styles.featureVisual} />
            </div>
          </Reveal>

          <Reveal>
            <div id="ml" className={styles.featureRow}>
              <div>
                <span className={styles.featureBadge}>Machine Learning</span>
                <h3 className={styles.featureTitle}>
                  Anticiper les pannes et les non-conformités
                </h3>
                <p className={styles.featureText}>
                  Les modèles analysent l'historique des réclamations pour
                  détecter les signaux faibles et alerter le responsable
                  qualité en amont.
                </p>
                <ul className={styles.featureList}>
                  <li><span className={styles.checkDot}>✓</span> Détection des anomalies récurrentes</li>
                  <li><span className={styles.checkDot}>✓</span> Indicateurs de confiance transparents</li>
                  <li><span className={styles.checkDot}>✓</span> Alertes proactives</li>
                </ul>
              </div>
              <div className={styles.featureVisual} />
            </div>
          </Reveal>
        </div>
      </section>

      {/* Témoignages */}
      <section className={`${styles.section} ${styles.sectionMuted}`}>
        <div className="container">
          <div className={`${styles.sectionHead} ${styles.centered}`}>
            <div className={styles.sectionKicker}>Témoignages</div>
            <h2 className={styles.sectionTitle}>Ce que disent les équipes</h2>
            <p className={styles.sectionSubtitle}>
              Aperçu des retours attendus, un profil par métier.
            </p>
          </div>

          <div className={styles.grid}>
            {TESTIMONIALS.map((item, index) => (
              <Reveal key={item.role} delay={index * 100}>
                <div className={styles.testimonialCard}>
                  <div className={styles.quoteMark} aria-hidden="true">“</div>
                  <p className={styles.testimonialQuote}>{item.quote}</p>
                  <div className={styles.testimonialRole}>
                    <span aria-hidden="true">{item.icon}</span> {item.role}
                  </div>
                </div>
              </Reveal>
            ))}
          </div>
        </div>
      </section>

      {/* Contact */}
      <section id="contact" className={styles.section}>
        <div className="container">
          <div className={`${styles.sectionHead} ${styles.centered}`}>
            <div className={styles.sectionKicker}>Contact</div>
            <h2 className={styles.sectionTitle}>Une question sur le portail ?</h2>
          </div>

          <div className={styles.contactGrid}>
            <div className={styles.contactInfo}>
              <Reveal>
                <div className={styles.contactCard}>
                  <div className={styles.contactIcon} aria-hidden="true">✉️</div>
                  <div>
                    <div className={styles.contactLabel}>Email</div>
                    <div className={styles.contactValue}>contact@deltasoft.com</div>
                  </div>
                </div>
              </Reveal>
              <Reveal delay={100}>
                <div className={styles.contactCard}>
                  <div className={styles.contactIcon} aria-hidden="true">📍</div>
                  <div>
                    <div className={styles.contactLabel}>Localisation</div>
                    <div className={styles.contactValue}>Tunis, Tunisie</div>
                  </div>
                </div>
              </Reveal>
            </div>

            <Reveal delay={150}>
              <ContactForm />
            </Reveal>
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className={styles.section}>
        <div className="container">
          <Reveal>
            <div className={styles.ctaBand}>
              <h2>Prêt à rejoindre votre espace ?</h2>
              <p>Connectez-vous avec votre profil : réceptionnaire, SAV ou qualité.</p>
              <Link to="/login" className={styles.btnPrimary}>
                Se connecter
              </Link>
            </div>
          </Reveal>
        </div>
      </section>
    </main>
  );
}
