from core.config import settings
from fastapi import FastAPI, Body
from api.api_v1.api import api_router as api_router_v1
from core.celery_worker import create_task
from fastapi.responses import JSONResponse
from fastapi import HTTPException
from fastapi.encoders import jsonable_encoder
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware


app = FastAPI(
    title=settings.APP_NAME,
    description=settings.APP_DESCRIPTION,
    docs_url=settings.API_V1_STR + "/docs",
)

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(api_router_v1, prefix=settings.API_V1_STR)
app.mount("/static", StaticFiles(directory="static"), name="static")


@app.get("/")
def index():
    return {"msg": "Hello World Test"}


@app.post("/test_celery")
def test_celery(data=Body(...)):
    amount = int(data["amount"])
    x = data["x"]
    y = data["y"]
    task = create_task.delay(amount, x, y)
    return JSONResponse({"result": task.get()})


@app.exception_handler(HTTPException)
async def http_exception_handler(request, exc):
    body = jsonable_encoder(exc)
    detail = body["detail"]
    message = str()
    if "message" in detail:
        message = detail["message"]

    return JSONResponse(
        {"message": message, "isSuccess": False}, status_code=body["status_code"]
    )
