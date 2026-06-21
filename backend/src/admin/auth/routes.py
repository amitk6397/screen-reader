from fastapi import APIRouter

from src.admin.auth.controller import admin_login, forgot_admin_credentials
from src.admin.auth.dtos import (
    AdminForgotRequest,
    AdminForgotResponse,
    AdminLoginRequest,
    AdminLoginResponse,
)

router = APIRouter(
    prefix="/auth",
    tags=["Admin Auth"],
)


@router.post("/login", response_model=AdminLoginResponse)
def admin_login_endpoint(payload: AdminLoginRequest):
    return admin_login(payload)


@router.post("/forgot-credentials", response_model=AdminForgotResponse)
def forgot_admin_credentials_endpoint(payload: AdminForgotRequest):
    return forgot_admin_credentials(payload)
