from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from src.admin.routes import router as admin_router
from src.user.routes import router as user_router
from src import model
from src.utils.db import Base, engine

app = FastAPI(title="Backend API")

Base.metadata.create_all(bind=engine)

app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

app.include_router(admin_router, prefix="/admin", tags=["admin"])
app.include_router(user_router, prefix="/user", tags=["user"])


@app.get("/")
async def root():
    return {"message": "Backend API is running"}
