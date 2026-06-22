from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from src.model import Register, UserPreferences
from src.user.preferences.dtos import PreferencesResponse, PreferencesUpdate


def _get_or_create(user: Register, db: Session) -> UserPreferences:
    prefs = db.query(UserPreferences).filter(UserPreferences.user_id == user.id).first()
    if not prefs:
        prefs = UserPreferences(user_id=user.id)
        db.add(prefs)
        db.commit()
        db.refresh(prefs)
    return prefs


def get_preferences(user: Register, db: Session) -> PreferencesResponse:
    prefs = _get_or_create(user, db)
    return PreferencesResponse(
        success=True,
        voice_speed=prefs.voice_speed,
        playback_speed=prefs.playback_speed,
        sleep_timer_minutes=prefs.sleep_timer_minutes,
        font_size=prefs.font_size,
        screen_reader_enabled=prefs.screen_reader_enabled,
    )


def update_preferences(user: Register, payload: PreferencesUpdate, db: Session) -> PreferencesResponse:
    prefs = _get_or_create(user, db)
    update_data = payload.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(prefs, key, value)
    db.commit()
    db.refresh(prefs)
    return PreferencesResponse(
        success=True,
        voice_speed=prefs.voice_speed,
        playback_speed=prefs.playback_speed,
        sleep_timer_minutes=prefs.sleep_timer_minutes,
        font_size=prefs.font_size,
        screen_reader_enabled=prefs.screen_reader_enabled,
    )
