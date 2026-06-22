from datetime import datetime
from typing import Optional

from fastapi import HTTPException, status
from sqlalchemy.orm import Session, joinedload

from src.model import Book, Register, UserBookProgress
from src.user.library.dtos import (
    AddBookToLibraryRequest,
    LibraryItem,
    LibraryItemResponse,
    LibraryListResponse,
    UpdateProgressRequest,
)


def get_user_library(user: Register, status_filter: Optional[str], db: Session) -> LibraryListResponse:
    """Return all books in user's library, optionally filtered by status."""
    query = (
        db.query(UserBookProgress)
        .options(joinedload(UserBookProgress.book))
        .filter(UserBookProgress.user_id == user.id)
    )
    if status_filter and status_filter in ("in_progress", "finished", "saved"):
        query = query.filter(UserBookProgress.status == status_filter)

    items = query.order_by(UserBookProgress.updated_at.desc()).all()

    result = []
    for item in items:
        book_info = None
        if item.book:
            book_info = {
                "id": item.book.id,
                "title": item.book.title,
                "author": item.book.author,
                "description": item.book.description,
                "category": item.book.category,
                "language": item.book.language,
                "image_url": item.book.image_url,
                "is_active": item.book.is_active,
            }
        result.append(LibraryItem(
            id=item.id,
            book_id=item.book_id,
            progress_percent=item.progress_percent,
            status=item.status,
            minutes_listened=item.minutes_listened,
            last_chapter=item.last_chapter,
            last_played_at=item.last_played_at,
            updated_at=item.updated_at,
            book=book_info,
        ))

    return LibraryListResponse(success=True, data=result)


def add_book_to_library(user: Register, payload: AddBookToLibraryRequest, db: Session) -> LibraryItemResponse:
    """Add a book to the user's library (or return existing entry)."""
    book = db.query(Book).filter(Book.id == payload.book_id, Book.is_active.is_(True)).first()
    if not book:
        raise HTTPException(status_code=404, detail="Book not found")

    existing = (
        db.query(UserBookProgress)
        .filter(UserBookProgress.user_id == user.id, UserBookProgress.book_id == payload.book_id)
        .first()
    )
    if existing:
        return LibraryItemResponse(
            success=True,
            data=LibraryItem(
                id=existing.id,
                book_id=existing.book_id,
                progress_percent=existing.progress_percent,
                status=existing.status,
                minutes_listened=existing.minutes_listened,
                last_chapter=existing.last_chapter,
                last_played_at=existing.last_played_at,
                updated_at=existing.updated_at,
            ),
            message="Book already in library",
        )

    entry = UserBookProgress(user_id=user.id, book_id=payload.book_id)
    db.add(entry)
    db.commit()
    db.refresh(entry)

    return LibraryItemResponse(
        success=True,
        data=LibraryItem(
            id=entry.id,
            book_id=entry.book_id,
            progress_percent=entry.progress_percent,
            status=entry.status,
            minutes_listened=entry.minutes_listened,
            last_chapter=entry.last_chapter,
            last_played_at=entry.last_played_at,
            updated_at=entry.updated_at,
        ),
        message="Book added to library",
    )


def update_book_progress(
    user: Register, book_id: str, payload: UpdateProgressRequest, db: Session
) -> LibraryItemResponse:
    """Update reading/listening progress for a book in the user's library."""
    entry = (
        db.query(UserBookProgress)
        .filter(UserBookProgress.user_id == user.id, UserBookProgress.book_id == book_id)
        .first()
    )
    if not entry:
        # Auto-add if not present
        book = db.query(Book).filter(Book.id == book_id, Book.is_active.is_(True)).first()
        if not book:
            raise HTTPException(status_code=404, detail="Book not found")
        entry = UserBookProgress(user_id=user.id, book_id=book_id)
        db.add(entry)

    update_data = payload.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(entry, key, value)

    # Auto-mark finished when 100%
    if payload.progress_percent is not None and payload.progress_percent >= 100:
        entry.status = "finished"

    entry.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(entry)

    return LibraryItemResponse(
        success=True,
        data=LibraryItem(
            id=entry.id,
            book_id=entry.book_id,
            progress_percent=entry.progress_percent,
            status=entry.status,
            minutes_listened=entry.minutes_listened,
            last_chapter=entry.last_chapter,
            last_played_at=entry.last_played_at,
            updated_at=entry.updated_at,
        ),
        message="Progress updated",
    )


def remove_book_from_library(user: Register, book_id: str, db: Session):
    """Remove a book from the user's library."""
    entry = (
        db.query(UserBookProgress)
        .filter(UserBookProgress.user_id == user.id, UserBookProgress.book_id == book_id)
        .first()
    )
    if not entry:
        raise HTTPException(status_code=404, detail="Book not in library")
    db.delete(entry)
    db.commit()
    return {"success": True, "message": "Book removed from library"}
