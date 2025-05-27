from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.permissions import AllowAny
from . import models, serializers

class VisitorLogsView(APIView):
    permission_classes = [AllowAny] 
    
    def get(self, request):

        try:
            visitor_logs = models.visitor_logs.objects.all()
            serializer = serializers.VisitorLogsSerializers(visitor_logs, many = True)
            return Response(serializer.data, status = status.HTTP_200_OK)

        except Exception as e:
            print(e) 
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)