from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from src.utils.db import get_db
from src.user.policy.controller import get_active_policies, get_policy_by_type
from src.user.policy.dtos import PolicyListResponse, SinglePolicyResponse

router = APIRouter(prefix="/policy", tags=["User Policy"])


@router.get("", response_model=PolicyListResponse)
def get_policies_endpoint(db: Session = Depends(get_db)):
    """Get all active policies."""
    return get_active_policies(db)


@router.get("/privacy", response_model=SinglePolicyResponse)
def get_privacy_policy_endpoint(db: Session = Depends(get_db)):
    """Get the active Privacy Policy."""
    return get_policy_by_type("privacy_policy", db)


@router.get("/terms", response_model=SinglePolicyResponse)
def get_terms_endpoint(db: Session = Depends(get_db)):
    """Get the active Terms & Conditions."""
    return get_policy_by_type("terms_and_conditions", db)
