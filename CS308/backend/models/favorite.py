#an sqlalchemy table for the favorite table, this table is a many to many relationship between users and products
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from db.base_class import Base

class Favorite(Base):
    __tablename__ = "favorite"

    id = Column(Integer, primary_key=True, index=True)

    product_id = Column(Integer, ForeignKey("product.id"))
    product = relationship("Product", back_populates="favorites")

    user_id = Column(Integer, ForeignKey("user.id"))
    user = relationship("User", back_populates="favorites")
