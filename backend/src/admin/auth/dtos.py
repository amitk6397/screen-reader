from pydantic import BaseModel, EmailStr


class AdminLoginRequest(BaseModel):
    email: EmailStr
    password: str


class AdminLoginData(BaseModel):
    id: int
    name: str
    email: EmailStr
    token: str
    is_superuser: bool = True


class AdminLoginResponse(BaseModel):
    success: bool
    message: str
    data: AdminLoginData | None = None


class AdminForgotRequest(BaseModel):
    email: EmailStr | None = None


class AdminForgotData(BaseModel):
    email: EmailStr
    password: str


class AdminForgotResponse(BaseModel):
    success: bool
    message: str
    data: AdminForgotData | None = None
