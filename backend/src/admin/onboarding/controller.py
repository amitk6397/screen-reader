from sqlalchemy.orm import Session
from fastapi import HTTPException, status

from src.admin.onboarding.dtos import OnboardingCreate, OnboardingUpdate
from src.model import Onboarding   # Assuming model is here


def create_onboarding(payload: OnboardingCreate, db: Session):
    """Create new onboarding item"""
    onboarding = Onboarding(**payload.model_dump())
    db.add(onboarding)
    db.commit()
    db.refresh(onboarding)
    return onboarding


def get_all_onboarding(db: Session):
    """Get all onboarding items (Admin can see all - active + inactive)"""
    return (
        db.query(Onboarding)
        .order_by(Onboarding.sort_order.asc(), Onboarding.id.asc())
        .all()
    )


def update_onboarding(item_id: int, payload: OnboardingUpdate, db: Session):
    onboarding = db.query(Onboarding).filter(Onboarding.id == item_id).first()
    if not onboarding:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Onboarding item not found")

    for key, value in payload.model_dump(exclude_unset=True).items():
        setattr(onboarding, key, value)

    db.commit()
    db.refresh(onboarding)
    return onboarding


def delete_onboarding(item_id: int, db: Session):
    onboarding = db.query(Onboarding).filter(Onboarding.id == item_id).first()
    if not onboarding:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Onboarding item not found")

    db.delete(onboarding)
    db.commit()
    return {"success": True, "message": "Onboarding item deleted successfully"}
