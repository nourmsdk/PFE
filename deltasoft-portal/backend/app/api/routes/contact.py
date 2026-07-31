from fastapi import APIRouter

from app.schemas.contact import ContactMessageIn, ContactMessageOut
from app.services.contact import save_contact_message

router = APIRouter(prefix="/api/contact", tags=["contact"])


@router.post("", response_model=ContactMessageOut)
def submit_contact_message(payload: ContactMessageIn) -> ContactMessageOut:
    save_contact_message(payload)
    return ContactMessageOut(success=True)
