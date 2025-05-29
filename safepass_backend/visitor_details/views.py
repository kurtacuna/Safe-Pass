from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny, IsAuthenticated
from . import models, serializers
from rest_framework.parsers import MultiPartParser, FormParser
import face_recognition
import cv2
import numpy as np
from django.core.files.uploadedfile import InMemoryUploadedFile
from django.shortcuts import render
from django.db.models import Q
from django.utils import timezone
import json
import os
import base64
from django.core.files.base import ContentFile
from django.conf import settings
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile

def checkImage (uploaded_photo: InMemoryUploadedFile):
  image_bytes = uploaded_photo.read()
  np_array = np.frombuffer(image_bytes, np.uint8)
  cv2_image = cv2.imdecode(np_array, cv2.IMREAD_COLOR)

  if cv2_image is None:
    return Response({"detail": "Could not decode image. Invalid image file."}, status=status.HTTP_400_BAD_REQUEST)
    
  rgb_image = cv2.cvtColor(cv2_image, cv2.COLOR_BGR2RGB)
  face_locations = face_recognition.face_locations(rgb_image)

  if not face_locations:
    return Response({"detail": "No face detected in the uploaded photo. Please upload a photo with a clear face."}, status=status.HTTP_400_BAD_REQUEST)
  
  if len(face_locations) > 1:
    return Response({"detail": "Multiple faces detected. Please upload a photo with only one clear face."}, status=status.HTTP_400_BAD_REQUEST)

# Create your views here.
class IdTypesView(APIView):
  permission_classes = [IsAuthenticated]
  def get(self, request):
    try:
      id_types = models.IdTypes.objects.all()
      serializer = serializers.IdTypesSerializer(id_types, many=True)

      return Response({"id_types": serializer.data}, status=status.HTTP_200_OK)
    except Exception as e:
      print(f"IdTypesView: {str(e)}")
      return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class VisitorRegistration(APIView):
  permission_classes = [IsAuthenticated]
  parser_classes = (MultiPartParser, FormParser)
  def post(self, request):
    uploaded_photo: InMemoryUploadedFile = request.FILES.get('photo')
    if not uploaded_photo:
      return Response({"detail": "No photo received. Try again."}, status=status.HTTP_400_BAD_REQUEST)

    try:
      checkImage(uploaded_photo)
      print("Received registration request with data:", request.data)
      reg_details = json.loads(request.POST['reg_details'])
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
          photo=uploaded_photo,
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


class VisitorsView(APIView):
  permission_classes = [IsAuthenticated]

  def get(self, request):
    try:
      visitors = models.VisitorDetails.objects.all().order_by('-registration_date')
      serializer = serializers.VisitorDetailsSerializer(visitors, many=True)
      return Response({"visitors": serializer.data}, status=status.HTTP_200_OK)
    except Exception as e:
      print(f"VisitorsView: {str(e)}")
      return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    

class UpdateVisitorDetailsView(APIView):
  permission_classes = [IsAuthenticated]

  def post(self, request):
    update_details = request.data.get('update_details')
    id = update_details.get('id')
    first_name = update_details.get('first_name')
    middle_name = update_details.get('middle_name')
    last_name = update_details.get('last_name')
    contact_number = update_details.get('contact_number')
    id_type = update_details.get('id_type')
    id_number = update_details.get('id_number')
    new_status = update_details.get('status')
    
    print(update_details)

    try:
      visitor = models.VisitorDetails.objects.get(id=id)
      visitor.first_name = first_name
      visitor.middle_name = middle_name
      visitor.last_name = last_name
      visitor.contact_number = contact_number
      visitor.id_type = models.IdTypes.objects.get(type=id_type)
      visitor.id_number = id_number
      visitor.status = new_status
      visitor.save()
      return Response({"detail": "Visitor details updated successfully"}, status=status.HTTP_200_OK)
    except visitor.DoesNotExist:
      return Response({"detail": "Invalid visitor"}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
      print(f"UpdateVisitorDetailsView: {str(e)}")
      return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class UpdateVisitorPhotoView(APIView):
  permission_classes = [IsAuthenticated]
  parser_classes = (MultiPartParser, FormParser)

  def post(self, request):
    user_id = request.data.get('id')
    uploaded_photo: InMemoryUploadedFile = request.FILES.get('photo')
    
    try:
      checkImage(uploaded_photo)
      visitor = models.VisitorDetails.objects.get(id=user_id)
      if visitor.photo.name != 'default_photo/no_photo.png':
        visitor.photo.delete(save=False)
        
      visitor.photo = uploaded_photo
      visitor.save(dont_save_id_number=True)

      return Response({"detail": "Visitor photo updated successfully"}, status=status.HTTP_200_OK)
    except visitor.DoesNotExist:
      return Response({"detail": "Invalid visitor"}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
      print(f"UpdateVisitorDetailsView: {str(e)}")
      return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class VisitorSearchView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        query = request.GET.get('query', '')
        if not query:
            return Response({'results': []})

        visitors = models.VisitorDetails.objects.filter(
            Q(id_number__icontains=query) |
            Q(full_name__icontains=query)
        ).order_by('-registration_date')[:10]

        results = []
        for visitor in visitors:
            # Get the last visit date for this visitor where check_out is not null
            # This ensures we only get completed visits
            last_visit = visitor.visitor_logs_set.filter(
                check_out__isnull=False
            ).order_by('-visit_date', '-check_out').first()
            
            last_visit_date = last_visit.visit_date if last_visit else None

            # Format the display string as "ID (Full Name)"
            display_string = f"{visitor.id_number} ({visitor.full_name})"

            results.append({
                'id': str(visitor.id),
                'id_number': visitor.id_number,
                'full_name': visitor.full_name,
                'display_string': display_string,
                'last_visit_date': last_visit_date.strftime('%Y-%m-%d') if last_visit_date else 'No previous visits'
            })

        return Response({'results': results})
