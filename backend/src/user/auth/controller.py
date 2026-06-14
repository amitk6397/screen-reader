from sqlalchemy import false
from sqlalchemy.orm import Session
from fastapi import Depends, HTTPException, status

from src.model import Onboarding, Register
from src.utils.db import get_db
from src.user.auth.dtos import ConfirmPasswordRequest, ConfirmPasswordResponse, ForgotPasswordRequest, ForgotPasswordResponse, ForgotPasswordResponse, LoginRequest, LoginResponse, LoginResponseData, RegisterRequest, RegisterResponse, RegisterResponseData
from src.utils.security import (
    hash_password,
    verify_password,
    create_access_token
)

# onboarding controller

def get_onboarding(db: Session = Depends(get_db)):
   
    return (
        db.query(Onboarding)
        .filter(Onboarding.is_active.is_(True))
        .order_by(Onboarding.sort_order.asc(), Onboarding.id.asc())
        .all()
    )


# register controller

# Register Controller (Improved with proper response)
def post_register(payload: RegisterRequest, db: Session):
    try:
        # Check if email already exists
        existing = db.query(Register).filter_by(email=payload.email).first()
        if existing:
           return RegisterResponse(
                success=False,
                message="Email already registered",
                data=None
            )

        # Create new user
        hashed_pwd = hash_password(payload.password)
        new_user = Register(
            name=payload.name,
            email=payload.email,
            password=hashed_pwd
        )

        db.add(new_user)
        db.commit()
        db.refresh(new_user)

        # Create JWT token

        token = create_access_token(
            data={"user_id": new_user.id, "email": new_user.email}
        )

        # Return wrapped response
        return RegisterResponse(
            success=True,
            message="User registered successfully",
            data=RegisterResponseData(
                id=new_user.id,
                name=new_user.name,
                email=new_user.email,
                token=token
            )
        )

    except HTTPException as e:
        raise e

    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Registration failed: {str(e)}"
        )
    

# login controller

def post_login(payload: LoginRequest, db: Session):
    try:
        user = db.query(Register).filter(
            Register.email == payload.email
        ).first()

        if not user:
            return LoginResponse(
                success=False,
                message="Email is not registered",
                data=None
            )

        # Verify password
        if not verify_password(
            payload.password,
            user.password
        ):
            return LoginResponse(
                success=False,
                message="Invalid email or password",
                data=None
            )

        # Generate token
        token = create_access_token(
            {
                "user_id": user.id,
                "email": user.email,
                "is_superuser": user.is_superuser
            }
        )

        return LoginResponse(
            success=True,
            message="Login successful",
            data=LoginResponseData(
                id=user.id,
                name=user.name,
                email=user.email,
                token=token
            )
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Login failed: {str(e)}"
        )

def forgot_password(payload: ForgotPasswordRequest, db: Session):
    try:
        user = db.query(Register).filter(
            Register.email == payload.email
        ).first()

        if not user:
            return ForgotPasswordResponse(
                success=False,
                message="Email is not registered"
            )

        # Here you would typically send a password reset email
        # For this example, we'll just return a success message

        return ForgotPasswordResponse(
            success=True,
            message="Password reset instructions sent to your email"
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Forgot password failed: {str(e)}"
        )
    
def update_password(payload: ConfirmPasswordRequest, db: Session):
    try:
        user = db.query(Register).filter(
            Register.email == payload.email
        ).first()

        if not user:
           return ConfirmPasswordResponse(
            success=False,
            message="Email is not registered"
        )

        if payload.new_password != payload.confirm_password:
           return ConfirmPasswordResponse(
                success=False,
                message="New password and confirm password do not match"
            )

        user.password = hash_password(payload.new_password)
        db.commit()

        return ConfirmPasswordResponse(
            success=True,
            message="Password updated successfully"
        )

    except HTTPException as e:
        raise e

    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Update password failed: {str(e)}"
        )