from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from api import deps

import crud, models, schemas
from schemas import Response
from typing import Any, List

router = APIRouter()


@router.post("/", response_model=Response[schemas.Product])
async def create_product(
    product_in: schemas.ProductCreate,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Create product
    """
    product = crud.product.create(db=db, obj_in=product_in)
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Category and subcategory not found"},
        )
    return Response(data=product)


@router.get("/", response_model=Response[List[schemas.Product]])
async def search_products(
    query: str,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(deps.get_db),
) -> Any:
    """
    Search products from their titles and description
    """
    products = crud.product.search_title_description(
        db=db, query=query, skip=skip, limit=limit
    )
    return Response(data=products)
