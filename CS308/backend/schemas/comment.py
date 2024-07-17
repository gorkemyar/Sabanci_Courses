from typing import Optional, List

from pydantic import BaseModel
from pydantic import Extra
from schemas import User

class CommentBase(BaseModel):
    id: int
    product_id: int
    content: str
    rate: int
    is_active: bool

    class Config:
        orm_mode = True


class CommentCreate(BaseModel):
    content: str
    rate: int

    class Config:
        extra = Extra.allow

class CommentUpdateActive(BaseModel):
    is_active: bool

class CommentUpdate(CommentCreate):
    pass


class CommentInDBBase(CommentBase):
    id: Optional[int] = None

    class Config:
        orm_mode = True

class Comment(CommentInDBBase):
    user: User

class CommentList(BaseModel):
    comments: List[CommentBase]

    class Config:
        orm_mode = True
