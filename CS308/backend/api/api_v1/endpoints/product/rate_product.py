from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from sqlalchemy.orm import Session
from api import deps

import crud, models, schemas
from schemas import Response
from typing import Any

router = APIRouter()


@router.post("/{id}/rate", response_model=Response)
async def rate_product(
    *,
    id: int,
    rate: int,
    current_user: models.User = Depends(deps.get_current_user),
    db: Session = Depends(deps.get_db),
):
    """
    Rate the product by current user
    """
    product = crud.product.get(db=db, field="id", value=id)
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Product does not exists"},
        )
    if rate <= 1 or rate > 5:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Rate should be between 1 and 5"},
        )

    product_rate = crud.product.add_rate(
        db=db, user_id=current_user.id, product_id=id, rate=rate
    )
    

    return Response(data=product_rate, message="Rated successfully")
