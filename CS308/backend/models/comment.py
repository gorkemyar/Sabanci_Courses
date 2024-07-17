from sqlalchemy import Column, Integer, String, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from db.base_class import Base

class Comment(Base):
    __tablename__ = 'comment'
    
    id = Column(Integer, primary_key=True)
    content = Column(String(1000), nullable=False)
    rate = Column(Integer)
    is_active = Column(Boolean, default=False)

    user_id = Column(Integer, ForeignKey('user.id'))
    user = relationship("User", back_populates="comments", cascade="all,delete")

    product_id = Column(Integer, ForeignKey('product.id'))
    product = relationship("Product", back_populates="comments", cascade="all,delete")