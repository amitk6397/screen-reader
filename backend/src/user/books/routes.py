from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from src.user.books.controller import get_active_books, get_week_books
from src.user.books.dtos import BookListResponse
from src.utils.db import get_db

router = APIRouter(
    prefix="/books",
    tags=["User Books"]
)


@router.get("", response_model=BookListResponse)
def get_books_endpoint(db: Session = Depends(get_db)):
    """Get all active books for the user app."""
    return get_active_books(db)


@router.get("/week", response_model=BookListResponse)
def get_week_books_endpoint(db: Session = Depends(get_db)):
    """Get books marked as Book of the Week (home screen featured section)."""
    return get_week_books(db)
