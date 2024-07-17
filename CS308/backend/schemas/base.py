from pydantic import BaseModel


class CustomBase(BaseModel):
    def dict(self, **kwargs):
        include = getattr(self.Config, "include", set())
        if len(include) == 0:
            include = None
        exclude = getattr(self.Config, "exclude", set())
        if len(exclude) == 0:
            exclude = None
        return super().dict(include=include, exclude=exclude, **kwargs)