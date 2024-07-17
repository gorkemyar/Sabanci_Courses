from operator import add
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from api import deps
from core.security import get_password_hash, verify_password

import crud, models, schemas
from schemas import Response
from typing import Any, List

from schemas.user import ChangePasswordIn, User, UserBase, UserInDBBase, UserUpdate

router = APIRouter()

@router.get("/", response_model=Response[UserBase])
def get_user(
    *,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
) -> Any:
    """
    Get user data such as email and name, this needs to be updated when a new data point is added to the user
    """
    return Response(message="User data", data=UserBase(email=current_user.email, full_name=current_user.full_name, is_active=current_user.is_active, user_type=current_user.user_type))

@router.patch("/change_user_data", response_model=Response[UserBase])
def update_user(
    *,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
    user_in: UserUpdate
) -> Any:
    """
    Change user data exept for password
    """
    #I am assuming the only necesary check for the update of the user info would have been existance check but 
    #we already know it exists thanks to the currnet_user
    user_in=User(
        email=user_in.email,
        full_name=user_in.full_name,
        is_active=user_in.is_active,
        user_type=user_in.user_type
    )
    user = crud.user.update(
        db, db_obj=current_user, obj_in=user_in)
    return Response(message="Updated successfully")

@router.patch("/change_password", response_model=Response)
def update_password(
    *,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
    change_in: schemas.ChangePasswordIn
) -> Any:
    """
    Updates the password of current user
    """
    #check the efficacy of the old_password
    return crud.user.update_password(db=db, current_user=current_user, change_in= change_in)

#send user a mail with a subject and a body using the send_mail_to_current_user function
@router.post("/send_mail", response_model=Response)
def send_mail(
    *,
    db: Session = Depends(deps.get_db),
    current_user: models.User = Depends(deps.get_current_user),
    subject: str,
    body: str
) -> Any:
    """
    Sends a mail to the current user
    """
    return crud.user.send_mail_to_current_user(db=db, user_id=current_user.id, subject=subject, message=body)
    
