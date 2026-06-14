from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from src.user.books.controller import get_active_books
from src.user.books.dtos import BookListResponse
from src.utils.db import get_db

router = APIRouter(
    prefix="/books",
    tags=["User Books"]
)


@router.get("", response_model=BookListResponse)
def get_books_endpoint(db: Session = Depends(get_db)):
    return get_active_books(db)
