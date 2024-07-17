import pathlib
import sys
import os


import alembic
from sqlalchemy import engine_from_config, create_engine, pool
from psycopg2 import DatabaseError


from logging.config import fileConfig

# we're appending the app directory to our path here so that we can import config easily
sys.path.append(str(pathlib.Path(__file__).resolve().parents[1]))


from core.config import settings # noqa

from db.base import Base
target_metadata = Base.metadata

# Alembic Config object, which provides access to values within the .ini file
config = alembic.context.config

# Interpret the config file for logging
fileConfig(config.config_file_name)


def run_migrations_online() -> None:
    """
    Run migrations in 'online' mode
    """
    

    # handle testing config for migrations
    if settings.TESTING:
        # connect to primary db
        default_engine = create_engine(str(settings.DATABASE_URL), isolation_level="AUTOCOMMIT")
        # drop testing db if it exists and create a fresh one
        with default_engine.connect() as default_conn:
            default_conn.execute(f"DROP DATABASE IF EXISTS {settings.DB_NAME}_test")
            default_conn.execute(f"CREATE DATABASE {settings.DB_NAME}_test")

    connectable = config.attributes.get("connection", None)
    config.set_main_option("sqlalchemy.url", settings.DB_URL)

    if connectable is None:
        connectable = engine_from_config(
            config.get_section(config.config_ini_section), prefix="sqlalchemy.", poolclass=pool.NullPool,
        )

    with connectable.connect() as connection:
        alembic.context.configure(connection=connection, target_metadata=Base.metadata)

        with alembic.context.begin_transaction():
            alembic.context.run_migrations()


def run_migrations_offline() -> None:
    """
    Run migrations in 'offline' mode.
    """

    if os.environ.get("TESTING"):
        raise DatabaseError("Running testing migrations offline currently not permitted.")

    alembic.context.configure(url=str(settings.DATABASE_URL))

    with alembic.context.begin_transaction():
        alembic.context.run_migrations()


if alembic.context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()