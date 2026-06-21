from datetime import datetime
import uuid
from sqlalchemy import Boolean, Column, DateTime, Integer, String, Text

from src.utils.db import Base


class Onboarding(Base):
    __tablename__ = "onboarding"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(150), nullable=False)
    description = Column(Text, nullable=False)
    image_url = Column(String(500), nullable=True)
    sort_order = Column(Integer, nullable=False, default=0)
    is_active = Column(Boolean, nullable=False, default=True)



class Register(Base):
    __tablename__ = "register"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    email = Column(String(100), nullable=False, unique=True)
    password = Column(String(255), nullable=False)
    is_active = Column(Boolean, nullable=False, default=True)
    is_superuser = Column(Boolean, nullable=False, default=False)
    profile_image = Column(String(500), nullable=True)


class Policy(Base):
    __tablename__ = "policy"

    # Primary Key
    id = Column(
        String(36),
        primary_key=True,
        index=True,
        default=lambda: str(uuid.uuid4())
    )
    title = Column(
        String(150),
        nullable=False
    )
    description = Column(
        Text,
        nullable=False
    )
    is_active = Column(
        Boolean,
        default=True
    )
    version = Column(
        String(20),
        default="1.0"
    )
    created_at = Column(
    DateTime,
    default=datetime.utcnow
)

updated_at = Column(
    DateTime,
    default=datetime.utcnow,
    onupdate=datetime.utcnow
)


class Book(Base):
    __tablename__ = "books"

    id = Column(
        String(36),
        primary_key=True,
        index=True,
        default=lambda: str(uuid.uuid4())
    )
    title = Column(String(150), nullable=False)
    author = Column(String(150), nullable=False)
    description = Column(Text, nullable=False)
    category = Column(String(100), nullable=True)
    language = Column(String(50), nullable=True)
    pdf_url = Column(String(500), nullable=False)
    image_url = Column(String(500), nullable=False)
    is_active = Column(Boolean, nullable=False, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow
    )
    isWeek = Column(Boolean, default=False)
