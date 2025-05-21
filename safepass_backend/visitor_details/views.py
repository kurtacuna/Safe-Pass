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


class VisitorDetailsView(APIView):
  def post(self, request):
    reg_details = request.data.get("reg_details")
    first_name = reg_details.get('first_name')
    middle_name = reg_details.get('middle_name')
    last_name = reg_details.get('last_name')
    id_type = reg_details.get('id_type')
    id_number = reg_details.get('id_number')
    visit_purposes = reg_details.get('visit_purposes')
    contact_number = reg_details.get('contact_number')  


    try: 
      id_type_instance = models.IdTypes.objects.get(type = id_type)
      models.VisitorDetails.objects.create(
        first_name = first_name,
        middle_name = middle_name, 
        last_name = last_name, 
        id_type = id_type_instance, 
        id_number = id_number, 
        visit_purposes = visit_purposes, 
        contanct_number = contact_number
      )
    
      return Response(status = status.HTTP_200_OK)
    except Exception as e : 
      print ("VisitorDetailsView")
      print(e)


   