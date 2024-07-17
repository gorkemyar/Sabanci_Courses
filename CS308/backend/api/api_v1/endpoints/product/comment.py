from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from api import deps

import crud, models, schemas
from schemas import Response
from typing import Any, List

router = APIRouter()


@router.get(
    "/{product_id}/comments", response_model=Response[List[schemas.Comment]]
)
def get_comments_of_product(
    product_id: int,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(deps.get_db),
) -> Any:
    """
    Retrieve comments of a particular product.
    """
    product = crud.product.get_comments(db=db, id=product_id, skip=skip, limit=limit)
    return Response(data=product, isSuccess=True)


@router.post("/{product_id}/comment", response_model=Response[schemas.CommentBase])
def create_comment(
    *,
    product_id: int,
    comment_in: schemas.CommentCreate,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Create new comment.
    """
    comment_in.user_id = current_user.id
    product = crud.product.get(db=db, field="id", value=product_id)
    comment_in.product_id = product_id

    if comment_in.rate <= 1 or comment_in.rate > 5:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Rate should be between 1 and 5"},
        )


    comment = crud.comment.create(db=db, obj_in=comment_in)
    return Response(data=comment, isSuccess=True)


@router.delete(
    "/{product_id}/comments/{comment_id}", response_model=Response[schemas.CommentBase]
)
def delete_comment(
    *,
    product_id: int,
    comment_id: int,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Delete a comment.
    """
    comment = crud.comment.get(db=db, field="id", value=comment_id)
    if not comment:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Comment does not exist"},
        )
    if comment.user_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_405_METHOD_NOT_ALLOWED,
            detail={"message": f"You can't delete this comment!"},
        )
    comment = crud.comment.remove(db=db, id=comment_id)
    return Response(data=comment, isSuccess=True)

@router.post("/{product_id}/comment/{id}/active", response_model=Response[schemas.CommentBase])
def create_comment(
    *,
    product_id: int,
    id: int,
    comment_in: schemas.CommentUpdateActive,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Activate the comment.
    """
    db_comment = crud.comment.get(db=db, field="id", value=id)
    if not db_comment:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"message": f"Comment does not exist"},
        )

    if current_user.user_type != models.user.UserType.PRODUCT_MANAGER:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"message": "Only product managers can approve the comments."},
        )

    comment = crud.comment.update(db=db, db_obj=db_comment, obj_in=comment_in)
    return Response(data=comment)