from operator import add
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from api import deps

import crud, models, schemas
from schemas import Response
from typing import Any, List

router = APIRouter()


@router.get("/credit", response_model=Response[List[schemas.CreditInDBBase]])
def get_credit_of_user(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Retrieve credit cards of current user.
    """
    credit = crud.credit.get_multi(
        db=db, user_id=current_user.id, skip=skip, limit=limit
    )
    return Response(data=credit)


@router.post("/credit", response_model=Response[schemas.CreditInDBBase])
def create_credit(
    *,
    credit_in: schemas.CreditCreate,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Create new credit.
    """
    credit_in.user_id = current_user.id
    credit = crud.credit.create(db=db, obj_in=credit_in)
    return Response(data=credit)


@router.delete("/credit/{credit_id}", response_model=Response[schemas.CreditBase])
def delete_credit(
    *,
    credit_id: int,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Delete a credit.
    """
    credit = crud.credit.exists(db=db, user_id=current_user.id, id=credit_id)
    if not credit:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Credit does not exist"},
        )

    credit = crud.credit.remove(db=db, id=credit_id)
    return Response(data=credit, isSuccess=True)