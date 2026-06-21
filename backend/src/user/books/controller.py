from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from src.model import Book
from src.user.books.dtos import BookListResponse


def get_active_books(db: Session):
    """Return all active books ordered by newest first."""
    try:
        books = (
            db.query(Book)
            .filter(Book.is_active.is_(True))
            .order_by(Book.created_at.desc())
            .all()
        )
        return BookListResponse(success=True, data=books)

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Get books failed: {str(e)}",
        )


def get_week_books(db: Session):
    """Return books marked as Book of the Week."""
    try:
        books = (
            db.query(Book)
            .filter(Book.is_active.is_(True), Book.isWeek.is_(True))
            .order_by(Book.created_at.desc())
            .all()
        )
        return BookListResponse(success=True, data=books)

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Get week books failed: {str(e)}",
        )
