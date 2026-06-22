from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from src.model import Policy
from src.user.policy.dtos import PolicyListResponse, SinglePolicyResponse


def get_active_policies(db: Session) -> PolicyListResponse:
    """Return all active policies."""
    try:
        policies = (
            db.query(Policy)
            .filter(Policy.is_active.is_(True))
            .order_by(Policy.created_at.desc())
            .all()
        )
        return PolicyListResponse(success=True, data=policies)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Get policies failed: {str(e)}",
        )


def get_policy_by_type(policy_type: str, db: Session) -> SinglePolicyResponse:
    """Return the latest active policy of a given type."""
    try:
        policy = (
            db.query(Policy)
            .filter(Policy.is_active.is_(True), Policy.policy_type == policy_type)
            .order_by(Policy.created_at.desc())
            .first()
        )
        if not policy:
            return SinglePolicyResponse(success=True, data=None, message=f"No {policy_type} found")
        return SinglePolicyResponse(success=True, data=policy)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Get policy failed: {str(e)}",
        )
