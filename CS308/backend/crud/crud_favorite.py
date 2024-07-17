from sqlalchemy.orm import Session
from typing import List
from crud.base import CRUDBase
from models.favorite import Favorite
from schemas.favorite import FavoriteCreate, FavoriteInDBBase, FavoriteUpdate

class CRUDFavorite(CRUDBase[Favorite, FavoriteCreate, FavoriteUpdate]):
    def get_multi(
        self, db: Session, *, user_id: int, skip: int = 0, limit: int = 100
    ) -> List[FavoriteInDBBase]:
        return (
            db.query(Favorite)
            .filter(Favorite.user_id == user_id)
            .offset(skip)
            .limit(limit)
            .all()
        )
    def get_multi_by_product_id(self, db: Session, *, product_id: int, skip: int = 0, limit: int = 100) -> List[FavoriteInDBBase]:
        return (
            db.query(Favorite)
            .filter(Favorite.product_id == product_id)
            .offset(skip)
            .limit(limit)
            .all()
        )

    def create_favorite(self, db: Session, *, user_id: int, favorite_details: FavoriteCreate) -> Favorite:
        favorite = Favorite(user_id=user_id, product_id=favorite_details.product_id)
        db.add(favorite)
        db.commit()
        db.refresh(favorite)
        return favorite

    def exists(self, db: Session, *, user_id: int, id: int):
        return (
            db.query(Favorite)
            .filter(Favorite.user_id == user_id, Favorite.product_id == id)
            .first()
        )
    
    #delete favorite product of user by product id
    def delete_favorite(self, db: Session, *, current_user: int, product_id: int) -> bool:
        favorite = db.query(Favorite).filter(Favorite.user_id == current_user, Favorite.product_id == product_id).first()
        if favorite:
            db.delete(favorite)
            db.commit()
            return True
        return False
    
    def delete_all_favorites(self, db: Session, *, user_id: int) -> bool:
        favorites = db.query(Favorite).filter(Favorite.user_id == user_id).all()
        if favorites:
            db.delete(favorites)
            db.commit()
            return True
        return False

    def update_favorite(self, db: Session, *, current_user: int, product_id: int, favorite_details: FavoriteUpdate) -> Favorite:
        favorite = db.query(Favorite).filter(Favorite.user_id == current_user, Favorite.product_id == product_id).first()
        if favorite:
            favorite.product_id = favorite_details.product_id
            db.commit()
            db.refresh(favorite)
            return favorite
        return None
    
    #get favorite product by user_id and product_id
    def get_with_product_and_user(self, db: Session, *, user_id: int, product_id: int) -> Favorite:
        return db.query(Favorite).filter(Favorite.user_id == user_id, Favorite.product_id == product_id).first()

favorite = CRUDFavorite(Favorite)

