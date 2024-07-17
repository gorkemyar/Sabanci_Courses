from sqlalchemy.orm import Session

import crud
from schemas.category import CategoryCreate, CategoryUpdate,  SubCategoryCreate, SubCategoryUpdate
from tests.utils.utils import random_integer, random_lower_string, random_integer

def test_create_category(db: Session) -> None:
    category_name = random_lower_string()
    order_id = random_integer()
    category_in = CategoryCreate(title=category_name, order_id=order_id)
    category = crud.category.create(db=db, obj_in=category_in)
    assert category.title == category_name

def test_get_category(db: Session) -> None:
    category_name = random_lower_string()
    order_id = random_integer()
    category_in = CategoryCreate(title=category_name, order_id=order_id)
    category = crud.category.create(db=db, obj_in=category_in)
    category_2 = crud.category.get(db=db, id=category.id)
    assert category_2
    assert category_2.title == category.title


def test_update_category(db: Session) -> None:
    category_name = random_lower_string()
    order_id = random_integer()
    category_in = CategoryCreate(title=category_name, order_id=order_id)
    category = crud.category.create(db=db, obj_in=category_in)
    new_order = random_integer()
    category_in_update = CategoryUpdate(order_id=new_order)
    crud.category.update(db=db, db_obj=category, obj_in=category_in_update)
    category_2 = crud.category.get(db=db, id=category.id)
    assert category_2
    assert category.title == category_2.title
    assert new_order == category_2.order_id

def test_get_multi_category(db: Session) -> None:
    category_name = random_lower_string()
    order_id = random_integer()
    category_in = CategoryCreate(title=category_name, order_id=order_id)
    category1 = crud.category.create(db=db, obj_in=category_in)
    category_name2 = random_lower_string()
    order_id = random_integer()
    category_in = CategoryCreate(title=category_name, order_id=order_id)
    category2 = crud.category.create(db=db, obj_in=category_in)
    list_of_categories = crud.category.get_multi(db=db)
    assert len(list_of_categories)>=2
    assert list_of_categories[-1].title==category_name2

def test_create_subcategory(db: Session) -> None:
    subcategory_name = random_lower_string()
    sub_in= SubCategoryCreate(title=subcategory_name)
    sub1 = crud.subcategory.create(db=db, obj_in=sub_in)
    assert sub1.title==subcategory_name

def test_add_to_category(db:Session) -> None:
    subcategory_name = random_lower_string()
    sub_in= SubCategoryCreate(title=subcategory_name)
    sub1 = crud.subcategory.create(db=db, obj_in=sub_in)
    category_name = random_lower_string()
    order_id = random_integer()
    category_in = CategoryCreate(title=category_name, order_id=order_id)
    category1 = crud.category.create(db=db, obj_in=category_in)
    sub1meta = crud.subcategory.add_to_category(db=db, category=category1, subcategory=sub1)
    assert sub1meta.categories[0].title==category_name
    assert sub1meta.title==sub1.title

def test_update_subcategory(db:Session) -> None:
    subcategory_name = random_lower_string()
    sub_in= SubCategoryCreate(title=subcategory_name)
    sub1 = crud.subcategory.create(db=db, obj_in=sub_in)
    new_title = random_lower_string()
    subcategory_in_update = SubCategoryUpdate(title=new_title)
    sub2 = crud.subcategory.update(db=db, db_obj=sub1, obj_in=subcategory_in_update)
    
    assert sub1.title != sub2.title
    assert sub2.title == new_title
