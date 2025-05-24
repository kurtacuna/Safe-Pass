from rest_framework.test import APITestCase, APIClient
from . import models
from django.urls import reverse

# Create your tests here.
class IdTypesViewTest(APITestCase):
  def setUp(self):
    id_type1 = models.IdTypes.objects.create(
      type="Passport"
    )
    models.IdTypes.objects.create(
      type="National ID"
    )

    models.VisitorDetails.objects.create(
      first_name="test",
      last_name="tester",
      contact_number = "123",
      id_type = id_type1,
      id_number="456",
      status="Approved"
    )

    self.client = APIClient()
  
  def test_id_types_view(self):
    # print(models.VisitorDetails.objects.all().values())

    url = reverse('id-types')
    response = self.client.get(url)

    print(response.content)