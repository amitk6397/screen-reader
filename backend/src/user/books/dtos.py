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
    created_at: datetime | None = None


class BookListResponse(BaseModel):
    success: bool
    data: List[BookResponse]
