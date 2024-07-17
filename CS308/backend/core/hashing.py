from passlib.context import CryptContext
import string
import random
from core.config import settings
from cryptography.fernet import Fernet

pwd_cxt = CryptContext(schemes=["bcrypt"], deprecated="auto")


class Hash:
    def encode(data: str):
        f = Fernet(settings.HASH_KEY)
        encrypted_data = f.encrypt(bytes(data, 'utf-8'))
        return encrypted_data.decode()

    def decode(data: str):
        f = Fernet(settings.HASH_KEY)
        decrypted_data = f.decrypt(bytes(data, 'utf-8'))
        return decrypted_data.decode()

    def id_generator(size=6, chars=string.digits):
        return "".join(random.choice(chars) for _ in range(size))
