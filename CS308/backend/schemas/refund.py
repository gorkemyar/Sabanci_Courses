from datetime import datetime
from pydantic import BaseModel, validator, Extra
from typing import List
from schemas.order import OrderItem

class RefundRequestBase(BaseModel):
    reason: str
    orderitem: OrderItem
    status: bool
    
    class Config:
        orm_mode = True

class RefundCreate(BaseModel):
    reason: str
    orderitem_id: int


    class Config:
        orm_mode = True

class RefundUpdate(BaseModel):
    status: bool


    class Config:
        orm_mode = True