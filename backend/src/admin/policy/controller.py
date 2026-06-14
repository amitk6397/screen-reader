# admin/policy/controller.py

from sqlalchemy.orm import Session
from fastapi import HTTPException

from src.model import Policy
from src.admin.policy.dtos import (
    PolicyCreate,
    PolicyUpdate
)


# =========================
# CREATE POLICY
# =========================
def create_policy(
    payload: PolicyCreate,
    db: Session
):

    policy = Policy(
        title=payload.title,
        description=payload.description
    )

    db.add(policy)
    db.commit()
    db.refresh(policy)

    return policy


# =========================
# GET ALL POLICIES
# =========================
def get_all_policies(db: Session):

    policies = (
        db.query(Policy)
        .order_by(Policy.created_at.desc())
        .all()
    )

    return policies


# =========================
# UPDATE POLICY
# =========================
def update_policy(
    policy_id: str,
    payload: PolicyUpdate,
    db: Session
):

    policy = (
        db.query(Policy)
        .filter(Policy.id == policy_id)
        .first()
    )

    if not policy:
        raise HTTPException(
            status_code=404,
            detail="Policy not found"
        )

    update_data = payload.model_dump(
        exclude_unset=True
    )

    for key, value in update_data.items():
        setattr(policy, key, value)

    db.commit()
    db.refresh(policy)

    return policy