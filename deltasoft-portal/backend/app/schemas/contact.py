from pydantic import BaseModel, EmailStr, Field


class ContactMessageIn(BaseModel):
    name: str = Field(min_length=2, max_length=120)
    email: EmailStr
    subject: str = Field(min_length=2, max_length=160)
    message: str = Field(min_length=10, max_length=4000)


class ContactMessageOut(BaseModel):
    success: bool
