from fastapi import APIRouter

from src.user.auth.routes import router as auth_router
from src.user.books.routes import router as books_router

router = APIRouter()

router.include_router(auth_router)
router.include_router(books_router)
