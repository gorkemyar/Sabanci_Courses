from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from db.base_class import Base
from sqlalchemy.ext.associationproxy import association_proxy
from itertools import chain


class CategorySubCategory(Base):
    __tablename__ = "category_subcategory"

    id = Column(Integer, primary_key=True, index=True)

    category_id = Column(ForeignKey("category.id"))
    subcategory_id = Column(ForeignKey("subcategory.id"))

    category = relationship("Category", back_populates="subcategories")
    subcategory = relationship("SubCategory", cascade="all,delete", back_populates="categories")

    # proxies
    category_title = association_proxy(target_collection="category", attr="title")
    subcategory_title = association_proxy(target_collection="subcategory", attr="title")

    products = relationship("Product")


class Category(Base):
    __tablename__ = "category"

    id = Column(Integer, primary_key=True)
    title = Column(String, nullable=False)
    order_id = Column(Integer, nullable=True)
    image_url = Column(String, nullable=True)
    subcategories = relationship(
        "CategorySubCategory", cascade="all,delete", back_populates="category"
    )

    @property
    def products(self):
        return list(chain(*[s.products for s in self.subcategories]))


    def __init__(self, title, order_id):
        self.title = title
        self.order_id = order_id


class SubCategory(Base):
    __tablename__ = "subcategory"

    id = Column(Integer, primary_key=True)
    title = Column(String, nullable=False)
    order_id = Column(Integer, nullable=True)
    categories = relationship(
        "CategorySubCategory", cascade="all,delete", back_populates="subcategory"
    )
    
    def __init__(self, title, order_id):
        self.title = title
        self.order_id = order_id
