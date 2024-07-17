from sqlalchemy.orm import Session

import crud
from schemas.credit import CreditCreate, CreditInDBBase, CreditUpdate, CreditPrivate
from tests.utils.utils import random_integer, random_lower_string, random_integer

#test_create_credit
def test_create_credit(db: Session) -> None:
    credit_name = random_lower_string()
    #payment_method: str card_name: str cardnumber: str CW: str expiry_date: str
    credit_in = CreditCreate(payment_method=credit_name, card_name=credit_name, cardnumber=credit_name, CW=credit_name, expiry_date=credit_name)
    credit = crud.credit.create(db=db, obj_in=credit_in)
    assert credit.card_name == credit_name
    assert credit.payment_method == credit_name
    assert credit.cardnumber == credit_name
    assert credit.CW == credit_name
    assert credit.expiry_date == credit_name

#test_get_multi_credit
def test_get_multi_credit(db: Session) -> None:
    credit_name = random_lower_string()
    #payment_method: str card_name: str cardnumber: str CW: str expiry_date: str
    credit_in = CreditCreate(payment_method=credit_name, card_name=credit_name, cardnumber=credit_name, CW=credit_name, expiry_date=credit_name)
    credit1 = crud.credit.create(db=db, obj_in=credit_in)
    credit_name2 = random_lower_string()
    #payment_method: str card_name: str cardnumber: str CW: str expiry_date: str
    credit_in = CreditCreate(payment_method=credit_name, card_name=credit_name, cardnumber=credit_name, CW=credit_name, expiry_date=credit_name)
    credit2 = crud.credit.create(db=db, obj_in=credit_in)
    list_of_credits = crud.credit.get_multi(db=db)
    assert len(list_of_credits)>=2
    assert list_of_credits[-1].card_name==credit_name2
    assert list_of_credits[-1].payment_method==credit_name
    assert list_of_credits[-1].cardnumber==credit_name
    assert list_of_credits[-1].CW==credit_name
    assert list_of_credits[-1].expiry_date==credit_name

#crediit exists
def test_credit_exists(db: Session) -> None:
    credit_name = random_lower_string()
    #payment_method: str card_name: str cardnumber: str CW: str expiry_date: str
    credit_in = CreditCreate(payment_method=credit_name, card_name=credit_name, cardnumber=credit_name, CW=credit_name, expiry_date=credit_name)
    credit = crud.credit.create(db=db, obj_in=credit_in)
    credit_exists = crud.credit.exists(db=db, user_id=credit.user_id, id=credit.id)
    assert credit_exists is not None

#delete and update credit
def test_delete_credit(db: Session) -> None:
    credit_name = random_lower_string()
    #payment_method: str card_name: str cardnumber: str CW: str expiry_date: str
    credit_in = CreditCreate(payment_method=credit_name, card_name=credit_name, cardnumber=credit_name, CW=credit_name, expiry_date=credit_name)
    credit = crud.credit.create(db=db, obj_in=credit_in)
    crud.credit.delete(db=db, id=credit.id)
    credit_exists = crud.credit.exists(db=db, user_id=credit.user_id, id=credit.id)
    assert credit_exists is None

def test_update_credit(db: Session) -> None:
    credit_name = random_lower_string()
    #payment_method: str card_name: str cardnumber: str CW: str expiry_date: str
    credit_in = CreditCreate(payment_method=credit_name, card_name=credit_name, cardnumber=credit_name, CW=credit_name, expiry_date=credit_name)
    credit = crud.credit.create(db=db, obj_in=credit_in)
    credit_name2 = random_lower_string()
    #payment_method: str card_name: str cardnumber: str CW: str expiry_date: str
    credit_in = CreditCreate(payment_method=credit_name, card_name=credit_name, cardnumber=credit_name, CW=credit_name, expiry_date=credit_name)
    credit = crud.credit.update(db=db, id=credit.id, obj_in=credit_in)
    assert credit.card_name == credit_name2
    assert credit.payment_method == credit_name
    assert credit.cardnumber == credit_name
    assert credit.CW == credit_name
    assert credit.expiry_date == credit_name



