import os
import uuid

from fastapi import HTTPException, UploadFile, status
from sqlalchemy.orm import Session

from src.model import Register
from src.user.after_login.dtos import ProfileData, ProfileResponse, ProfileUpdate

PROFILE_IMAGE_DIR = "uploads/profiles"


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
                profile_image=user.profile_image if hasattr(user, "profile_image") else None,
            ),
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Get profile failed: {str(e)}",
        )


def update_profile(
    payload: ProfileUpdate,
    user: Register,
    db: Session,
) -> ProfileResponse:
    """Update the logged-in user's profile (name / profile_image)."""
    try:
        update_data = payload.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            if hasattr(user, key):
                setattr(user, key, value)

        db.commit()
        db.refresh(user)

        return ProfileResponse(
            success=True,
            message="Profile updated successfully",
            data=ProfileData(
                id=user.id,
                name=user.name,
                email=user.email,
                is_active=user.is_active,
                profile_image=user.profile_image if hasattr(user, "profile_image") else None,
            ),
        )

    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Update profile failed: {str(e)}",
        )


def upload_profile_image(
    image: UploadFile,
    user: Register,
    db: Session,
) -> ProfileResponse:
    """Upload and save a profile image for the logged-in user."""
    try:
        os.makedirs(PROFILE_IMAGE_DIR, exist_ok=True)

        if not (image.content_type or "").startswith("image/"):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="File must be an image",
            )

        extension = os.path.splitext(image.filename or "")[1].lower()
        filename = f"{uuid.uuid4()}{extension}"
        file_path = os.path.join(PROFILE_IMAGE_DIR, filename)

        with open(file_path, "wb") as buffer:
            buffer.write(image.file.read())

        url = f"/{file_path.replace(chr(92), '/')}"

        if hasattr(user, "profile_image"):
            user.profile_image = url
            db.commit()
            db.refresh(user)

        return ProfileResponse(
            success=True,
            message="Profile image uploaded",
            data=ProfileData(
                id=user.id,
                name=user.name,
                email=user.email,
                is_active=user.is_active,
                profile_image=url,
            ),
        )

    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Upload failed: {str(e)}",
        )
