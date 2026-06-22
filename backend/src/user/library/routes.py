from typing import Optional

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from src.utils.db import get_db
from src.utils.auth_dependency import get_current_user
from src.model import Register
from src.user.library.controller import (
    add_book_to_library,
    get_user_library,
    remove_book_from_library,
    update_book_progress,
)
from src.user.library.dtos import (
    AddBookToLibraryRequest,
    LibraryItemResponse,
    LibraryListResponse,
    UpdateProgressRequest,
)

router = APIRouter(prefix="/library", tags=["User Library"])


@router.get("", response_model=LibraryListResponse)
def get_library_endpoint(
    status: Optional[str] = None,
    current_user: Register = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    Get user's library. Optional ?status=in_progress|finished|saved filter.
    """
    return get_user_library(current_user, status, db)


@router.post("", response_model=LibraryItemResponse)
def add_to_library_endpoint(
    payload: AddBookToLibraryRequest,
    current_user: Register = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Add a book to the user's library."""
    return add_book_to_library(current_user, payload, db)


@router.put("/{book_id}", response_model=LibraryItemResponse)
def update_progress_endpoint(
    book_id: str,
    payload: UpdateProgressRequest,
    current_user: Register = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Update reading/listening progress for a book."""
    return update_book_progress(current_user, book_id, payload, db)


@router.delete("/{book_id}")
def remove_from_library_endpoint(
    book_id: str,
    current_user: Register = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Remove a book from the user's library."""
    return remove_book_from_library(current_user, book_id, db)
