from fastapi import APIRouter

from src.user.auth.routes import router as auth_router
from src.user.books.routes import router as books_router
from src.user.policy.routes import router as policy_router
from src.user.after_login.routes import router as profile_router

router = APIRouter()

router.include_router(auth_router)
router.include_router(books_router)
router.include_router(policy_router)
router.include_router(profile_router)
