from django.urls import path
from . import views

urlpatterns = [
  path("id_types/", views.IdTypesView.as_view(), name="id-types"),
  path("visitor-registration/", views.VisitorRegistration.as_view(), name="visitor-registration"),
  path("visitors/", views.VisitorsView.as_view(), name="visitors"),
  path("search/", views.VisitorSearchView.as_view(), name="visitor-search"),
]