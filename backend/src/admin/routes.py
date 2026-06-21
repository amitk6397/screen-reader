from fastapi import APIRouter

from src.admin.auth.routes import router as auth_router
from src.admin.onboarding.routes import router as onboarding_router
from src.admin.users.routes import router as users_router
from src.admin.policy.routes import router as policy_router
from src.admin.books.routes import router as books_router

router = APIRouter()

router.include_router(auth_router)
router.include_router(onboarding_router)
router.include_router(users_router)
router.include_router(policy_router)
router.include_router(books_router)
