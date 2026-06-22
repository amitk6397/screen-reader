from typing import Optional

from fastapi import APIRouter, Depends, File, Form, UploadFile, status
from sqlalchemy.orm import Session

from src.admin.onboarding.controller import (
    create_onboarding,
    delete_onboarding,
    get_all_onboarding,
    update_onboarding,
)
from src.admin.onboarding.dtos import OnboardingListResponse, OnboardingResponse
from src.utils.db import get_db

router = APIRouter(prefix="/onboarding", tags=["Admin Onboarding"])


# POST - Create Onboarding (multipart/form-data to support image upload)
@router.post(
    "",
    response_model=OnboardingResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_onboarding_endpoint(
    title: str = Form(...),
    description: str = Form(...),
    sort_order: int = Form(default=0),
    is_active: bool = Form(default=True),
    image: Optional[UploadFile] = File(default=None),
    image_url: Optional[str] = Form(default=None),
    db: Session = Depends(get_db),
):
    return create_onboarding(
        title=title,
        description=description,
        sort_order=sort_order,
        is_active=is_active,
        db=db,
        image=image,
        image_url=image_url,
    )


# GET - Get All Onboarding Items
@router.get("", response_model=OnboardingListResponse)
def get_all_onboarding_endpoint(db: Session = Depends(get_db)):
    return OnboardingListResponse(success=True, data=get_all_onboarding(db))


# PUT - Update Onboarding (multipart/form-data to support image upload)
@router.put("/{item_id}", response_model=OnboardingResponse)
def update_onboarding_endpoint(
    item_id: int,
    title: Optional[str] = Form(default=None),
    description: Optional[str] = Form(default=None),
    sort_order: Optional[int] = Form(default=None),
    is_active: Optional[bool] = Form(default=None),
    image: Optional[UploadFile] = File(default=None),
    image_url: Optional[str] = Form(default=None),
    db: Session = Depends(get_db),
):
    return update_onboarding(
        item_id=item_id,
        db=db,
        title=title,
        description=description,
        sort_order=sort_order,
        is_active=is_active,
        image=image,
        image_url=image_url,
    )


# DELETE - Delete Onboarding
@router.delete("/{item_id}")
def delete_onboarding_endpoint(item_id: int, db: Session = Depends(get_db)):
    return delete_onboarding(item_id, db)
