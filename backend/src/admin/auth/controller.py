from src.admin.auth.dtos import (
    AdminForgotData,
    AdminForgotRequest,
    AdminForgotResponse,
    AdminLoginData,
    AdminLoginRequest,
    AdminLoginResponse,
)
from src.utils.security import create_access_token

ADMIN_EMAIL = "admin@gmail.com"
ADMIN_PASSWORD = "745497"
ADMIN_NAME = "Admin"


def admin_login(payload: AdminLoginRequest):
    if payload.email != ADMIN_EMAIL or payload.password != ADMIN_PASSWORD:
        return AdminLoginResponse(
            success=False,
            message="Invalid admin email or password",
            data=None,
        )

    token = create_access_token(
        {
            "user_id": 0,
            "email": ADMIN_EMAIL,
            "role": "admin",
            "is_superuser": True,
        }
    )

    return AdminLoginResponse(
        success=True,
        message="Admin login successful",
        data=AdminLoginData(
            id=0,
            name=ADMIN_NAME,
            email=ADMIN_EMAIL,
            token=token,
        ),
    )


def forgot_admin_credentials(payload: AdminForgotRequest):
    if payload.email and payload.email != ADMIN_EMAIL:
        return AdminForgotResponse(
            success=False,
            message="Admin email not found",
            data=None,
        )

    return AdminForgotResponse(
        success=True,
        message="Admin credentials found",
        data=AdminForgotData(
            email=ADMIN_EMAIL,
            password=ADMIN_PASSWORD,
        ),
    )
