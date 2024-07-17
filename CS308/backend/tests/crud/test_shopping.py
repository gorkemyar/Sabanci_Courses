#import models of product and shopping cart
from models import Product, ShoppingCart
from schemas.product import ProductCreate
from schemas.category import CategoryCreate, SubCategoryCreate
from schemas.user import UserCreate
from sqlalchemy.orm import Session
#import crud of product and shopping cart
import crud
from tests.utils.utils import random_integer, random_lower_string
#to test shopping cart we need products, category and subcategory for produst and 2 users with different clearance levels, mainly "PRODUCT_MANAGER" and "CUSTOMER"
#define a function to add products to a shopping cart
def add_products_to_shopping_cart(db: Session)->None:
    #crete an user capable of creating categories and subcategories
    user_create = UserCreate(
        username="test_user",
        password="test_password",
        clearance_level="PRODUCT_MANAGER",
    )
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
    #create a normal user
    user_create_customer = UserCreate(
        username="test_user_customer",
        password="test_password_customer",
        clearance_level="CUSTOMER",
    )
    #add the products to the shopping cart of the normal user
    shopping_cart_add_product = crud.shopping_cart.add_product(
        db=db, user=user_create_customer, product=shopping_cart_add_product
    )
    #see if the product was added to the shopping cart
    shopping_cart_get_products = crud.shopping_cart.get(
        db=db, user=user_create_customer
    )
    assert shopping_cart_get_products
    assert shopping_cart_get_products.products
    assert shopping_cart_get_products.products[0].name == "test_product"

#test the shopping cart remove product function
def test_shopping_cart_remove_product(db: Session)->None:
    #create an user capable of creating categories and subcategories
    user_create = UserCreate(
        username="test_user",
        password="test_password",
        clearance_level="PRODUCT_MANAGER",
    )
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
    #create a normal user
    user_create_customer = UserCreate(
        username="test_user_customer",
        password="test_password_customer",
        clearance_level="CUSTOMER",
    )
    #add the products to the shopping cart of the normal user
    shopping_cart_add_product = crud.shopping_cart.add_product(
        db=db, user=user_create_customer, product=shopping_cart_add_product
    )
    #see if the product was added to the shopping cart
    shopping_cart_get_products = crud.shopping_cart.get(
        db=db, user=user_create_customer
    )
    assert shopping_cart_get_products
    assert shopping_cart_get_products.products
    assert shopping_cart_get_products.products[0].name == "test_product"
    #remove the product from the shopping cart
    shopping_cart_remove_product = crud.shopping_cart.remove_product(
        db=db, user=user_create_customer, product=shopping_cart_add_product
    )
    #see if the product was removed from the shopping cart
    shopping_cart_get_products = crud.shopping_cart.get(
        db=db, user=user_create_customer
    )
    assert shopping_cart_get_products
    assert not shopping_cart_get_products.products

#test remove all products from shopping cart
def test_shopping_cart_remove_all_products(db: Session)->None:
    #this will test the remove_all crud function
    #create an user capable of creating categories and subcategories
    user_create = UserCreate(
        username="test_user",
        password="test_password",
        clearance_level="PRODUCT_MANAGER",
    )
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
    #create a normal user
    user_create_customer = UserCreate(
        username="test_user_customer",
        password="test_password_customer",
        clearance_level="CUSTOMER",
    )
    #add the products to the shopping cart of the normal user
    shopping_cart_add_product = crud.shopping_cart.add_product(
        db=db, user=user_create_customer, product=shopping_cart_add_product
    )
    #see if the product was added to the shopping cart
    shopping_cart_get_products = crud.shopping_cart.get(
        db=db, user=user_create_customer
    )
    assert shopping_cart_get_products
    assert shopping_cart_get_products.products
    assert shopping_cart_get_products.products[0].name == "test_product"
    #add more products, create more products
    title2= random_lower_string()
    description2= random_lower_string()
    distributor2= random_lower_string()
    stock2= random_integer()
    price2= random_integer()
    model2= random_lower_string()
    number2= random_lower_string()
    category_id2= category1.id
    subcategory_id2= sub1.id
    product_in2=ProductCreate(title=title2, description=description2, distributor=distributor2, stock=stock2,price=price2,model=model2,number=number2,category_id=category_id2,subcategory_id=subcategory_id2)
    shopping_cart_add_product2 = crud.shopping_cart.add_product(
        db=db, user=user_create_customer, product=shopping_cart_add_product2
    )
    #see if the product was added to the shopping cart
    shopping_cart_get_products = crud.shopping_cart.get(
        db=db, user=user_create_customer
    )
    assert shopping_cart_get_products
    assert shopping_cart_get_products.products
    assert shopping_cart_get_products.products[0].name == "test_product"
    assert shopping_cart_get_products.products[1].name == "test_product2"
    #remove all products from the shopping cart
    shopping_cart_remove_all_products = crud.shopping_cart.remove_all(
        db=db, user=user_create_customer
    )
    #see if the product was removed from the shopping cart
    shopping_cart_get_products = crud.shopping_cart.get(
        db=db, user=user_create_customer
    )
    assert shopping_cart_get_products
    assert not shopping_cart_get_products.products

    
