import os
import uuid

from fastapi import HTTPException, UploadFile, status
from sqlalchemy.orm import Session

from src.model import Register
from src.user.after_login.dtos import (
    ProfileData,
    ProfileResponse
)



def get_profile(user: Register) -> ProfileResponse:
    """Return the logged-in user's profile."""
    try:
        return ProfileResponse(
            success=True,
            message="Profile fetched successfully",
            data=ProfileData(
                id=user.id,
                name=user.name,
                email=user.email,
                is_active=user.is_active,
            ),
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Get profile failed: {str(e)}",
        )


