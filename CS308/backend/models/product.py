from sqlalchemy import Column, Integer, ForeignKey, Boolean, String, Float
from sqlalchemy.orm import relationship
from db.base_class import Base
from sqlalchemy.ext.associationproxy import association_proxy
from sqlalchemy.orm import column_property
from sqlalchemy.sql import select
from sqlalchemy import func
from models import Comment


class ProductRate(Base):
    __tablename__ = "productrate"

    id = Column(Integer, primary_key=True)

    rate = Column(Integer)

    user_id = Column(Integer, ForeignKey("user.id"))
    user = relationship("User")

    product_id = Column(Integer, ForeignKey("product.id"))
    product = relationship("Product", back_populates="rates")


class Product(Base):
    __tablename__ = "product"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(125), nullable=False)
    description = Column(String, nullable=False)
    stock = Column(Integer)
    price = Column(Float)
    model = Column(String)
    number = Column(String)
    discount = Column(Integer, nullable=True)
    distributor = Column(String)

    category_subcategory_id = Column(Integer, ForeignKey("category_subcategory.id"))
    category_subcategory = relationship(
        "CategorySubCategory", back_populates="products"
    )

    # proxies
    category_title = association_proxy(
        target_collection="category_subcategory", attr="category_title"
    )
    subcategory_title = association_proxy(
        target_collection="category_subcategory", attr="subcategory_title"
    )

    comments = relationship("Comment", back_populates="product", lazy="dynamic")
    photos = relationship("ProductPhoto", back_populates="product")
    rates = relationship("ProductRate", back_populates="product")
    favorites= relationship("Favorite", back_populates="product")
    
    shopping_cart_users = relationship("ShoppingCart", cascade="all,delete")
    ordered_products = relationship("OrderItem", cascade="all,delete")

    rate_count = column_property(
        select([func.count(ProductRate.rate)])
        .filter(ProductRate.product_id == id)
        .scalar_subquery()
    )

    rate = column_property(
        select([func.avg(ProductRate.rate)])
        .filter(ProductRate.product_id == id)
        .scalar_subquery()
    )

    comment_count = column_property(
        select([func.count(Comment.id)])
        .filter(Comment.product_id == id)
        .scalar_subquery()
    )


class ProductPhoto(Base):
    __tablename__ = "productphoto"

    id = Column(Integer, primary_key=True)

    is_active = Column(Boolean, default=True)
    photo_url = Column(String, nullable=False)

    product_id = Column(Integer, ForeignKey("product.id"))
    product = relationship("Product", back_populates="photos")
