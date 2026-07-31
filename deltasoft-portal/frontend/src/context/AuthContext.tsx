import { createContext, useContext, useState } from "react";
import type { ReactNode } from "react";
import type { DecisionRole } from "@/types/auth";

export interface AuthSession {
  token: string;
  role: DecisionRole;
  fullName: string;
}

interface AuthContextValue {
  session: AuthSession | null;
  setSession: (session: AuthSession) => void;
  logout: () => void;
}

const STORAGE_KEY = "deltasoft_auth";
const AuthContext = createContext<AuthContextValue | null>(null);

function readStoredSession(): AuthSession | null {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? (JSON.parse(raw) as AuthSession) : null;
  } catch {
    return null;
  }
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [session, setSessionState] = useState<AuthSession | null>(readStoredSession);

  function setSession(next: AuthSession) {
    setSessionState(next);
    localStorage.setItem(STORAGE_KEY, JSON.stringify(next));
  }

  function logout() {
    setSessionState(null);
    localStorage.removeItem(STORAGE_KEY);
  }

  return (
    <AuthContext.Provider value={{ session, setSession, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}
