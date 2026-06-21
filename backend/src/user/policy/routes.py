from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from src.utils.db import get_db
from src.user.policy.controller import get_active_policies
from src.user.policy.dtos import PolicyListResponse

router = APIRouter(
    prefix="/policy",
    tags=["User Policy"],
)


@router.get("", response_model=PolicyListResponse)
def get_policies_endpoint(db: Session = Depends(get_db)):
    """Get all active policies for the user app."""
    return get_active_policies(db)
