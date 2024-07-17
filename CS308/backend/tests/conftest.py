import warnings
import os
import pytest

from typing import Dict, Generator
from asgi_lifespan import LifespanManager

from fastapi import FastAPI
from main import app
import alembic
from alembic.config import Config

from fastapi.testclient import TestClient
from db.session import SessionLocal
from sqlalchemy.orm import Session
from core.config import settings
from tests.utils.user import authentication_token_from_email

# Apply migrations at beginning and end of testing session
@pytest.fixture(scope="session")
def apply_migrations():
    warnings.filterwarnings("ignore", category=DeprecationWarning)
    os.environ["TESTING"] = "1"
    config = Config("alembic.ini")

    alembic.command.upgrade(config, "head")
    yield
    alembic.command.downgrade(config, "base")


# Grab a reference to our database when needed
@pytest.fixture(scope="session")
def db() -> Generator:
    yield SessionLocal()


# Make requests in our tests
@pytest.fixture(scope="module")
def client() -> Generator:
    with TestClient(app) as c:
        yield c

@pytest.fixture(scope="module")
def normal_user_token_headers(client: TestClient, db: Session) -> Dict[str, str]:
    return authentication_token_from_email(
        client=client, email=settings.TEST_SUPERUSER_EMAIL, db=db
    )