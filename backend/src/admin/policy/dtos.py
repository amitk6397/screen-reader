# admin/policy/dtos.py

from typing import List, Optional
from pydantic import BaseModel, ConfigDict


class PolicyCreate(BaseModel):
    title: str
    description: str


class PolicyUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    is_active: Optional[bool] = None


class PolicyResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    title: str
    description: str
    is_active: bool


class PolicyListResponse(BaseModel):
    success: bool
    data: PolicyResponse