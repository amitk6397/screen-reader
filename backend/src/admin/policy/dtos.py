from typing import List, Optional
from enum import Enum as PyEnum
from pydantic import BaseModel, ConfigDict


class PolicyType(str, PyEnum):
    privacy_policy = "privacy_policy"
    terms_and_conditions = "terms_and_conditions"


class PolicyCreate(BaseModel):
    title: str
    description: str
    policy_type: PolicyType = PolicyType.privacy_policy


class PolicyUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    is_active: Optional[bool] = None
    policy_type: Optional[PolicyType] = None


class PolicyResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    title: str
    description: str
    policy_type: str
    is_active: bool


class PolicyListResponse(BaseModel):
    success: bool
    data: List[PolicyResponse]