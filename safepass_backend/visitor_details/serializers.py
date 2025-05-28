from rest_framework import serializers
from . import models

class IdTypesSerializer(serializers.ModelSerializer):
  class Meta:
    model = models.IdTypes
    exclude = ['id']

class VisitorDetailsSerializer(serializers.ModelSerializer):
   id_type = serializers.SerializerMethodField()
   photo = serializers.SerializerMethodField()

   def get_photo(self, obj):
     photo_url = obj.photo.url if obj.photo else None
     return photo_url

   def get_id_type(self, obj):
      serializer = IdTypesSerializer(obj.id_type)
      return serializer.data

   class Meta:
    model = models.VisitorDetails
    fields = "__all__"
