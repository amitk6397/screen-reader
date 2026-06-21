from fastapi import APIRouter, status, Depends
from src.utils.db import get_db

from src.admin.onboarding.controller import (
    create_onboarding,
    delete_onboarding,
    get_all_onboarding,
    update_onboarding
)
from src.admin.onboarding.dtos import OnboardingCreate, OnboardingResponse, OnboardingListResponse, OnboardingUpdate

router = APIRouter(prefix="/onboarding", tags=["Admin Onboarding"])


# POST - Create Onboarding
@router.post(
    "",
    response_model=OnboardingResponse,
    status_code=status.HTTP_201_CREATED
)
def create_onboarding_endpoint(
    payload: OnboardingCreate,
    db=Depends(get_db)   # Better to use Depends here
):
    return create_onboarding(payload, db)


# GET - Get All Onboarding Items
@router.get(
    "",
    response_model=OnboardingListResponse
)
def get_all_onboarding_endpoint(db=Depends(get_db)):
    return OnboardingListResponse(success=True, data=get_all_onboarding(db))


@router.put("/{item_id}", response_model=OnboardingResponse)
def update_onboarding_endpoint(
    item_id: int,
    payload: OnboardingUpdate,
    db=Depends(get_db)
):
    return update_onboarding(item_id, payload, db)


@router.delete("/{item_id}")
def delete_onboarding_endpoint(item_id: int, db=Depends(get_db)):
    return delete_onboarding(item_id, db)
