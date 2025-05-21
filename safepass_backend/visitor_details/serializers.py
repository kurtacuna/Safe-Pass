from rest_framework import serializers
from . import models

class IdTypesSerializer(serializers.ModelSerializer):
  class Meta:
    model = models.IdTypes
    fields = "__all__"

class VisitorDetailsSerializer(serializers.ModelSerializer):
   id_type = serializers.SerializerMethodField()
   def get_id_type(self, obj):
      serializer = IdTypesSerializer(obj.id_type)
      return serializer.data

   class Meta:
    model = models.VisitorDetails
    fields = "__all__"
