from datetime import datetime
from typing import List

from pydantic import BaseModel, ConfigDict


class BookResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    title: str
    author: str
    description: str
    category: str | None = None
    language: str | None = None
    pdf_url: str
    image_url: str
    is_active: bool
    created_at: datetime | None = None
    isWeek: bool | None = None


class BookUpdate(BaseModel):
    title: str | None = None
    author: str | None = None
    description: str | None = None
    category: str | None = None
    language: str | None = None
    is_active: bool | None = None
    isWeek: bool | None = None


class BookListResponse(BaseModel):
    success: bool
    data: List[BookResponse]
