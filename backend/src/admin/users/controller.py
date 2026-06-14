from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from src.admin.users.dtos import (
    UserData,
    UserListResponse,
    CommonResponse
)

from src.model import Register


def get_all_user(db: Session):
    try:
        users = db.query(Register).order_by(Register.id.asc()).all()

        return UserListResponse(
            success=True,
            data=[
                UserData(
                    id=user.id,
                    username=user.name,
                    email=user.email,
                    is_active=user.is_active,
                    is_superuser=user.is_superuser
                )
                for user in users
            ]
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


def block_unblock_user(user_id: int, db: Session):
    try:
        user = db.query(Register).filter(
            Register.id == user_id
        ).first()

        if not user:
            return CommonResponse(
                success=False,
                message="User not found"
            )

        # Toggle active status
        user.is_active = not user.is_active

        db.commit()
        db.refresh(user)

        return CommonResponse(
            success=True,
            message="User status updated successfully"
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


def delete_user(user_id: int, db: Session):
    try:
        user = db.query(Register).filter(
            Register.id == user_id
        ).first()

        if not user:
            return CommonResponse(
                success=False,
                message="User not found"
            )

        db.delete(user)
        db.commit()

        return CommonResponse(
            success=True,
            message="User deleted successfully"
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )