from typing import Optional, List

from pydantic import BaseModel, Field, validator, Extra
from utilities.image import ImageUtilities
import schemas.product

"""
SubCategory
"""


class SubCategoryBase(BaseModel):
    id: int = Field(alias="subcategory_id")
    title: str = Field(alias="subcategory_title")
    order_id: Optional[int] = 0

    class Config:
        orm_mode = True
        allow_population_by_field_name = True


class SubCategoryCreate(BaseModel):
    title: str
    order_id: Optional[int] = 0
    
    class Config:
        orm_mode = True
        allow_population_by_field_name = True


class SubCategoryUpdate(SubCategoryCreate):
    category_id: Optional[int] = None


class SubCategoryList(BaseModel):
    categories: List[SubCategoryBase]

    class Config:
        orm_mode = True
        allow_population_by_field_name = True


"""
Category schemas
"""


class CategoryBase(BaseModel):
    title: str = Field(alias="category_title")
    order_id: Optional[int] = 0

    class Config:
        allow_population_by_field_name = True


class CategoryCreate(CategoryBase):
    title: str
    order_id: Optional[int] = 0


class CategoryUpdate(CategoryCreate):
    pass


class CategoryInDBBase(CategoryBase):
    id: int = Field(alias="category_id")
    image_url: str

    @validator("image_url")
    def static_image(cls, image_url):
        return ImageUtilities.get_image_url(image_url)

    class Config:
        orm_mode = True


class CategoryWithSubCategories(CategoryInDBBase):
    subcategories: List[SubCategoryBase]

    class Config:
        orm_mode = True


class Category(CategoryWithSubCategories):
    products: List[schemas.product.Product]


class SubCategory(SubCategoryBase):
    id: int
    categories: List[CategoryInDBBase]
