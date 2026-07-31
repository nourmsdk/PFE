from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    app_name: str = "DeltaSoft Portal API"
    environment: str = "development"
    frontend_origin: str = "http://localhost:5173"
    secret_key: str = "change-me"
    access_token_expire_minutes: int = 60

    class Config:
        env_file = ".env"


settings = Settings()
