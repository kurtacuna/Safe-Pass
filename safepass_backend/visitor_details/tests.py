from rest_framework.test import APITestCase, APIClient
from . import models
from django.urls import reverse
import json

# Create your tests here.
class TestIdTypesView(APITestCase):
  def setUp(self):
    models.IdTypes.objects.create(
      type="Passport"
    )
    models.IdTypes.objects.create(
      type="National ID"
    )
    self.client = APIClient()
  
  # def test_id_types_view(self):
  #   url = reverse('id-types')
  #   response = self.client.get(url)

  #   print(response.content)

  def test_registration(self):
    print(models.VisitorDetails.objects.all().values())
    url = reverse('visitor-registration')
    response = self.client.post(
      url,
      content_type="application/json",
      data=json.dumps({
          "registration_details": {
              "first_name" : "first_name",
              "middle_name" : "middle_name",
              "last_name" : "last_name",
              "id_type" : "Passport", 
              "id_number" :  "id_number", 
              "contact_number" : "contact_number"
            }
        })
      )
    
    print(response.content)
    print(models.VisitorDetails.objects.all().values())



  