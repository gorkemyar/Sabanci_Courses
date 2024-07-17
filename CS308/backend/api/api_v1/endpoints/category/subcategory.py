from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
import crud, schemas, models
from typing import List
from api import deps
from schemas.response import Response

router = APIRouter()


@router.post(
    "/{id}/subcategory",
    response_model=Response[schemas.SubCategoryBase],
    response_model_by_alias=False,
)
async def create_subcategory(
    *,
    id: int,
    subcategory_in: schemas.SubCategoryCreate,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
):
    """
    Creates subcategory and adds to the specified category.
    """
    if current_user.user_type != models.user.UserType.PRODUCT_MANAGER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"message": "Only product managers can create subcategories."},
        )
    category = crud.category.get(db=db, field="id", value=id)
    if not category:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Category does not exist"},
        )

    subcategory = crud.subcategory.create(db=db, obj_in=subcategory_in)
    if not subcategory:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"SubCategory exists"},
        )

    category_subcategory = crud.subcategory.add_to_category(
        db=db, category=category, subcategory=subcategory
    )
    return Response(data=subcategory)


@router.delete(
    "/{id}/subcategory/{sub_id}",
    response_model=Response,
    response_model_by_alias=False,
)
async def remove_subcategory(
    *,
    id: int,
    sub_id: int,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user), 
):
    """
    Removes subcategory
    """
    if current_user.user_type != models.user.UserType.PRODUCT_MANAGER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"message": "Only product managers can delete subcategories."},
        )
    category = crud.category.get(db=db, field="id", value=id)
    if not category:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Category does not exist"},
        )

    subcategory = crud.subcategory.get(db=db, field="id", value=sub_id)
    if not subcategory:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"SubCategory does not exist"},
        )

    subcategory = crud.subcategory.remove(db=db, id=subcategory.id)
    return Response(message="Removed successfully")


@router.patch(
    "/{id}/subcategory/{sub_id}",
    response_model=Response,
    response_model_by_alias=False,
)
async def update_subcategory(
    *,
    id: int,
    sub_id: int,
    subcategory_in: schemas.SubCategoryUpdate,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
):
    """
    Updates subcategory
    """
    if current_user.user_type != models.user.UserType.PRODUCT_MANAGER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"message": "Only product managers can update subcategories."},
        )
    category = crud.category.get(db=db, field="id", value=id)
    if not category:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Category does not exist"},
        )

    subcategory = crud.subcategory.get(db=db, field="id", value=sub_id)
    if not subcategory:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"SubCategory does not exist"},
        )

    subcategory = crud.subcategory.update(
        db=db, db_obj=subcategory, obj_in=subcategory_in, category=category
    )
    return Response(message="Updated successfully")
