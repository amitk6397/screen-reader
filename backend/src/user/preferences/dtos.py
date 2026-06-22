from typing import Optional
from pydantic import BaseModel, ConfigDict, Field


class PreferencesUpdate(BaseModel):
    voice_speed: Optional[float] = Field(None, ge=0.25, le=4.0)
    playback_speed: Optional[float] = Field(None, ge=0.25, le=4.0)
    sleep_timer_minutes: Optional[int] = Field(None, ge=0, le=120)
    font_size: Optional[str] = None       # small | medium | large
    screen_reader_enabled: Optional[bool] = None


class PreferencesResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    success: bool
    voice_speed: float
    playback_speed: float
    sleep_timer_minutes: int
    font_size: str
    screen_reader_enabled: bool
