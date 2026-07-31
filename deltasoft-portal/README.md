# DeltaSoft Portal

Portail interne (stage DeltaSoft) intégrant un chatbot, des dashboards Power BI et un modèle de Machine Learning, avec accès réservé à 3 décideurs.

## Structure

```
deltasoft-portal/
├── frontend/               React + TypeScript (Vite)
│   ├── public/
│   └── src/
│       ├── assets/         images, logos
│       ├── styles/         design system (couleurs, typographie)
│       ├── components/
│       │   ├── layout/     Header, Footer, Layout
│       │   └── ui/         boutons, cartes, composants réutilisables
│       ├── pages/
│       │   ├── Home/       page d'accueil
│       │   └── Login/      page de connexion (3 décideurs)
│       ├── routes/         configuration des routes
│       ├── context/        auth context, état global
│       ├── services/       appels API vers le backend
│       ├── hooks/          hooks React réutilisables
│       └── types/          types TypeScript partagés
│
└── backend/                 Python (FastAPI)
    └── app/
        ├── core/            configuration, sécurité
        ├── api/routes/       endpoints (auth, chatbot, ml, dashboards)
        ├── models/           modèles de données
        ├── schemas/          schémas Pydantic (validation)
        ├── services/
        │   ├── auth/         authentification des 3 décideurs
        │   ├── chatbot/       logique du chatbot
        │   ├── ml/            intégration du modèle ML
        │   └── dashboards/    intégration Power BI
        └── db/               accès base de données
```

## Démarrage

### Prérequis
- Node.js LTS (https://nodejs.org)
- Python 3.11+ (https://www.python.org)

### Frontend
```bash
cd frontend
npm install
npm run dev
```

### Backend
```bash
cd backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
copy .env.example .env
uvicorn app.main:app --reload
```
