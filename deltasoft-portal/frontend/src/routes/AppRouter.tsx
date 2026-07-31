import { Routes, Route } from "react-router-dom";
import { Layout } from "@/components/layout/Layout";
import { HomePage } from "@/pages/Home/HomePage";
import { LoginPage } from "@/pages/Login/LoginPage";
import { ReceptionPage } from "@/pages/Dashboard/Reception/ReceptionPage";
import { SavPage } from "@/pages/Dashboard/Sav/SavPage";
import { QualitePage } from "@/pages/Dashboard/Qualite/QualitePage";
import { ProtectedRoute } from "@/routes/ProtectedRoute";

export function AppRouter() {
  return (
    <Layout>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route
          path="/espace/reception"
          element={
            <ProtectedRoute requiredRole="reception">
              <ReceptionPage />
            </ProtectedRoute>
          }
        />
        <Route
          path="/espace/sav"
          element={
            <ProtectedRoute requiredRole="sav">
              <SavPage />
            </ProtectedRoute>
          }
        />
        <Route
          path="/espace/qualite"
          element={
            <ProtectedRoute requiredRole="qualite">
              <QualitePage />
            </ProtectedRoute>
          }
        />
      </Routes>
    </Layout>
  );
}
