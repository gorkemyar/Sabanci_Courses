from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from sqlalchemy.orm import Session
from api import deps

import crud, models, schemas
from models.user import UserType
from schemas import Response
from typing import Any, List
from utilities.image import ImageUtilities

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
    if current_user.user_type != UserType.PRODUCT_MANAGER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"message":"Only product managers can create products"},
        )

    product = crud.product.create(db=db, obj_in=product_in)
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Category and subcategory not found"},
        )
    return Response(data=product)


@router.get("/{id}", response_model=Response[schemas.Product])
async def get_product(
    id: int,
    db: Session = Depends(deps.get_db),
) -> Any:
    """
    Retrieve product from id
    """
    product = crud.product.get(db=db, field="id", value=id)
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Product does not exists"},
        )

    return Response(data=product)


@router.delete("/{product_id}", response_model=Response)
def delete_product(
    *,
    product_id: int,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Delete a product by id.
    """
    if current_user.user_type != UserType.PRODUCT_MANAGER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"message": "Only product managers can delete products"},
        )

    product = crud.product.get(db=db, field="id", value=product_id)
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Product does not exist"},
        )

    product = crud.product.remove(db=db, id=product_id)
    #print(product)
    return Response(isSuccess=True)

@router.patch("/{id}/updateStock", response_model=Response[schemas.Product])
async def update_stock(
    id: int,
    stock: int,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Update product stock
    """
    if current_user.user_type != UserType.PRODUCT_MANAGER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"message":"Only product managers can update products stock"},
        )

    product = crud.product.increase_stock(db=db, product_id=id, stock=stock)
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Product does not exists"},
        )
    return Response(data=product)

#a post method that adds multiple photos to a product
@router.post("/{product_id}/photo/add", response_model=Response[schemas.Product])
async def add_photos(
    product_id: int,
    files: List[UploadFile] = File(...),
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Add photos to a product
    """
    if current_user.user_type != UserType.PRODUCT_MANAGER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"message":"Only product managers add photos to products"},
        )

    product = crud.product.get(db=db, field="id", value=product_id)
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Product does not exist"},
        )
    
    for file in files:
        added_photo = crud.product.add_photo(db=db, product=product, photo=file)
        photo_url = ImageUtilities.get_image_url(added_photo.photo_url)

    return Response(data=product)
    


@router.delete("/{id}/photo/{photo_id}/remove", response_model=Response)
async def remove_photo_to_product(
    *,
    id: int,
    photo_id: int,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
):
    """
    Removes photo of product.
    """
    if current_user.user_type != UserType.PRODUCT_MANAGER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"message":"Only product managers can remove photos from products"},
        )

    product = crud.product.get(db=db, field="id", value=id)
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Product does not exists"},
        )

    added_photo = crud.product.remove_photo(db=db, photo_id=photo_id)
    if not added_photo:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Photo of the product does not exists"},
        )
    photo_url = ImageUtilities.get_image_url(added_photo.photo_url)
    return Response(data=photo_url, message="Deleted photo successfully")
