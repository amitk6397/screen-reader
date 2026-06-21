from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel, ConfigDict


class PolicyItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    title: str
    description: str
    is_active: bool
    version: Optional[str] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None


class PolicyListResponse(BaseModel):
    success: bool
    data: List[PolicyItem]
