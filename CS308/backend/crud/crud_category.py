from crud.base import CRUDBase
from models.category import Category, SubCategory, CategorySubCategory
import schemas
from fastapi.encoders import jsonable_encoder
import models
from typing import Any, Optional, List
from sqlalchemy.orm import Session, joinedload
from typing import Any, Dict, Generic, List, Optional, Type, TypeVar, Union
from sqlalchemy.orm import Session
from fastapi import UploadFile
from utilities.image import ImageUtilities
from sqlalchemy import desc

class CRUDCategory(
    CRUDBase[schemas.CategoryBase, schemas.CategoryCreate, schemas.CategoryUpdate]
):
    def get(self, db: Session, field: str, value: Any) -> Optional[Category]:
        model_attribute = getattr(self.model, field)  # get attribute
        model_filter = model_attribute == value
        data = (
            db.query(Category)
            .filter(model_filter)
            .options(joinedload(models.Category.subcategories))
            .first()
        )

        if not data:
            return None
        return data

    def get_multi(
        self, db: Session, *, skip: int = 0, limit: int = 100
    ) -> List[Category]:
        return (
            db.query(models.Category)
            .options(joinedload(models.Category.subcategories))
            .order_by(desc(models.Category.order_id)) #I do wonder what will happen to the already defined categories. Will they have null orders, but the order column is nullable=False, so will I get an error, 
            .offset(skip)
            .limit(limit)
            .all()
        )

    def create(
        self, db: Session, *, obj_in: schemas.CategoryCreate, image: UploadFile = None
    ) -> Category:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = self.model(**obj_in_data)  # type: ignore
        if self.get(db=db, field="title", value=obj_in.title):
            return None
        if image:
            db_obj.image_url = ImageUtilities.save_image(image, "categories")
        db.commit()
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    def update(
        self,
        db: Session,
        *,
        db_obj: Category,
        image: UploadFile,
        obj_in: Union[schemas.CategoryUpdate, Dict[str, Any]]
    ) -> Category:
        if isinstance(obj_in, dict):
            update_data = obj_in
        else:
            update_data = obj_in.dict(exclude_unset=True)
        if image:
            ImageUtilities.remove_image(path=db_obj.image_url)
            update_data["image_url"] = ImageUtilities.save_image(image, "categories")
        return super().update(db, db_obj=db_obj, obj_in=update_data)


category = CRUDCategory(Category)


class CRUDSubCategory(
    CRUDBase[
        schemas.SubCategoryBase, schemas.SubCategoryCreate, schemas.SubCategoryUpdate
    ]
):
    def get(self, db: Session, field: str, value: Any) -> Optional[SubCategory]:
        model_attribute = getattr(self.model, field)  # get attribute
        model_filter = model_attribute == value
        data = (
            db.query(SubCategory)
            .filter(model_filter)
            .options(joinedload(models.SubCategory.categories))
            .first()
        )

        if not data:
            return None
        return data

    def create(self, db: Session, *, obj_in: schemas.SubCategoryCreate) -> SubCategory:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = self.model(**obj_in_data)  # type: ignore
        if self.get(db=db, field="title", value=obj_in.title):
            return None
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    def add_to_category(
        self, db: Session, *, category: Category, subcategory: SubCategory
    ) -> SubCategory:
        category_subcategory = CategorySubCategory(
            category_id=category.id, subcategory_id=subcategory.id
        )

        db.add(category_subcategory)
        db.commit()
        db.refresh(category_subcategory)
        return subcategory

    def update(
        self,
        db: Session,
        *,
        db_obj: SubCategory,
        category: Category,
        obj_in: Union[schemas.SubCategoryUpdate, Dict[str, Any]]
    ) -> schemas.SubCategoryUpdate:
        obj_data = jsonable_encoder(db_obj)
        if isinstance(obj_in, dict):
            update_data = obj_in
        else:
            update_data = obj_in.dict(exclude_unset=True)
        for field in obj_data:
            if field in update_data:
                setattr(db_obj, field, update_data[field])

        ## TODO: This way not useful! Find another way for fixing it!
        if obj_in.category_id:
            m2m_relation = (
                db.query(CategorySubCategory)
                .filter(CategorySubCategory.subcategory_id == db_obj.id)
                .first()
            )
            m2m_relation.category_id = obj_in.category_id
            db.add(m2m_relation)
        ## ---------------
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj


subcategory = CRUDSubCategory(SubCategory)
