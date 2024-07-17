from pydantic import BaseModel, validator, Extra
from core.hashing import Hash


class CreditPrivate(BaseModel):
    card_name: str
    payment_method: str
    cardnumber: str


class CreditBase(BaseModel):
    payment_method: str
    card_name: str
    cardnumber: str
    CW: str
    expiry_date: str

   

    class Config:
        extra = Extra.allow
        orm_mode = True


class CreditCreate(CreditBase):
    pass


class CreditUpdate(CreditBase):
    pass


class CreditInDBBase(CreditBase):
    id: int
    user_id: int
