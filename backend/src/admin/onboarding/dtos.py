from typing import List

from pydantic import BaseModel, ConfigDict, Field


class OnboardingCreate(BaseModel):
    title: str = Field(..., min_length=1, max_length=150)
    description: str = Field(..., min_length=1, max_length=1000)
    image_url: str | None = Field(default=None, max_length=500)
    sort_order: int = Field(default=0, ge=0)
    is_active: bool = True


class OnboardingResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    title: str
    description: str
    image_url: str | None
    sort_order: int
    is_active: bool

class OnboardingListResponse(BaseModel):
    success: bool
    data: List[OnboardingResponse]