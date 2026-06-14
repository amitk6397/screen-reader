from fastapi import APIRouter, Depends
from src.utils.db import get_db

from src.user.auth.dtos import  ConfirmPasswordRequest, ConfirmPasswordResponse, ForgotPasswordRequest, ForgotPasswordResponse, LoginRequest, LoginResponse, OnboardingListResponse, RegisterRequest, RegisterResponse
from src.user.auth.controller import forgot_password, get_onboarding, post_login, post_register, update_password

router = APIRouter()

# ✅ Correct way
@router.get("/onboarding", response_model=OnboardingListResponse)
def get_onboarding_endpoint(db=Depends(get_db)):   # Better to use dependency here
    return OnboardingListResponse(success=True, data=get_onboarding(db))

# register routes

@router.post("/register", response_model=RegisterResponse)
def post_register_endpoint(payload: RegisterRequest, db=Depends(get_db)):
    return post_register(payload, db)

# login routes

@router.post("/login", response_model=LoginResponse)
def post_login_endpoint(payload: LoginRequest, db=Depends(get_db)):
    return post_login(payload, db)

# forgot password routes will be added here in future

@router.post("/forgot-password", response_model=ForgotPasswordResponse)
def forgot_password_endpoint(payload: ForgotPasswordRequest, db=Depends(get_db)):
    return forgot_password(payload, db)

@router.post("/confirm-password", response_model=ConfirmPasswordResponse)
def confirm_password_endpoint(payload: ConfirmPasswordRequest, db=Depends(get_db)):
    return update_password(payload, db)
