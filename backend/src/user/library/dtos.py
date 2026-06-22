from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel, ConfigDict, Field


# ── Request DTOs ──────────────────────────────────────────────────────────────

class AddBookToLibraryRequest(BaseModel):
    book_id: str


class UpdateProgressRequest(BaseModel):
    progress_percent: Optional[float] = Field(None, ge=0, le=100)
    status: Optional[str] = None          # in_progress | finished | saved
    minutes_listened: Optional[float] = None
    last_chapter: Optional[str] = None
    last_played_at: Optional[datetime] = None


# ── Nested Book Info ──────────────────────────────────────────────────────────

class BookInfo(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    title: str
    author: str
    description: str
    category: Optional[str] = None
    language: Optional[str] = None
    image_url: Optional[str] = None
    is_active: bool


# ── Response DTOs ─────────────────────────────────────────────────────────────

class LibraryItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    book_id: str
    progress_percent: float
    status: str
    minutes_listened: float
    last_chapter: Optional[str] = None
    last_played_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
    book: Optional[BookInfo] = None


class LibraryListResponse(BaseModel):
    success: bool
    data: List[LibraryItem]


class LibraryItemResponse(BaseModel):
    success: bool
    data: LibraryItem
    message: Optional[str] = None
