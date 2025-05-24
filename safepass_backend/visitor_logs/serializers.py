from rest_framework import serializers
from . import models
from visitor_details.serializers import VisitorDetailsSerializer

class VisitorLogsSerializers(serializers.ModelSerializer):
    visitor_details = serializers.SerializerMethodField()

    def get_visitor_details(self, obj):
        serializer = VisitorDetailsSerializer(obj.visitor_details)
        return serializer.data
    
    purpose = serializers.SerializerMethodField()
    def get_purpose(self, obj):
        serializer = VisitPurposes(obj.purpose)
        return serializer.data
    
    status = serializers.SerializerMethodField()
    def get_status(self, obj):
        serializer = VisitorStatus(obj.status)
        return serializer.data

    class Meta:
        model = models.visitor_logs
        fields = '__all__'

class VisitPurposes(serializers.ModelSerializer):
  class Meta:
    model = models.VisitPurposes
    fields = "__all__"

class VisitorStatus(serializers.ModelSerializer):
    class Meta:
        model = models.visitor_status
        fields = "__all__"




        