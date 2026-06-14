from typing import List, Optional

from pydantic import BaseModel, ConfigDict


class OnboardingResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    title: str
    description: str
    image_url: str | None = None
    sort_order: int
    is_active: bool


class OnboardingListResponse(BaseModel):
    success: bool
    data: List[OnboardingResponse]


class RegisterRequest(BaseModel):
    name: str
    email: str
    password: str


class RegisterResponseData(BaseModel):          # User data jo return hoga
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    name: str
    email: str
    token: str
    # password mat bhejna (security ke liye)


class RegisterResponse(BaseModel):
    success: bool
    message: str
    data: Optional[RegisterResponseData] = None


# login 

class LoginRequest(BaseModel):
    email: str
    password: str

class LoginResponseData(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    name: str
    email: str
    token: str
   
class LoginResponse(BaseModel):
    success: bool
    message: str
    data: Optional[LoginResponseData] = None


# forgot password 

class ForgotPasswordRequest(BaseModel):
    email: str

class ForgotPasswordResponse(BaseModel):
    success: bool
    message: str


# confirm password

class ConfirmPasswordRequest(BaseModel):
    email: str
    new_password: str
    confirm_password: str

class ConfirmPasswordResponse(BaseModel):
    success: bool
    message: str