import os
import uuid

from fastapi import HTTPException, UploadFile, status
from sqlalchemy.orm import Session

from src.admin.books.dtos import BookListResponse
from src.model import Book

UPLOAD_DIR = "uploads/books"
PDF_DIR = os.path.join(UPLOAD_DIR, "pdf")
IMAGE_DIR = os.path.join(UPLOAD_DIR, "images")


def _save_upload_file(file: UploadFile, folder: str, allowed_prefix: str | None = None, allowed_content_type: str | None = None):
    if allowed_content_type and file.content_type != allowed_content_type:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"{file.filename} must be a PDF file"
        )

    if allowed_prefix and not (file.content_type or "").startswith(allowed_prefix):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"{file.filename} must be an image file"
        )

    os.makedirs(folder, exist_ok=True)
    extension = os.path.splitext(file.filename or "")[1].lower()
    filename = f"{uuid.uuid4()}{extension}"
    file_path = os.path.join(folder, filename)

    with open(file_path, "wb") as buffer:
        buffer.write(file.file.read())

    return file_path.replace("\\", "/")


def create_book(
    title: str,
    author: str,
    description: str,
    category: str | None,
    language: str | None,
    book_pdf: UploadFile,
    image: UploadFile,
    db: Session
):
    try:
        pdf_path = _save_upload_file(
            book_pdf,
            PDF_DIR,
            allowed_content_type="application/pdf"
        )
        image_path = _save_upload_file(
            image,
            IMAGE_DIR,
            allowed_prefix="image/"
        )

        book = Book(
            title=title,
            author=author,
            description=description,
            category=category,
            language=language,
            pdf_url=f"/{pdf_path}",
            image_url=f"/{image_path}"
        )

        db.add(book)
        db.commit()
        db.refresh(book)

        return book

    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Create book failed: {str(e)}"
        )


def get_all_books(db: Session):
    try:
        books = db.query(Book).order_by(Book.created_at.desc()).all()
        return BookListResponse(success=True, data=books)

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Get books failed: {str(e)}"
        )
