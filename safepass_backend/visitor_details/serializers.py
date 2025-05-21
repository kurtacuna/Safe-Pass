from rest_framework import serializers
from . import models

class IdTypesSerializer(serializers.ModelSerializer):
  class Meta:
    model = models.IdTypes
    fields = "__all__"

class VisitorDetailsSerializer(serializers.ModelSerializer):
  class Meta:
    model = models.VisitorDetails
    fields = "__all__"
