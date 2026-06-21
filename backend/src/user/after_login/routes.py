from fastapi import APIRouter, Depends, File, UploadFile
from sqlalchemy.orm import Session

from src.model import Register
from src.utils.auth_dependency import get_current_user
from src.utils.db import get_db
from src.user.after_login.controller import get_profile, update_profile, upload_profile_image
from src.user.after_login.dtos import ProfileResponse, ProfileUpdate

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


@router.put("", response_model=ProfileResponse)
def update_profile_endpoint(
    payload: ProfileUpdate,
    current_user: Register = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Update the logged-in user's profile (name)."""
    return update_profile(payload, current_user, db)


@router.post("/upload-image", response_model=ProfileResponse)
def upload_image_endpoint(
    image: UploadFile = File(...),
    current_user: Register = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Upload a new profile picture."""
    return upload_profile_image(image, current_user, db)
