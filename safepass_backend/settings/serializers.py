from rest_framework import serializers
from . import models


class AppSettingsSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.AppSettings
        fields = '__all__'