export interface LoginResult {
  access_token: string;
  token_type: string;
  role: string;
  full_name: string;
}

export async function login(email: string, password: string): Promise<LoginResult> {
  const response = await fetch("/api/auth/login", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });

  if (!response.ok) {
    throw new Error("invalid_credentials");
  }

  return response.json();
}
