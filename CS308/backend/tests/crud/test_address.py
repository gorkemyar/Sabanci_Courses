#test create delete exists, update, get_multi of address
#import
from sqlalchemy.orm import Session
from typing import List
from crud.base import CRUDBase
from models.address import Address
from schemas.address import AddressCreate, AddressInDBBase, AddressUpdate

#create test
def test_create_address(db: Session) -> None:
    address_in = AddressCreate(
        name="test",
        full_address="test",
        postal_code= "test",
        city= "test",
        province= "test",
        country= "test",
        personal_name= "test",
        phone_number= "test"
    )
    address = address.create(db, user_id=1, address_in=address_in)
    assert address.id == 1
    assert address.user_id == 1
    assert address.name == "test"
    assert address.full_address == "test"
    assert address.postal_code == "test"
    assert address.city == "test"
    assert address.province == "test"
    assert address.country == "test"
    assert address.personal_name == "test"
    assert address.phone_number == "test"

#delete test
def test_delete_address(db: Session) -> None:
    address_in = AddressCreate(
        name="test",
        full_address="test",
        postal_code= "test",
        city= "test",
        province= "test",
        country= "test",
        personal_name= "test",
        phone_number= "test"
    )
    address = address.create(db, user_id=1, address_in=address_in)
    address.delete(db)
    assert address.id == 1
    assert address.user_id == 1
    assert address.name == "test"
    assert address.full_address == "test"
    assert address.postal_code == "test"
    assert address.city == "test"
    assert address.province == "test"
    assert address.country == "test"
    assert address.personal_name == "test"
    assert address.phone_number == "test"

#exists test
def test_exists_address(db: Session) -> None:
    address_in = AddressCreate(
        name="test",
        full_address="test",
        postal_code= "test",
        city= "test",
        province= "test",
        country= "test",
        personal_name= "test",
        phone_number= "test"
    )
    address = address.create(db, user_id=1, address_in=address_in)
    assert address.exists(db, user_id=1, id=1)

#update test
def test_update_address(db: Session) -> None:
    address_in = AddressCreate(
        name="test",
        full_address="test",
        postal_code= "test",
        city= "test",
        province= "test",
        country= "test",
        personal_name= "test",
        phone_number= "test"
    )
    address = address.create(db, user_id=1, address_in=address_in)
    address_in = AddressUpdate(
        name="test",
        full_address="test",
        postal_code= "test",
        city= "test",
        province= "test",
        country= "test",
        personal_name= "test",
        phone_number= "test"
    )
    address = address.update(db, user_id=1, id=1, address_in=address_in)
    assert address.id == 1
    assert address.user_id == 1
    assert address.name == "test"
    assert address.full_address == "test"
    assert address.postal_code == "test"
    assert address.city == "test"
    assert address.province == "test"
    assert address.country == "test"
    assert address.personal_name == "test"
    assert address.phone_number == "test"

#get_multi test
def test_get_multi_address(db: Session) -> None:
    address_in = AddressCreate(
        name="test",
        full_address="test",
        postal_code= "test",
        city= "test",
        province= "test",
        country= "test",
        personal_name= "test",
        phone_number= "test"
    )
    address = address.create(db, user_id=1, address_in=address_in)
    address_in = AddressCreate(
        name="test",
        full_address="test",
        postal_code= "test",
        city= "test",
        province= "test",
        country= "test",
        personal_name= "test",
        phone_number= "test"
    )
    address = address.create(db, user_id=1, address_in=address_in)
    address_in = AddressCreate(
        name="test",
        full_address="test",
        postal_code= "test",
        city= "test",
        province= "test",
        country= "test",
        personal_name= "test",
        phone_number= "test"
    )
    address = address.create(db, user_id=1, address_in=address_in)
    address_in = AddressCreate(
        name="test",
        full_address="test",
        postal_code= "test",
        city= "test",
        province= "test",
        country= "test",
        personal_name= "test",
        phone_number= "test"
    )
    address = address.create(db, user_id=1, address_in=address_in)
    address_in = AddressCreate(
        name="test",
        full_address="test",
        postal_code= "test",
        city= "test",
        province= "test",
        country= "test",
        personal_name= "test",
        phone_number= "test"
    )
    #test get_multi
    addresses = address.get_multi(db, user_id=1)
    assert len(addresses) == 5
    assert addresses[0].id == 1
    assert addresses[0].user_id == 1
    assert addresses[0].name == "test"
    assert addresses[0].full_address == "test"
    assert addresses[0].postal_code == "test"
    assert addresses[0].city == "test"
    assert addresses[0].province == "test"
    assert addresses[0].country == "test"
    assert addresses[0].personal_name == "test"
    assert addresses[0].phone_number == "test"
    #assert the last one
    assert addresses[4].id == 5
    assert addresses[4].user_id == 1
    assert addresses[4].name == "test"
    assert addresses[4].full_address == "test"
    assert addresses[4].postal_code == "test"
    assert addresses[4].city == "test"
    assert addresses[4].province == "test"
    assert addresses[4].country == "test"
    assert addresses[4].personal_name == "test"
    assert addresses[4].phone_number == "test"


