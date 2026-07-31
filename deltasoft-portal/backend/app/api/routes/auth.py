from fastapi import APIRouter, HTTPException, status

from app.core.security import create_access_token, verify_password
from app.schemas.auth import LoginRequest, LoginResponse
from app.services.auth.users import find_user

router = APIRouter(prefix="/api/auth", tags=["auth"])


@router.post("/login", response_model=LoginResponse)
def login(payload: LoginRequest) -> LoginResponse:
    user = find_user(payload.email)
    if not user or not verify_password(payload.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Identifiant ou mot de passe incorrect.",
        )

    token = create_access_token(subject=user.email, role=user.role)
    return LoginResponse(access_token=token, role=user.role, full_name=user.full_name)
