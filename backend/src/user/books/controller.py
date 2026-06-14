from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from src.model import Book
from src.user.books.dtos import BookListResponse


def get_active_books(db: Session):
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
            detail=f"Get books failed: {str(e)}"
        )
