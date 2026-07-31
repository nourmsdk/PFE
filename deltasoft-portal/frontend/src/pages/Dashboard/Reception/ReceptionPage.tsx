import { useState } from "react";
import type { FormEvent } from "react";
import { DashboardHeader } from "@/components/dashboard/DashboardHeader";
import { InboxIcon } from "@/components/ui/ServiceIcons";
import { classifyComplaint } from "@/utils/classifyComplaint";
import type { ClassificationResult } from "@/utils/classifyComplaint";
import { priorityBadgeClass } from "@/utils/dashboardBadges";
import styles from "@/styles/dashboard.module.css";

interface ChatMessage {
  id: string;
  role: "bot" | "user";
  text: string;
  classification?: ClassificationResult;
  added?: boolean;
}

interface ClassifiedEntry {
  id: string;
  subject: string;
  classification: ClassificationResult;
  time: string;
}

const INITIAL_MESSAGES: ChatMessage[] = [
  {
    id: "welcome",
    role: "bot",
    text: "Bonjour ! Collez ou décrivez la réclamation reçue et je vous propose une catégorie et une priorité à saisir dans Business Central.",
  },
];

export function ReceptionPage() {
  const [messages, setMessages] = useState<ChatMessage[]>(INITIAL_MESSAGES);
  const [input, setInput] = useState("");
  const [classifiedToday, setClassifiedToday] = useState<ClassifiedEntry[]>([]);

  function handleSubmit(event: FormEvent) {
    event.preventDefault();
    const text = input.trim();
    if (!text) return;

    const classification = classifyComplaint(text);

    const userMessage: ChatMessage = { id: crypto.randomUUID(), role: "user", text };
    const botMessage: ChatMessage = {
      id: crypto.randomUUID(),
      role: "bot",
      text: classification.note,
      classification,
    };

    setMessages((prev) => [...prev, userMessage, botMessage]);
    setInput("");
  }

  function addToList(message: ChatMessage) {
    if (!message.classification) return;

    setClassifiedToday((prev) => [
      {
        id: message.id,
        subject: messages.find((m) => m.role === "user" && messages.indexOf(m) === messages.indexOf(message) - 1)?.text ?? "Réclamation",
        classification: message.classification!,
        time: new Date().toLocaleTimeString("fr-FR", { hour: "2-digit", minute: "2-digit" }),
      },
      ...prev,
    ]);

    setMessages((prev) => prev.map((m) => (m.id === message.id ? { ...m, added: true } : m)));
  }

  return (
    <main className={styles.page}>
      <div className="container">
        <DashboardHeader
          Icon={InboxIcon}
          title="Espace Réceptionnaire SAV"
          subtitle="La saisie des réclamations se fait dans Business Central — l'assistant vous aide à les classifier"
        />

        <div className={styles.kpiGrid}>
          <div className={styles.kpiCard}>
            <div className={styles.kpiIcon} aria-hidden="true">💬</div>
            <div>
              <div className={styles.kpiValue}>{classifiedToday.length}</div>
              <div className={styles.kpiLabel}>Classifiées aujourd'hui</div>
            </div>
          </div>
          <div className={styles.kpiCard}>
            <div className={styles.kpiIcon} aria-hidden="true">🔥</div>
            <div>
              <div className={styles.kpiValue}>
                {classifiedToday.filter((c) => c.classification.priority === "Urgente").length}
              </div>
              <div className={styles.kpiLabel}>Urgentes détectées</div>
            </div>
          </div>
        </div>

        <div style={{ display: "grid", gridTemplateColumns: "1.1fr 0.9fr", gap: "1.5rem", alignItems: "start" }}>
          <div className={styles.panel}>
            <div className={styles.panelHead}>
              <div className={styles.panelTitle}>Assistant de classification</div>
            </div>

            <div className={styles.chatShell}>
              <div className={styles.chatMessages}>
                {messages.map((message) => (
                  <div
                    key={message.id}
                    className={`${styles.chatBubble} ${
                      message.role === "user" ? styles.chatBubbleUser : styles.chatBubbleBot
                    }`}
                  >
                    <div>{message.text}</div>
                    {message.classification && (
                      <div>
                        <span className={priorityBadgeClass(styles, message.classification.priority)}>
                          {message.classification.priority}
                        </span>
                        <span className={`${styles.badge} ${styles.badgeCategory}`}>{message.classification.category}</span>
                        {!message.added ? (
                          <button
                            type="button"
                            className={styles.chatSend}
                            style={{ display: "block", marginTop: "0.75rem" }}
                            onClick={() => addToList(message)}
                          >
                            Confirmer cette classification
                          </button>
                        ) : (
                          <p style={{ marginTop: "0.5rem", fontSize: "var(--fs-xs)", color: "var(--color-text-muted)" }}>
                            ✓ Ajoutée aux réclamations classifiées
                          </p>
                        )}
                      </div>
                    )}
                  </div>
                ))}
              </div>

              <form className={styles.chatInputRow} onSubmit={handleSubmit}>
                <textarea
                  className={styles.chatInput}
                  rows={2}
                  placeholder="Décrivez la réclamation reçue..."
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  onKeyDown={(e) => {
                    if (e.key === "Enter" && !e.shiftKey) {
                      e.preventDefault();
                      handleSubmit(e);
                    }
                  }}
                />
                <button type="submit" className={styles.chatSend} disabled={!input.trim()}>
                  Envoyer
                </button>
              </form>
            </div>
          </div>

          <div className={styles.panel}>
            <div className={styles.panelHead}>
              <div className={styles.panelTitle}>Classifiées aujourd'hui</div>
            </div>
            {classifiedToday.length === 0 ? (
              <p style={{ color: "var(--color-text-muted)", fontSize: "var(--fs-sm)" }}>
                Aucune réclamation classifiée pour le moment.
              </p>
            ) : (
              <div className={styles.list}>
                {classifiedToday.map((entry) => (
                  <div key={entry.id} style={{ padding: "0.9rem", border: "1px solid var(--color-border)", borderRadius: "var(--radius-md)", background: "var(--color-bg-muted)" }}>
                    <div className={styles.listSubject}>{entry.subject}</div>
                    <div style={{ marginTop: "0.5rem", display: "flex", gap: "0.5rem", alignItems: "center" }}>
                      <span className={priorityBadgeClass(styles, entry.classification.priority)}>
                        {entry.classification.priority}
                      </span>
                      <span className={`${styles.badge} ${styles.badgeCategory}`}>{entry.classification.category}</span>
                      <span className={styles.listMeta}>{entry.time}</span>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    </main>
  );
}
