from django.contrib.auth.models import AbstractUser
from django.db import models
from .managers import CustomUserManager

class CustomUser(AbstractUser):
    username = None
    email = models.EmailField(unique=True, null=False, blank=False)

    USERNAME_FIELD = 'email'

    REQUIRED_FIELDS=[]

    objects = CustomUserManager()

    def __str__(self):
        return self.email