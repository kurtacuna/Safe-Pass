from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from . import models, serializers

class VisitorLogsView(APIView):
    def get(self, request):

        try:
            visitor_details = models.visitor_logs.objects.all()
            serializer = serializers.VisitorDetailsSerializer(visitor_details, many = True)
            return Response(serializer.data, status = status.HTTP_200_OK)

        except Exception as e:
            print(e) 
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)