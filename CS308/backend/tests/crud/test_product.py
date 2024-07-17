from sqlalchemy.orm import Session

import crud
from schemas.product import ProductCreate
from schemas.category import CategoryCreate, SubCategoryCreate
from schemas.user import UserCreate
from tests.utils.utils import random_email, random_integer, random_lower_string, random_integer

def test_product_create(db: Session)-> None:    
    subcategory_name = random_lower_string()
    sub_in= SubCategoryCreate(title=subcategory_name)
    sub1 = crud.subcategory.create(db=db, obj_in=sub_in)
    category_name = random_lower_string()
    order_id = random_integer()
    category_in = CategoryCreate(title=category_name, order_id=order_id)
    category1 = crud.category.create(db=db, obj_in=category_in)
    sub1meta = crud.subcategory.add_to_category(db=db, category=category1, subcategory=sub1)
    
    #now that the user and the category, we can create a product
    title= random_lower_string()
    description= random_lower_string()
    distributor= random_lower_string()
    stock= random_integer()
    price= random_integer()
    model= random_lower_string()
    number= random_lower_string()
    category_id= category1.id
    subcategory_id= sub1.id
    product_in=ProductCreate(title=title, description=description, distributor=distributor, stock=stock,price=price,model=model,number=number,category_id=category_id,subcategory_id=subcategory_id)
    product = crud.product.create(db=db, obj_in=product_in)
    assert product.model == model

def test_product_get(db: Session)-> None:
    subcategory_name = random_lower_string()
    sub_in= SubCategoryCreate(title=subcategory_name)
    sub1 = crud.subcategory.create(db=db, obj_in=sub_in)
    category_name = random_lower_string()
    order_id = random_integer()
    category_in = CategoryCreate(title=category_name, order_id=order_id)
    category1 = crud.category.create(db=db, obj_in=category_in)
    sub1meta = crud.subcategory.add_to_category(db=db, category=category1, subcategory=sub1)
    
    #now that the user and the category, we can create a product
    title= random_lower_string()
    description= random_lower_string()
    distributor= random_lower_string()
    stock= random_integer()
    price= random_integer()
    model= random_lower_string()
    number= random_lower_string()
    category_id= category1.id
    subcategory_id= sub1.id
    product_in=ProductCreate(title=title, description=description, distributor=distributor, stock=stock,price=price,model=model,number=number,category_id=category_id,subcategory_id=subcategory_id)
    product = crud.product.create(db=db, obj_in=product_in)
    product2 = crud.product.get(db=db, id=product.id)
    assert product2
    assert product2.title == product.title
    
def test_product_rate(db: Session)->None:    
    email = random_email()
    password = random_lower_string()
    user_in = UserCreate(email=email, password=password)
    user = crud.user.create(db, obj_in=user_in)
    authenticated_user = crud.user.authenticate(db, email=email, password=password)
    subcategory_name = random_lower_string()
    sub_in= SubCategoryCreate(title=subcategory_name)
    sub1 = crud.subcategory.create(db=db, obj_in=sub_in)
    category_name = random_lower_string()
    order_id = random_integer()
    category_in = CategoryCreate(title=category_name, order_id=order_id)
    category1 = crud.category.create(db=db, obj_in=category_in)
    sub1meta = crud.subcategory.add_to_category(db=db, category=category1, subcategory=sub1)
    
    #now that the user and the category, we can create a product
    title= random_lower_string()
    description= random_lower_string()
    distributor= random_lower_string()
    stock= random_integer()
    price= random_integer()
    model= random_lower_string()
    number= random_lower_string()
    category_id= category1.id
    subcategory_id= sub1.id
    product_in=ProductCreate(title=title, description=description, distributor=distributor, stock=stock,price=price,model=model,number=number,category_id=category_id,subcategory_id=subcategory_id)
    product = crud.product.create(db=db, obj_in=product_in)
    rate=crud.product.add_rate(db=db, user_id=authenticated_user.id, product_id=product.id, rate=1)
    assert product.rates[0]==1

def test_product_rate(db: Session)->None:    
    email = random_email()
    password = random_lower_string()
    user_in = UserCreate(email=email, password=password)
    user = crud.user.create(db, obj_in=user_in)
    authenticated_user = crud.user.authenticate(db, email=email, password=password)
    subcategory_name = random_lower_string()
    sub_in= SubCategoryCreate(title=subcategory_name)
    sub1 = crud.subcategory.create(db=db, obj_in=sub_in)
    category_name = random_lower_string()
    order_id = random_integer()
    category_in = CategoryCreate(title=category_name, order_id=order_id)
    category1 = crud.category.create(db=db, obj_in=category_in)
    sub1meta = crud.subcategory.add_to_category(db=db, category=category1, subcategory=sub1)
    
    #now that the user and the category, we can create a product
    title= random_lower_string()
    description= random_lower_string()
    distributor= random_lower_string()
    stock= random_integer()
    price= random_integer()
    model= random_lower_string()
    number= random_lower_string()
    category_id= category1.id
    subcategory_id= sub1.id
    product_in=ProductCreate(title=title, description=description, distributor=distributor, stock=stock,price=price,model=model,number=number,category_id=category_id,subcategory_id=subcategory_id)
    product = crud.product.create(db=db, obj_in=product_in)
    rate=crud.product.add_rate(db=db, user_id=authenticated_user.id, product_id=product.id, rate=5)
    rate=crud.product.add_rate(db=db, user_id=authenticated_user.id, product_id=product.id, rate=4)
    rate=crud.product.add_rate(db=db, user_id=authenticated_user.id, product_id=product.id, rate=3)
    rate=crud.product.add_rate(db=db, user_id=authenticated_user.id, product_id=product.id, rate=2)
    rate=crud.product.add_rate(db=db, user_id=authenticated_user.id, product_id=product.id, rate=1)
    assert product.rate==3