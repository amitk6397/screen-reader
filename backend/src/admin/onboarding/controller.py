from sqlalchemy.orm import Session

from src.admin.onboarding.dtos import OnboardingCreate
from src.model import Onboarding   # Assuming model is here
from src.utils.db import get_db


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