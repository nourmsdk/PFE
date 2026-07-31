from dataclasses import dataclass

from app.core.security import hash_password


@dataclass
class DemoUser:
    email: str
    hashed_password: str
    role: str
    full_name: str


DEMO_USERS: list[DemoUser] = [
    DemoUser(
        email="reception@deltasoft.com",
        hashed_password=hash_password("reception123"),
        role="reception",
        full_name="Réceptionnaire SAV",
    ),
    DemoUser(
        email="sav@deltasoft.com",
        hashed_password=hash_password("sav123"),
        role="sav",
        full_name="Responsable SAV",
    ),
    DemoUser(
        email="qualite@deltasoft.com",
        hashed_password=hash_password("qualite123"),
        role="qualite",
        full_name="Responsable Qualité",
    ),
]


def find_user(email: str) -> DemoUser | None:
    return next((u for u in DEMO_USERS if u.email.lower() == email.strip().lower()), None)
