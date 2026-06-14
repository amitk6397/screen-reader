from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from src.utils.db import get_db

from src.admin.users.controller import (
    get_all_user,
    block_unblock_user,
    delete_user
)

from src.admin.users.dtos import (
    UserListResponse,
    CommonResponse
)

router = APIRouter(
    prefix="/users",
    tags=["Admin Users"]
)


@router.get("", response_model=UserListResponse)
def get_all_users(
    db: Session = Depends(get_db)
):
    return get_all_user(db)


@router.put(
    "/block-unblock/{user_id}",
    response_model=CommonResponse
)
def update_user_status(
    user_id: int,
    db: Session = Depends(get_db)
):
    return block_unblock_user(user_id, db)


@router.delete(
    "/{user_id}",
    response_model=CommonResponse
)
def remove_user(
    user_id: int,
    db: Session = Depends(get_db)
):
    return delete_user(user_id, db)