from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from src.model import Policy
from src.user.policy.dtos import PolicyListResponse


def get_active_policies(db: Session) -> PolicyListResponse:
    """Return all active policies for the user app."""
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
