from sqlalchemy.orm import Session
from typing import List
from crud.base import CRUDBase
from models.address import Address
from schemas.address import AddressCreate, AddressInDBBase, AddressUpdate


class CRUDAddress(CRUDBase[Address, AddressCreate, AddressUpdate]):
    def get_multi(
        self, db: Session, *, user_id: int, skip: int = 0, limit: int = 100
    ) -> List[AddressInDBBase]:
        return (
            db.query(Address)
            .filter(Address.user_id == user_id)
            .offset(skip)
            .limit(limit)
            .all()
        )

    def exists(self, db: Session, *, user_id: int, id: int):
        return (
            db.query(Address)
            .filter(Address.user_id == user_id, Address.id == id)
            .first()
        )


address = CRUDAddress(Address)
