from pydantic import BaseModel


class UserData(BaseModel):
    id: int
    username: str
    email: str
    is_active: bool
    is_superuser: bool


class UserListResponse(BaseModel):
    success: bool
    data: list[UserData]


class CommonResponse(BaseModel):
    success: bool
    message: str