from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from . import models, serializers

# Create your views here.
class IdTypesView(APIView):
  def get(self, request):
    id_types = models.IdTypes.objects.all()
    serializer = serializers.IdTypesSerializer(id_types, many=True)

    return Response(serializer.data, status=status.HTTP_200_OK)
