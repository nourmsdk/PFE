import { Navigate } from "react-router-dom";
import type { ReactNode } from "react";
import { useAuth } from "@/context/AuthContext";
import type { DecisionRole } from "@/types/auth";

export function ProtectedRoute({
  requiredRole,
  children,
}: {
  requiredRole: DecisionRole;
  children: ReactNode;
}) {
  const { session } = useAuth();

  if (!session || session.role !== requiredRole) {
    return <Navigate to="/login" replace />;
  }

  return <>{children}</>;
}
