from operator import add
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from api import deps

import crud, models, schemas
from schemas import Response
from typing import Any, List

router = APIRouter()


@router.get("/addresses", response_model=Response[List[schemas.AddressInDBBase]])
def get_addresses_of_user(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Retrieve address of current user.
    """
    addresses = crud.address.get_multi(
        db=db, user_id=current_user.id, skip=skip, limit=limit
    )
    return Response(data=addresses)


@router.post("/addresses", response_model=Response[schemas.AddressInDBBase])
def create_address(
    *,
    address_in: schemas.AddressCreate,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Create new address.
    """
    address_in.user_id = current_user.id
    address = crud.address.create(db=db, obj_in=address_in)
    return Response(data=address)


@router.delete("/addresses/{address_id}", response_model=Response[schemas.AddressBase])
def delete_address(
    *,
    address_id: int,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Delete a address.
    """
    address = crud.address.exists(db=db, user_id=current_user.id, id=address_id)
    if not address:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Address does not exist"},
        )
    #address will never be erased, why? because when an address is erased previously done orders are dependet on these addresses and when they are erased the orders get broken 
    #so whenever an address is erased, in reality it sis just assigned to a anothoer account with the id 13
    address.user_id=13
    db.add(address)
    db.commit()
    #address = crud.address.remove(db=db, id=address_id)
    return Response(data=address, isSuccess=True)

@router.patch("/addresses/{address_id}", response_model=Response[schemas.AddressBase])
async def update_address(
    *,
    address_id: int,
    address_in: schemas.AddressUpdate,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
):
    """
    Updates address with id
    """
    address = crud.address.exists(db=db, user_id=current_user.id, id=address_id)
    if not address:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Address does not exist"},
        )
    address = crud.address.update(
        db, db_obj=address, obj_in=address_in
    )

    return Response(data=address, message="Updated successfully")
