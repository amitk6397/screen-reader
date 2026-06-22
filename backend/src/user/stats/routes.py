from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from src.utils.db import get_db
from src.utils.auth_dependency import get_current_user
from src.model import Register
from src.user.stats.controller import get_user_stats
from src.user.stats.dtos import UserStatsResponse

router = APIRouter(prefix="/stats", tags=["User Stats"])


@router.get("", response_model=UserStatsResponse)
def get_stats_endpoint(
    current_user: Register = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """
    Get reading/listening statistics for the logged-in user.
    Returns: books_read, books_in_progress, hours_listened, day_streak.
    """
    return get_user_stats(current_user, db)
