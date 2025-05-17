from rest_framework import serializers
from . import models

class IdTypesSerializer(serializers.ModelSerializer):
  class Meta:
    model = models.IdTypes
    fields = "__all__"
