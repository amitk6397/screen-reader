from typing import List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from src.utils.db import get_db
from src.admin.policy.controller import create_policy, delete_policy, get_all_policies, update_policy
from src.admin.policy.dtos import PolicyCreate, PolicyUpdate, PolicyResponse

router = APIRouter(prefix="/policy", tags=["Admin Policy"])


@router.post("", response_model=PolicyResponse)
def create_policy_api(payload: PolicyCreate, db: Session = Depends(get_db)):
    return create_policy(payload, db)


@router.get("", response_model=List[PolicyResponse])
def get_policies_api(db: Session = Depends(get_db)):
    return get_all_policies(db)


@router.put("/{policy_id}", response_model=PolicyResponse)
def update_policy_api(policy_id: str, payload: PolicyUpdate, db: Session = Depends(get_db)):
    return update_policy(policy_id, payload, db)


@router.delete("/{policy_id}")
def delete_policy_api(policy_id: str, db: Session = Depends(get_db)):
    return delete_policy(policy_id, db)
