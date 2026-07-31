import json
from datetime import datetime, timezone
from pathlib import Path

from app.schemas.contact import ContactMessageIn

DATA_DIR = Path(__file__).resolve().parent.parent.parent / "data"
DATA_FILE = DATA_DIR / "contact_messages.jsonl"


def save_contact_message(message: ContactMessageIn) -> None:
    DATA_DIR.mkdir(parents=True, exist_ok=True)

    record = {
        "received_at": datetime.now(timezone.utc).isoformat(),
        **message.model_dump(),
    }

    with DATA_FILE.open("a", encoding="utf-8") as f:
        f.write(json.dumps(record, ensure_ascii=False) + "\n")
