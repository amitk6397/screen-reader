from sqlalchemy.orm import Session
from fastapi import HTTPException

from src.model import Policy
from src.admin.policy.dtos import PolicyCreate, PolicyUpdate


def create_policy(payload: PolicyCreate, db: Session):
    policy = Policy(
        title=payload.title,
        description=payload.description,
        policy_type=payload.policy_type.value,
    )
    db.add(policy)
    db.commit()
    db.refresh(policy)
    return policy


def get_all_policies(db: Session):
    return db.query(Policy).order_by(Policy.created_at.desc()).all()


def update_policy(policy_id: str, payload: PolicyUpdate, db: Session):
    policy = db.query(Policy).filter(Policy.id == policy_id).first()
    if not policy:
        raise HTTPException(status_code=404, detail="Policy not found")

    update_data = payload.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        # Convert enum to string value
        setattr(policy, key, value.value if hasattr(value, 'value') else value)

    db.commit()
    db.refresh(policy)
    return policy


def delete_policy(policy_id: str, db: Session):
    policy = db.query(Policy).filter(Policy.id == policy_id).first()
    if not policy:
        raise HTTPException(status_code=404, detail="Policy not found")
    db.delete(policy)
    db.commit()
    return {"success": True, "message": "Policy deleted successfully"}
