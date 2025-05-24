from rest_framework.test import APITestCase, APIClient
from . import models
from django.urls import reverse
from visitor_details import models as visitor_details_models
from datetime import time, date

class VisitorLogsTest(APITestCase):
    def setUp(self):
        purpose = models.VisitPurposes.objects.create(
            purpose ="Visit"
        )
        status = models.visitor_status.objects.create(
            status ="Denied"
        )
        id_type = visitor_details_models.IdTypes.objects.create(
            type = "Passport" 
        )
        visitor_details = visitor_details_models.VisitorDetails.objects.create(
            first_name = "Ryfiel Sean",
            middle_name = "Viray",
            last_name = "Gonzales",
            contact_number = "09777237273",
            id_type = id_type,
            id_number = "23671986387216",
            status = "Approved"
        )

        models.visitor_logs.objects.create(
            visitor_details = visitor_details,
            check_in=time(9, 0),     
            check_out=time(11, 30),  
            visit_date=date(2025, 5, 21),
            purpose = purpose,
            status = status,
        )
        self.client = APIClient()
    def test_logs(self):
        url = reverse("visitor_logs")

        response = self.client.get(url)
        print(response.content) 