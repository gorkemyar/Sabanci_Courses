from fastapi import APIRouter
from api.api_v1.endpoints import users
from api.api_v1.endpoints.authentication import login, registration
from api.api_v1.endpoints.product import comment, product, rate_product, search, price_product
from api.api_v1.endpoints.category import category
from api.api_v1.endpoints.category import subcategory
from api.api_v1.endpoints.user import address
from api.api_v1.endpoints.user import credit
from api.api_v1.endpoints.shoppingcart import shoppingcart
from api.api_v1.endpoints.order import order
from api.api_v1.endpoints.user import favorite

api_router = APIRouter()

api_router.include_router(users.router, prefix="/users", tags=["User"])
api_router.include_router(shoppingcart.router, prefix="/users", tags=["Shopping Cart"])
api_router.include_router(order.router, prefix="/users", tags=["Order"])
api_router.include_router(address.router, prefix="/user", tags=["User"])
api_router.include_router(credit.router, prefix="/user", tags=["User"])
api_router.include_router(favorite.router, prefix="/users", tags=["User"])

api_router.include_router(login.router, prefix="/auth", tags=["Authentication"])
api_router.include_router(registration.router, prefix="/auth", tags=["Authentication"])

api_router.include_router(product.router, prefix="/products", tags=["Products"])
api_router.include_router(search.router, prefix="/products", tags=["Products"])
api_router.include_router(rate_product.router, prefix="/products", tags=["Products"])

api_router.include_router(price_product.router, prefix="/products", tags=["Prices"])
api_router.include_router(comment.router, prefix="/products", tags=["Comments"])

api_router.include_router(
    category.router, prefix="/categories", tags=["Categories & Subcategories"]
)
api_router.include_router(
    subcategory.router, prefix="/categories", tags=["Categories & Subcategories"]
)

