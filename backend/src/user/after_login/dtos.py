from typing import Optional
from pydantic import BaseModel, ConfigDict


class ProfileResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    success: bool
    message: str
    data: Optional["ProfileData"] = None


class ProfileData(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    email: str
    is_active: bool
    profile_image: Optional[str] = None


class ProfileUpdate(BaseModel):
    name: Optional[str] = None
    profile_image: Optional[str] = None


ProfileResponse.model_rebuild()
