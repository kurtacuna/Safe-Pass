from django.urls import path
from . import views

urlpatterns = [
  path("id_types/", views.IdTypesView.as_view(), name="id-types"),
  path("visitor-details/", views.VisitorDetailsView.as_view(), name="visitor-details"),
]