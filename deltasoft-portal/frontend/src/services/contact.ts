export interface ContactPayload {
  name: string;
  email: string;
  subject: string;
  message: string;
}

export async function submitContactMessage(payload: ContactPayload): Promise<void> {
  const response = await fetch("/api/contact", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });

  if (!response.ok) {
    throw new Error("La demande n'a pas pu être envoyée.");
  }
}
