from rest_framework.test import APITestCase, APIClient
from . import models
from django.urls import reverse

# Create your tests here.
class IdTypesViewTest(APITestCase):
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

  