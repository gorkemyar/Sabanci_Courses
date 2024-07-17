from typing import Optional, List

from pydantic import BaseModel, validator
from utilities.image import ImageUtilities
from schemas.base import CustomBase

class ProductPhotoBase(BaseModel):
    id: int
    photo_url: str
    is_active: bool

    @validator("photo_url")
    def static_image(cls, photo_url):
        return ImageUtilities.get_image_url(photo_url)

    class Config:
        orm_mode = True


# Shared properties
class ProductBase(BaseModel):
    title: str
    description: str
    distributor: str
    stock: int
    price: float
    model: str
    number: str


# Properties to receive via API on creation
class ProductCreate(ProductBase, CustomBase):
    category_id: int
    subcategory_id: int

    class Config:
        exclude = {"category_id", "subcategory_id"}


# Properties to receive via API on update
class ProductUpdate(ProductCreate):
    pass


class ProductInDBBase(ProductBase):
    id: int

    class Config:
        orm_mode = True


class Product(ProductInDBBase):
    category_title: Optional[str]
    subcategory_title: Optional[str]
    
    photos: List[ProductPhotoBase] = []
    comment_count: int
    rate: Optional[float]
    rate_count: Optional[float]
    discount: Optional[int]