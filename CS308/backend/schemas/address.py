from typing import Optional, List

from pydantic import BaseModel
from pydantic import Extra


class AddressBase(BaseModel):
    name: str
    full_address: str
    postal_code: str
    city: str
    province: str
    country: str
    personal_name: str
    phone_number: str
    

    class Config:
        extra = Extra.allow
        orm_mode = True


class AddressCreate(AddressBase):
    pass


class AddressUpdate(AddressBase):
    pass


class AddressInDBBase(AddressBase):
    id: int
    user_id: int