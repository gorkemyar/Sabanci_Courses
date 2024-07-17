from tkinter import Image
from fastapi import APIRouter, Depends, UploadFile, File, HTTPException, status
from sqlalchemy.orm import Session
import crud, schemas, models
from typing import List
from api import deps
from schemas.response import Response
from fastapi.responses import FileResponse
from utilities.image import ImageUtilities

router = APIRouter()


@router.get(
    "/",
    response_model=Response[List[schemas.CategoryWithSubCategories]],
    response_model_by_alias=False,
)
async def get_categories(
    skip: int = 0, limit: int = 100, db: Session = Depends(deps.get_db)
):
    """
    Returns all categories.
    """
    data = crud.category.get_multi(db=db, skip=skip, limit=limit)
    return Response(data=data)


@router.get(
    "/{id}",
    response_model=Response[schemas.Category],
    response_model_by_alias=False,
)
async def get_category_by_id(id: int, db: Session = Depends(deps.get_db)):
    """
    Returns the category (with subcategories) by id.
    """
    category = crud.category.get(db=db, field="id", value=id)
    if not category:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Category does not exists."},
        )
    return Response(data=category)


@router.get("/{id}/image", response_class=FileResponse)
async def get_category_image(id: int, db: Session = Depends(deps.get_db)):
    """
    Returns the category image
    """
    category = crud.category.get(db=db, field="id", value=id)
    if not category:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Category does not exists."},
        )
    return FileResponse(ImageUtilities.get_image_dir(category.image_url))


@router.post("/")
async def create_category(
    *,
    category_in: schemas.CategoryCreate = Depends(),
    image: UploadFile = File(...),
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
):
    """
    Creates category from title and image.
    """
    if current_user.user_type != models.user.UserType.PRODUCT_MANAGER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"message": "Only product managers can create categories."},
        )

    category = crud.category.create(db, obj_in=category_in, image=image)
    if not category:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Exists"},
        )
    return category


@router.patch(
    "/{id}",
    response_model=Response,
)
async def update_category(
    *,
    id: int,
    category_in: schemas.CategoryUpdate = Depends(),
    image: UploadFile = File(None),
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
):
    """
    Updates category title with id
    """
    if current_user.user_type != models.user.UserType.PRODUCT_MANAGER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"message": "Only product managers can update categories."},
        )

    current_category = crud.category.get(db=db, field="id", value=id)
    if not current_category:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Category does not exists."},
        )
    category = crud.category.update(
        db, db_obj=current_category, image=image, obj_in=category_in
    )
    return Response(message="Updated successfully")


@router.delete(
    "/{id}",
    response_model=Response,
)
async def remove_category(
    *,
    id: int,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
):
    """
    Deletes category title with id
    """
    
    if current_user.user_type != models.user.UserType.PRODUCT_MANAGER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"message": "Only product managers can delete categories."},
        )

    current_category = crud.category.get(db=db, field="id", value=id)
    if not current_category:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Category does not exists."},
        )
    category = crud.category.remove(db=db, id=id)
    # TODO: Do it in celery
    ImageUtilities.remove_image(path=category.image_url)
    return Response(message="Deleted successfully")
