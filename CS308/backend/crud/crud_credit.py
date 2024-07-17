from sqlalchemy.orm import Session
from typing import List
from crud.base import CRUDBase
from models.credit import Credit
from schemas.credit import CreditCreate, CreditInDBBase, CreditUpdate, CreditPrivate
from fastapi.encoders import jsonable_encoder


class CRUDCredit(CRUDBase[Credit, CreditCreate, CreditUpdate]):
    def create(self, db: Session, *, obj_in: CreditCreate) -> CreditPrivate:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = self.model(**obj_in_data)  # type: ignore
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj

    def get_multi(
        self, db: Session, *, user_id: int, skip: int = 0, limit: int = 100
    ) -> List[CreditInDBBase]:
        return (
            db.query(Credit)
            .filter(Credit.user_id == user_id)
            .offset(skip)
            .limit(limit)
            .all()
        )

    def exists(self, db: Session, *, user_id: int, id: int):
        return (
            db.query(Credit).filter(Credit.user_id == user_id, Credit.id == id).first()
        )


credit = CRUDCredit(Credit)
