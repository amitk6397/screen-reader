from datetime import datetime
import uuid
from sqlalchemy import Boolean, Column, DateTime, Enum, Float, ForeignKey, Integer, String, Text
from sqlalchemy.orm import relationship

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


class Policy(Base):
    __tablename__ = "policy"

    id = Column(
        String(36),
        primary_key=True,
        index=True,
        default=lambda: str(uuid.uuid4())
    )
    title = Column(String(150), nullable=False)
    description = Column(Text, nullable=False)
    # 'privacy_policy' or 'terms_and_conditions'
    policy_type = Column(
        String(30),
        nullable=False,
        default="privacy_policy"
    )
    is_active = Column(Boolean, default=True)
    version = Column(String(20), default="1.0")
    created_at = Column(DateTime, default=datetime.utcnow)


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
    isWeek = Column(Boolean, default=False)


class UserBookProgress(Base):
    """Tracks per-user reading/listening progress for each book."""
    __tablename__ = "user_book_progress"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("register.id", ondelete="CASCADE"), nullable=False, index=True)
    book_id = Column(String(36), ForeignKey("books.id", ondelete="CASCADE"), nullable=False, index=True)
    progress_percent = Column(Float, default=0.0)        # 0.0 – 100.0
    status = Column(
        String(20),
        nullable=False,
        default="in_progress"                            # in_progress | finished | saved
    )
    minutes_listened = Column(Float, default=0.0)         # total minutes listened
    last_chapter = Column(String(200), nullable=True)    # e.g. "Chapter 8"
    last_played_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationship
    book = relationship("Book", foreign_keys=[book_id], lazy="select")


class UserPreferences(Base):
    """Stores per-user app preferences (voice, playback, accessibility)."""
    __tablename__ = "user_preferences"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("register.id", ondelete="CASCADE"), nullable=False, unique=True)
    voice_speed = Column(Float, default=1.0)             # TTS speed multiplier
    playback_speed = Column(Float, default=1.0)          # Audio playback speed
    sleep_timer_minutes = Column(Integer, default=0)     # 0 = disabled
    font_size = Column(String(20), default="medium")     # small | medium | large
    screen_reader_enabled = Column(Boolean, default=True)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
