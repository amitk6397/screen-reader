from datetime import date, datetime, timedelta

from sqlalchemy import func
from sqlalchemy.orm import Session

from src.model import Register, UserBookProgress
from src.user.stats.dtos import UserStatsResponse


def get_user_stats(user: Register, db: Session) -> UserStatsResponse:
    """Compute reading stats for the user from their library data."""

    entries = db.query(UserBookProgress).filter(UserBookProgress.user_id == user.id).all()

    books_read = sum(1 for e in entries if e.status == "finished")
    books_in_progress = sum(1 for e in entries if e.status == "in_progress")
    books_saved = sum(1 for e in entries if e.status == "saved")
    total_books = len(entries)
    total_minutes = sum(e.minutes_listened or 0 for e in entries)

    # Day streak — count consecutive days (up to today) with last_played_at activity
    day_streak = _compute_streak(entries)

    return UserStatsResponse(
        success=True,
        books_read=books_read,
        books_in_progress=books_in_progress,
        books_saved=books_saved,
        total_books=total_books,
        hours_listened=round(total_minutes / 60, 1),
        minutes_listened=round(total_minutes, 1),
        day_streak=day_streak,
    )


def _compute_streak(entries) -> int:
    """Compute consecutive day streak ending today (or yesterday)."""
    active_dates = set()
    for e in entries:
        if e.last_played_at:
            active_dates.add(e.last_played_at.date())

    if not active_dates:
        return 0

    today = date.today()
    streak = 0
    check = today

    # If today has no activity, start from yesterday
    if today not in active_dates:
        check = today - timedelta(days=1)

    while check in active_dates:
        streak += 1
        check -= timedelta(days=1)

    return streak
