from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from . import models, serializers

# Create your views here.
class IdTypesView(APIView):
  permission_classes = [IsAuthenticated]
  def get(self, request):
    id_types = models.IdTypes.objects.all()
    serializer = serializers.IdTypesSerializer(id_types, many=True)

    return Response(serializer.data, status=status.HTTP_200_OK)


class VisitorRegistration(APIView):
  permission_classes = [IsAuthenticated]
  def post(self, request):
    try:
      print("Received registration request with data:", request.data)
      reg_details = request.data
      if not reg_details:
        return Response(
          {'detail': 'No registration details provided'},
          status=status.HTTP_400_BAD_REQUEST
        )

      first_name = reg_details.get('first_name')
      middle_name = reg_details.get('middle_name', '')
      last_name = reg_details.get('last_name')
      id_type = reg_details.get('id_type')
      id_number = reg_details.get('id_number')
      contact_number = reg_details.get('contact_number')

      print("Extracted fields:")
      print(f"First Name: {first_name}")
      print(f"Middle Name: {middle_name}")
      print(f"Last Name: {last_name}")
      print(f"ID Type: {id_type}")
      print(f"ID Number: {id_number}")
      print(f"Contact Number: {contact_number}")

      # Validate required fields
      required_fields = ['first_name', 'last_name', 'id_type', 'id_number', 'contact_number']
      missing_fields = [field for field in required_fields if not reg_details.get(field)]
      if missing_fields:
        print("Missing required fields:", missing_fields)
        return Response(
          {'detail': f'Missing required fields: {", ".join(missing_fields)}'},
          status=status.HTTP_400_BAD_REQUEST
        )

      try:
        print("Looking up ID type:", id_type)
        id_type_instance = models.IdTypes.objects.get(type=id_type)
        print("Found ID type instance:", id_type_instance)
      except models.IdTypes.DoesNotExist:
        print("ID type not found:", id_type)
        return Response(
          {'detail': f'Invalid ID type: {id_type}'},
          status=status.HTTP_400_BAD_REQUEST
        )

      try:
        print("Creating visitor with fields:", {
          'first_name': first_name,
          'middle_name': middle_name,
          'last_name': last_name,
          'id_type': id_type_instance,
          'id_number': id_number,
          'contact_number': contact_number
        })
        visitor = models.VisitorDetails.objects.create(
          first_name=first_name,
          middle_name=middle_name,
          last_name=last_name,
          id_type=id_type_instance,
          id_number=id_number,
          contact_number=contact_number
        )
        print("Visitor created successfully with ID:", visitor.id)
      except Exception as create_error:
        print("Error creating visitor:", str(create_error))
        raise create_error

      return Response(
        {'detail': 'Visitor registered successfully', 'id': visitor.id},
        status=status.HTTP_201_CREATED
      )

    except Exception as e:
      print("VisitorRegistration Error:", str(e))
      print("Error type:", type(e).__name__)
      import traceback
      print("Full traceback:")
      print(traceback.format_exc())
      return Response(
        {'detail': f'An error occurred while registering the visitor: {str(e)}'},
        status=status.HTTP_500_INTERNAL_SERVER_ERROR
      )


   