import { Routes, Route } from "react-router-dom";
import { Layout } from "@/components/layout/Layout";
import { HomePage } from "@/pages/Home/HomePage";
import { LoginPage } from "@/pages/Login/LoginPage";
import { ReceptionPage } from "@/pages/Dashboard/Reception/ReceptionPage";
import { SavPage } from "@/pages/Dashboard/Sav/SavPage";
import { QualitePage } from "@/pages/Dashboard/Qualite/QualitePage";

export function AppRouter() {
  return (
    <Layout>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="/espace/reception" element={<ReceptionPage />} />
        <Route path="/espace/sav" element={<SavPage />} />
        <Route path="/espace/qualite" element={<QualitePage />} />
      </Routes>
    </Layout>
  );
}
