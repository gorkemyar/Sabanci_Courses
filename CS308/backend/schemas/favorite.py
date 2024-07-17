#a pydantic model for the favorite table, this table is a many to many relationship between users and products
from pydantic import BaseModel
from pydantic import Extra

class FavoriteBase(BaseModel):
    product_id: int

    class Config:
        extra = Extra.allow
        orm_mode = True

class FavoriteCreate(FavoriteBase):
    pass

class FavoriteUpdate(FavoriteBase):
    pass

class FavoriteInDBBase(FavoriteBase):
    id: int
    user_id: int

    class Config:
        orm_mode = True