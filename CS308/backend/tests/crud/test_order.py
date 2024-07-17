#import user, product, categry, shoppingcart schemas
from schemas.refund import RefundCreate, RefundUpdate
from schemas.user import UserCreate, UserInDBBase, UserUpdate
from schemas.product import ProductCreate, ProductInDBBase, ProductUpdate
from schemas.category import CategoryCreate, CategoryInDBBase, CategoryUpdate, SubCategoryCreate, SubCategoryInDBBase, SubCategoryUpdate
from schemas.shopping_cart import ShoppingCartCreate, ShoppingCartInDBBase, ShoppingCartUpdate
from schemas.order import OrderCreate, OrderInDBBase, OrderUpdate
import crud
from tests.utils.utils import random_integer, random_lower_string, random_integer
from sqlalchemy.orm import Session
#import jsonencoder
from fastapi.encoders import jsonable_encoder
#standart product creation, user->category->subcategory->product, new_user->shopping_cart->product, then order
def test_create_order(db: Session) -> None:
    user_name = random_lower_string()
    user_in = UserCreate(
        username=user_name,
        email=user_name + "@example.com",
        password="example_password",
        user_type="CUSTOMER"
    )
    user = crud.user.create(db=db, obj_in=user_in)
    #create a new user with user_type=PRODUCT_MANAGER
    user_name_manager = random_lower_string()
    user_in_manager = UserCreate(
        username=user_name_manager,
        email=user_name_manager + "@example.com",
        password="example_password",
        user_type="PRODUCT_MANAGER"
    )
    user_manager = crud.user.create(db=db, obj_in=user_in_manager)
    #create a category
    category_name = random_lower_string()
    category_in = CategoryCreate(title=category_name)
    category = crud.category.create(db=db, obj_in=category_in)
    #create a subcategory
    subcategory_name = random_lower_string()
    subcategory_in = SubCategoryCreate(title=subcategory_name)
    subcategory = crud.subcategory.create(db=db, obj_in=subcategory_in)
    #create a product
    title= random_lower_string()
    description= random_lower_string()
    distributor= random_lower_string()
    stock= random_integer()
    price= random_integer()
    model= random_lower_string()
    number= random_lower_string()
    category_id= category.id
    subcategory_id= subcategory.id
    product_in=ProductCreate(title=title, description=description, distributor=distributor, stock=stock,price=price,model=model,number=number,category_id=category_id,subcategory_id=subcategory_id)
    product = crud.product.create(db=db, obj_in=product_in)
    #create a shopping cart
    shopping_cart_in=ShoppingCartCreate(user_id=user.id)
    shopping_cart = crud.shopping_cart.create(db=db, obj_in=shopping_cart_in)
    #create an order
    order_in=OrderCreate(user_id=user.id, shopping_cart_id=shopping_cart.id)
    order = crud.order.create(db=db, obj_in=order_in)
    assert order.id == 1
    assert order.user_id == 1
    assert order.shopping_cart_id == 1
    assert order.status == "PENDING"
    assert order.created_at is not None
    assert order.updated_at is not None

#test get multiple orders
def test_get_orders(db: Session) -> None:
    user_name = random_lower_string()
    user_in = UserCreate(
        username=user_name,
        email=user_name + "@example.com",
        password="example_password",
        user_type="CUSTOMER"
    )
    user = crud.user.create(db=db, obj_in=user_in)
    #create a new user with user_type=PRODUCT_MANAGER
    user_name_manager = random_lower_string()
    user_in_manager = UserCreate(
        username=user_name_manager,
        email=user_name_manager + "@example.com",
        password="example_password",
        user_type="PRODUCT_MANAGER"
    )
    user_manager = crud.user.create(db=db, obj_in=user_in_manager)
    #create a category
    category_name = random_lower_string()
    category_in = CategoryCreate(title=category_name)
    category = crud.category.create(db=db, obj_in=category_in)
    #create a subcategory
    subcategory_name = random_lower_string()
    subcategory_in = SubCategoryCreate(title=subcategory_name)
    subcategory = crud.subcategory.create(db=db, obj_in=subcategory_in)
    #create a product
    title= random_lower_string()
    description= random_lower_string()
    distributor= random_lower_string()
    stock= random_integer()
    price= random_integer()
    model= random_lower_string()
    number= random_lower_string()
    category_id= category.id
    subcategory_id= subcategory.id
    product_in=ProductCreate(title=title, description=description, distributor=distributor, stock=stock,price=price,model=model,number=number,category_id=category_id,subcategory_id=subcategory_id)
    product = crud.product.create(db=db, obj_in=product_in)
    #create a shopping cart
    shopping_cart_in=ShoppingCartCreate(user_id=user.id)
    shopping_cart = crud.shopping_cart.create(db=db, obj_in=shopping_cart_in)
    #create an order
    order_in=OrderCreate(user_id=user.id, shopping_cart_id=shopping_cart.id)
    order = crud.order.create(db=db, obj_in=order_in)
    #create 2 more orders
    order_in=OrderCreate(user_id=user.id, shopping_cart_id=shopping_cart.id)
    order = crud.order.create(db=db, obj_in=order_in)
    order_in=OrderCreate(user_id=user.id, shopping_cart_id=shopping_cart.id)
    order = crud.order.create(db=db, obj_in=order_in)
    #get all orders
    orders = crud.order.get_multi(db=db, user_id=user.id)
    assert len(orders) == 3
    assert orders[0].id == 1
    assert orders[0].user_id == 1
    assert orders[0].shopping_cart_id == 1
    assert orders[0].status == "PENDING"
    assert orders[0].created_at is not None
    assert orders[0].updated_at is not None

#test create_refund_request
def test_create_refund_request(db: Session) -> None:
    user_name = random_lower_string()
    user_in = UserCreate(
        username=user_name,
        email=user_name + "@example.com",
        password="example_password",
        user_type="CUSTOMER"
    )
    user = crud.user.create(db=db, obj_in=user_in)
    #create a new user with user_type=PRODUCT_MANAGER
    user_name_manager = random_lower_string()
    user_in_manager = UserCreate(
        username=user_name_manager,
        email=user_name_manager + "@example.com",
        password="example_password",
        user_type="PRODUCT_MANAGER"
    )
    user_manager = crud.user.create(db=db, obj_in=user_in_manager)
    #create a category
    category_name = random_lower_string()
    category_in = CategoryCreate(title=category_name)
    category = crud.category.create(db=db, obj_in=category_in)
    #create a subcategory
    subcategory_name = random_lower_string()
    subcategory_in = SubCategoryCreate(title=subcategory_name)
    subcategory = crud.subcategory.create(db=db, obj_in=subcategory_in)
    #create a product
    title= random_lower_string()
    description= random_lower_string()
    distributor= random_lower_string()
    stock= random_integer()
    price= random_integer()
    model= random_lower_string()
    number= random_lower_string()
    category_id= category.id
    subcategory_id= subcategory.id
    product_in=ProductCreate(title=title, description=description, distributor=distributor, stock=stock,price=price,model=model,number=number,category_id=category_id,subcategory_id=subcategory_id)
    product = crud.product.create(db=db, obj_in=product_in)
    #create a shopping cart
    shopping_cart_in=ShoppingCartCreate(user_id=user.id)
    shopping_cart = crud.shopping_cart.create(db=db, obj_in=shopping_cart_in)
    #create an order
    order_in=OrderCreate(user_id=user.id, shopping_cart_id=shopping_cart.id)
    order = crud.order.create(db=db, obj_in=order_in)
    RefundCreate(order_id=order.id, user_id=user.id, reason="reason")
    refund = crud.refund.create(db=db, obj_in=RefundCreate(order_id=order.id, user_id=user.id, reason="reason"))
    assert refund.id == 1
    assert refund.order_id == 1
    assert refund.user_id == 1
    assert refund.reason == "reason"
    assert refund.status == "PENDING"
    assert refund.created_at is not None
    assert refund.updated_at is not None

#test but now the order is older than 30 days
def test_create_refund_request_older_than_30_days(db: Session) -> None:
    user_name = random_lower_string()
    user_in = UserCreate(
        username=user_name,
        email=user_name + "@example.com",
        password="example_password",
        user_type="CUSTOMER"
    )
    user = crud.user.create(db=db, obj_in=user_in)
    #create a new user with user_type=PRODUCT_MANAGER
    user_name_manager = random_lower_string()
    user_in_manager = UserCreate(
        username=user_name_manager,
        email=user_name_manager + "@example.com",
        password="example_password",
        user_type="PRODUCT_MANAGER"
    )
    user_manager = crud.user.create(db=db, obj_in=user_in_manager)
    #create a category
    category_name = random_lower_string()
    category_in = CategoryCreate(title=category_name)
    category = crud.category.create(db=db, obj_in=category_in)
    #create a subcategory
    subcategory_name = random_lower_string()
    subcategory_in = SubCategoryCreate(title=subcategory_name)
    subcategory = crud.subcategory.create(db=db, obj_in=subcategory_in)
    #create a product
    title= random_lower_string()
    description= random_lower_string()
    distributor= random_lower_string()
    stock= random_integer()
    price= random_integer()
    model= random_lower_string()
    number= random_lower_string()
    category_id= category.id
    subcategory_id= subcategory.id
    product_in=ProductCreate(title=title, description=description, distributor=distributor, stock=stock,price=price,model=model,number=number,category_id=category_id,subcategory_id=subcategory_id)
    product = crud.product.create(db=db, obj_in=product_in)
    #create a shopping cart
    shopping_cart_in=ShoppingCartCreate(user_id=user.id)
    shopping_cart = crud.shopping_cart.create(db=db, obj_in=shopping_cart_in)
    #create an order
    order_in=OrderCreate(user_id=user.id, shopping_cart_id=shopping_cart.id)
    order = crud.order.create(db=db, obj_in=order_in)
    #create a refund
    RefundCreate(order_id=order.id, user_id=user.id, reason="reason")
    refund = crud.refund.create(db=db, obj_in=RefundCreate(order_id=order.id, user_id=user.id, reason="reason"))
    assert refund.id == 1
    assert refund.order_id == 1
    assert refund.user_id == 1
    assert refund.reason == "reason"
    assert refund.status == "PENDING"
    assert refund.created_at is not None
    assert refund.updated_at is not None

#test change refund status to REJECTED and check if the status is changed
def test_change_refund_status_to_rejected(db: Session) -> None:
    user_name = random_lower_string()
    user_in = UserCreate(
        username=user_name,
        email=user_name + "@example.com",
        password="example_password",
        user_type="CUSTOMER"
    )
    user = crud.user.create(db=db, obj_in=user_in)
    #create a new user with user_type=PRODUCT_MANAGER
    user_name_manager = random_lower_string()
    user_in_manager = UserCreate(
        username=user_name_manager,
        email=user_name_manager + "@example.com",
        password="example_password",
        user_type="PRODUCT_MANAGER"
    )
    user_manager = crud.user.create(db=db, obj_in=user_in_manager)
    #create a category
    category_name = random_lower_string()
    category_in = CategoryCreate(title=category_name)
    category = crud.category.create(db=db, obj_in=category_in)
    #create a subcategory
    subcategory_name = random_lower_string()
    subcategory_in = SubCategoryCreate(title=subcategory_name)
    subcategory = crud.subcategory.create(db=db, obj_in=subcategory_in)
    #create a product
    title= random_lower_string()
    description= random_lower_string()
    distributor= random_lower_string()
    stock= random_integer()
    price= random_integer()
    model= random_lower_string()
    number= random_lower_string()
    category_id= category.id
    subcategory_id= subcategory.id
    product_in=ProductCreate(title=title, description=description, distributor=distributor, stock=stock,price=price,model=model,number=number,category_id=category_id,subcategory_id=subcategory_id)
    product = crud.product.create(db=db, obj_in=product_in)
    #create a shopping cart
    shopping_cart_in=ShoppingCartCreate(user_id=user.id)
    shopping_cart = crud.shopping_cart.create(db=db, obj_in=shopping_cart_in)
    #create an order
    order_in=OrderCreate(user_id=user.id, shopping_cart_id=shopping_cart.id)
    order = crud.order.create(db=db, obj_in=order_in)
    #create a refund
    RefundCreate(order_id=order.id, user_id=user.id, reason="reason")
    refund = crud.refund.create(db=db, obj_in=RefundCreate(order_id=order.id, user_id=user.id, reason="reason"))
    #change the status to REJECTED using the change_refund_status function
    crud.refund.change_refund_status(db=db, obj_in=RefundUpdate(id=refund.id, status="REJECTED"))
    #check if the status is changed
    refund = crud.refund.get_by_id(db=db, id=refund.id)
    assert refund.status == "REJECTED"

#test get_refund_requests function and check if the returned list is not empty
def test_get_refund_requests(db: Session) -> None:
    user_name = random_lower_string()
    user_in = UserCreate(
        username=user_name,
        email=user_name + "@example.com",
        password="example_password",
        user_type="CUSTOMER"
    )
    user = crud.user.create(db=db, obj_in=user_in)
    #create a new user with user_type=PRODUCT_MANAGER
    user_name_manager = random_lower_string()
    user_in_manager = UserCreate(
        username=user_name_manager,
        email=user_name_manager + "@example.com",
        password="example_password",
        user_type="PRODUCT_MANAGER"
    )
    user_manager = crud.user.create(db=db, obj_in=user_in_manager)
    #create a category
    category_name = random_lower_string()
    category_in = CategoryCreate(title=category_name)
    category = crud.category.create(db=db, obj_in=category_in)
    #create a subcategory
    subcategory_name = random_lower_string()
    subcategory_in = SubCategoryCreate(title=subcategory_name)
    subcategory = crud.subcategory.create(db=db, obj_in=subcategory_in)
    #create a product
    title= random_lower_string()
    description= random_lower_string()
    distributor= random_lower_string()
    stock= random_integer()
    price= random_integer()
    model= random_lower_string()
    number= random_lower_string()
    category_id= category.id
    subcategory_id= subcategory.id
    product_in=ProductCreate(title=title, description=description, distributor=distributor, stock=stock,price=price,model=model,number=number,category_id=category_id,subcategory_id=subcategory_id)
    product = crud.product.create(db=db, obj_in=product_in)
    #create a shopping cart
    shopping_cart_in=ShoppingCartCreate(user_id=user.id)
    shopping_cart = crud.shopping_cart.create(db=db, obj_in=shopping_cart_in)
    #create an order
    order_in=OrderCreate(user_id=user.id, shopping_cart_id=shopping_cart.id)
    order = crud.order.create(db=db, obj_in=order_in)
    #create a refund
    RefundCreate(order_id=order.id, user_id=user.id, reason="reason")
    refund = crud.refund.create(db=db, obj_in=RefundCreate(order_id=order.id, user_id=user.id, reason="reason"))
    assert refund.id == 1
    assert refund.order_id == 1
    assert refund.user_id == 1
    assert refund.reason == "reason"
    assert refund.status == "PENDING"
    assert refund.created_at is not None
    assert refund.updated_at is not None

#test change refund status to REJECTED and check if the status is changed
def test_change_refund_status_to_rejected(db: Session) -> None:
    user_name = random_lower_string()
    user_in = UserCreate(
        username=user_name,
        email=user_name + "@example.com",
        password="example_password",
        user_type="CUSTOMER"
    )
    user = crud.user.create(db=db, obj_in=user_in)
    #create a new user with user_type=PRODUCT_MANAGER
    user_name_manager = random_lower_string()
    user_in_manager = UserCreate(
        username=user_name_manager,
        email=user_name_manager + "@example.com",
        password="example_password",
        user_type="PRODUCT_MANAGER"
    )
    user_manager = crud.user.create(db=db, obj_in=user_in_manager)
    #create a category
    category_name = random_lower_string()
    category_in = CategoryCreate(title=category_name)
    category = crud.category.create(db=db, obj_in=category_in)
    #create a subcategory
    subcategory_name = random_lower_string()
    subcategory_in = SubCategoryCreate(title=subcategory_name)
    subcategory = crud.subcategory.create(db=db, obj_in=subcategory_in)
    #create a product
    title= random_lower_string()
    description= random_lower_string()
    distributor= random_lower_string()
    stock= random_integer()
    price= random_integer()
    model= random_lower_string()
    number= random_lower_string()
    category_id= category.id
    subcategory_id= subcategory.id
    product_in=ProductCreate(title=title, description=description, distributor=distributor, stock=stock,price=price,model=model,number=number,category_id=category_id,subcategory_id=subcategory_id)
    product = crud.product.create(db=db, obj_in=product_in)
    #create a shopping cart
    shopping_cart_in=ShoppingCartCreate(user_id=user.id)
    shopping_cart = crud.shopping_cart.create(db=db, obj_in=shopping_cart_in)
    #create an order
    order_in=OrderCreate(user_id=user.id, shopping_cart_id=shopping_cart.id)
    order = crud.order.create(db=db, obj_in=order_in)
    #create a refund
    RefundCreate(order_id=order.id, user_id=user.id, reason="reason")
    refund = crud.refund.create(db=db, obj_in=RefundCreate(order_id=order.id, user_id=user.id, reason="reason"))
    #get_refund_requests function and check if the returned list is not empty
    lister = crud.refund.get_refund_requests(db=db, user_id=user.id)
    assert len(lister) > 0
    





