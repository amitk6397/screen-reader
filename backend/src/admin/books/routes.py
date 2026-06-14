from fastapi import APIRouter, Depends, File, Form, UploadFile, status
from sqlalchemy.orm import Session

from src.admin.books.controller import create_book, get_all_books
from src.admin.books.dtos import BookListResponse, BookResponse
from src.utils.db import get_db

router = APIRouter(
    prefix="/books",
    tags=["Admin Books"]
)


@router.post(
    "",
    response_model=BookResponse,
    status_code=status.HTTP_201_CREATED
)
def create_book_endpoint(
    title: str = Form(...),
    author: str = Form(...),
    description: str = Form(...),
    category: str | None = Form(default=None),
    language: str | None = Form(default=None),
    book_pdf: UploadFile = File(...),
    image: UploadFile = File(...),
    db: Session = Depends(get_db)
):
    return create_book(
        title,
        author,
        description,
        category,
        language,
        book_pdf,
        image,
        db
    )


@router.get("", response_model=BookListResponse)
def get_books_endpoint(db: Session = Depends(get_db)):
    return get_all_books(db)
