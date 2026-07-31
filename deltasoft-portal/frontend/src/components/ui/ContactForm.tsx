import { useState } from "react";
import type { FormEvent } from "react";
import { submitContactMessage } from "@/services/contact";
import styles from "./ContactForm.module.css";

type Status = "idle" | "submitting" | "success" | "error";

export function ContactForm() {
  const [status, setStatus] = useState<Status>("idle");

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = event.currentTarget;
    const data = new FormData(form);

    setStatus("submitting");
    try {
      await submitContactMessage({
        name: String(data.get("name") ?? ""),
        email: String(data.get("email") ?? ""),
        subject: String(data.get("subject") ?? ""),
        message: String(data.get("message") ?? ""),
      });
      setStatus("success");
      form.reset();
    } catch {
      setStatus("error");
    }
  }

  if (status === "success") {
    return (
      <div className={styles.successBox}>
        <div className={styles.successIcon} aria-hidden="true">✓</div>
        <h3>Message envoyé</h3>
        <p>Merci, nous revenons vers vous rapidement.</p>
        <button type="button" className={styles.resetLink} onClick={() => setStatus("idle")}>
          Envoyer un autre message
        </button>
      </div>
    );
  }

  return (
    <form className={styles.form} onSubmit={handleSubmit}>
      <div className={styles.row}>
        <label className={styles.field}>
          <span>Nom</span>
          <input type="text" name="name" required minLength={2} placeholder="Votre nom" />
        </label>
        <label className={styles.field}>
          <span>Email</span>
          <input type="email" name="email" required placeholder="vous@exemple.com" />
        </label>
      </div>

      <label className={styles.field}>
        <span>Sujet</span>
        <input type="text" name="subject" required minLength={2} placeholder="Objet de votre message" />
      </label>

      <label className={styles.field}>
        <span>Message</span>
        <textarea name="message" required minLength={10} rows={5} placeholder="Votre message..." />
      </label>

      {status === "error" && (
        <p className={styles.errorText}>
          Une erreur est survenue, merci de réessayer.
        </p>
      )}

      <button type="submit" className={styles.submit} disabled={status === "submitting"}>
        {status === "submitting" ? "Envoi en cours..." : "Envoyer le message"}
      </button>
    </form>
  );
}
