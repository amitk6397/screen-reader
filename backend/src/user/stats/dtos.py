from pydantic import BaseModel


class UserStatsResponse(BaseModel):
    success: bool
    books_read: int          # count of books with status='finished'
    books_in_progress: int   # count with status='in_progress'
    books_saved: int         # count with status='saved'
    total_books: int         # total in library
    hours_listened: float    # total minutes_listened / 60
    minutes_listened: float  # raw minutes
    day_streak: int          # consecutive days with activity
