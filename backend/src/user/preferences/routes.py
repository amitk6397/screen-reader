from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from src.utils.db import get_db
from src.utils.auth_dependency import get_current_user
from src.model import Register
from src.user.preferences.controller import get_preferences, update_preferences
from src.user.preferences.dtos import PreferencesResponse, PreferencesUpdate

router = APIRouter(prefix="/preferences", tags=["User Preferences"])


@router.get("", response_model=PreferencesResponse)
def get_preferences_endpoint(
    current_user: Register = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get user's app preferences (voice speed, playback, sleep timer, font size)."""
    return get_preferences(current_user, db)


@router.put("", response_model=PreferencesResponse)
def update_preferences_endpoint(
    payload: PreferencesUpdate,
    current_user: Register = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Update user's app preferences. All fields optional — only updates provided fields."""
    return update_preferences(current_user, payload, db)
