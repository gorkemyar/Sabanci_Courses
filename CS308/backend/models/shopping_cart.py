from sqlalchemy import Column, Integer, Boolean, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from db.base_class import Base


class ShoppingCart(Base):
    __tablename__ = "shoppingcart"

    id = Column(Integer, primary_key=True, index=True)

    quantity = Column(Integer)
    is_active = Column(Boolean, default=False)
    created_at = Column(DateTime)

    # relations
    user_id = Column(ForeignKey("user.id"))
    user = relationship("User", back_populates="shopping_cart_products")

    product_id = Column(ForeignKey("product.id"))
    product = relationship("Product", back_populates="shopping_cart_users")
