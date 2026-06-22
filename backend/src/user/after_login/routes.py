from fastapi import APIRouter, Depends, File, UploadFile
from sqlalchemy.orm import Session

from src.model import Register
from src.utils.auth_dependency import get_current_user
from src.utils.db import get_db
from src.user.after_login.controller import get_profile
from src.user.after_login.dtos import ProfileResponse

router = APIRouter(
    prefix="/profile",
    tags=["User Profile"],
)


@router.get("", response_model=ProfileResponse)
def get_profile_endpoint(
    current_user: Register = Depends(get_current_user),
):
    """Get the logged-in user's profile."""
    return get_profile(current_user)



