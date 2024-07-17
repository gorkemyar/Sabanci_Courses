import random
import string
from typing import Dict

from fastapi.testclient import TestClient

from core.config import settings

def random_integer() -> int:
    return random.randint(0, 100)

def random_lower_string() -> str:
    return "".join(random.choices(string.ascii_lowercase, k=32))


def random_email() -> str:
    return f"{random_lower_string()}@{random_lower_string()}.com"