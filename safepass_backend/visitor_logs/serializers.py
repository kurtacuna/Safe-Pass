from rest_framework import serializers
from . import models
from visitor_details import models as visitor_details_models
from visitor_details.serializers import VisitorDetailsSerializer

class VisitorLogsSerializers(serializers.ModelSerializer):
    visitor_details = serializers.SerializerMethodField()

    def get_visitor_details(self, obj):
        print("HI")
        print(type(obj.visitor_details))
        print("id:" + f"{obj.visitor_details.id}")
        visitor_details = visitor_details_models.VisitorDetails.objects.get(
            id = obj.visitor_details.id
        )
        print('hello')
        print(visitor_details.full_name)

        visitor_detail_serializer = VisitorDetailsSerializer(obj.visitor_details)
        data = visitor_detail_serializer.data.get("full_name")
        return {"full_name": data}
    
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




        