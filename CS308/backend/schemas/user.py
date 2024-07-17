from typing import List, Optional

from pydantic import BaseModel, EmailStr
from models.user import UserType

from schemas.address import AddressBase
from schemas.credit import CreditBase
from schemas.favorite import FavoriteBase


# Shared properties
class UserBase(BaseModel):
    email: Optional[EmailStr] = None
    is_active: Optional[bool] = True
    full_name: Optional[str] = None
    user_type: Optional[UserType] = UserType.CUSTOMER


# Properties to receive via API on creation
class UserCreate(UserBase):
    email: EmailStr
    password: str


# Properties to receive via API on update
class UserUpdate(UserBase):
    pass
    #password: Optional[str] = None




class UserInDBBase(UserBase):
    id: Optional[int] = None

    class Config:
        orm_mode = True


# Additional properties to return via API
class User(UserInDBBase):
    pass


# Additional properties stored in DB
class UserInDB(UserInDBBase):
    hashed_password: str

class UserAddresses(UserBase):
    id: int
    addresses: List[AddressBase]

class UserCredits(UserBase):
    id: int
    credits: List[CreditBase]

class UserFavorite(UserBase):
    id: int
    favorite: List[FavoriteBase]

class ChangePasswordIn(BaseModel):
    current_password: str
    new_password: str #we assume that the front end will check if the password is iinserted correctly, meaning like many other online services we too will check for typos by requesting that the password is enterd twice and compared