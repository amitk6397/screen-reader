import os
import uuid

from fastapi import HTTPException, UploadFile, status
from sqlalchemy.orm import Session

from src.admin.onboarding.dtos import OnboardingUpdate
from src.model import Onboarding

UPLOAD_DIR = "uploads/onboarding"


def _save_image(file: UploadFile) -> str:
    """Save uploaded image and return its URL path."""
    if not (file.content_type or "").startswith("image/"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"{file.filename} must be an image file (JPG, PNG, WEBP, etc.)"
        )
    os.makedirs(UPLOAD_DIR, exist_ok=True)
    extension = os.path.splitext(file.filename or "")[1].lower() or ".jpg"
    filename = f"{uuid.uuid4()}{extension}"
    file_path = os.path.join(UPLOAD_DIR, filename)
    with open(file_path, "wb") as buffer:
        buffer.write(file.file.read())
    return ("/" + file_path.replace("\\", "/"))


def create_onboarding(
    title: str,
    description: str,
    sort_order: int,
    is_active: bool,
    db: Session,
    image: UploadFile | None = None,
    image_url: str | None = None,
):
    """Create a new onboarding item, optionally uploading an image."""
    try:
        final_image_url = image_url
        if image and image.filename:
            final_image_url = _save_image(image)

        onboarding = Onboarding(
            title=title,
            description=description,
            image_url=final_image_url,
            sort_order=sort_order,
            is_active=is_active,
        )
        db.add(onboarding)
        db.commit()
        db.refresh(onboarding)
        return onboarding
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Create onboarding failed: {str(e)}",
        )


def get_all_onboarding(db: Session):
    """Get all onboarding items (Admin can see all - active + inactive)."""
    return (
        db.query(Onboarding)
        .order_by(Onboarding.sort_order.asc(), Onboarding.id.asc())
        .all()
    )


def update_onboarding(
    item_id: int,
    db: Session,
    title: str | None = None,
    description: str | None = None,
    sort_order: int | None = None,
    is_active: bool | None = None,
    image: UploadFile | None = None,
    image_url: str | None = None,
):
    """Update an onboarding item, optionally replacing the image."""
    onboarding = db.query(Onboarding).filter(Onboarding.id == item_id).first()
    if not onboarding:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Onboarding item not found")

    try:
        if title is not None:
            onboarding.title = title
        if description is not None:
            onboarding.description = description
        if sort_order is not None:
            onboarding.sort_order = sort_order
        if is_active is not None:
            onboarding.is_active = is_active

        # Handle image: uploaded file takes priority over URL string
        if image and image.filename:
            onboarding.image_url = _save_image(image)
        elif image_url is not None:
            onboarding.image_url = image_url

        db.commit()
        db.refresh(onboarding)
        return onboarding
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Update onboarding failed: {str(e)}",
        )


def delete_onboarding(item_id: int, db: Session):
    onboarding = db.query(Onboarding).filter(Onboarding.id == item_id).first()
    if not onboarding:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Onboarding item not found")

    db.delete(onboarding)
    db.commit()
    return {"success": True, "message": "Onboarding item deleted successfully"}
