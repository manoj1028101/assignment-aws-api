import os
from functools import lru_cache
import dotenv
from pydantic import BaseModel

dotenv.load_dotenv()


class DevelopmentConfig(BaseModel):
    """Base configuration."""

    CORS_WHITELIST_DOMAINS = ["http://localhost:3000", "http://localhost",]

    MASTER_USER: str = "combyne"
    MASTER_PWD: str = "superSecretPassword"
    MASTER_HOST: str = "localhost"
    MASTER_DB_NAME: str = "combyne"
    SQLALCHEMY_DATABASE_URI = "mysql+pymysql://{user}:{password}@{host}/{db_name}".format(
        user=MASTER_USER,
        password=MASTER_PWD,
        host=MASTER_HOST,
        db_name=MASTER_DB_NAME,
    )
    API_NAME: str = "combyne"
    VERSION: str = "v1.0"
    API_PREFIX: str = "/api"
    OPENAPI_URL: str = "openapi.json"
    DOCS_URL: str = "docs"
    REDOC_URL: str = "redocs"
    DEBUG: bool = False
    REDIS_HOST: str = "localhost"
    APP_PROCESSES = 1
    APP_THREADED = False


@lru_cache
def from_envvar():
    """Get environment configuration"""
    loaded_config = DevelopmentConfig(**os.environ)
    return loaded_config

config = from_envvar()
