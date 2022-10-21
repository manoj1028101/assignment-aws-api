from typing import Any
from fastapi import FastAPI
import uvicorn
import datetime
import redis
from conf import config
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from conf import config

def setup_middlewares(app):
    app.add_middleware(
        CORSMiddleware,
        allow_origins=config.CORS_WHITELIST_DOMAINS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

def setup_database(app: FastAPI):
    # Init the master db
    engine = create_engine(config.SQLALCHEMY_DATABASE_URI, echo=True)
    app.state.db = sessionmaker(autoflush=False, autocommit=False, bind=engine)

def setup_redis(app: FastAPI):
    # Init the redis cache connection
    cache = redis.Redis(config.REDIS_HOST)
    app.state.cache = cache

def create_app():
    """App factory."""

    app = FastAPI(
        title=config.API_NAME,
        version=config.VERSION,
        openapi_url=f'{config.API_PREFIX}/{config.OPENAPI_URL}',
        docs_url=f'{config.API_PREFIX}/{config.DOCS_URL}',
        redoc_url=f'{config.API_PREFIX}/{config.REDOC_URL}'
    )
    app.config = config

    setup_database(app)
    setup_redis(app)
    setup_middlewares(app)

    return app

app = create_app()

@app.get("/")
def hello_world():
    """
        Health check endpoint
    """
    today = str(datetime.datetime.today())
    session = app.state.db()
    db_active = session.execute("SELECT 1").first()[0]
    cache_active = app.state.cache.ping()
    return {
        "timestamp": today,
        "cache": cache_active,
        "db": db_active
    }
