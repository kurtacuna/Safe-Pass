from django.db import models
import os
from django.utils import timezone
from django.db.models import UniqueConstraint


# Create your models here.
class VisitorDetails(models.Model):
  def custom_upload_to(instance, filename):
      name, ext = os.path.splitext(filename)
      full_name = f"{instance.first_name}{(
        f" {instance.middle_name}" if instance.middle_name else ""
      )} {instance.last_name}"
      return os.path.join('visitor_photos', f'{instance.id_number}{full_name}{ext}')

  class StatusChoices(models.TextChoices):
    APPROVED = "Approved"
    PENDING = "Pending"
    DENIED = "Denied"

  photo = models.ImageField(upload_to=custom_upload_to)
  first_name = models.CharField(max_length=255)
  middle_name = models.CharField(max_length=255, blank=True)
  last_name = models.CharField(max_length=255)
  full_name = models.CharField(max_length=765)
  contact_number = models.CharField(max_length=11)
  id_type = models.ForeignKey('IdTypes', on_delete=models.PROTECT)
  id_number = models.CharField(max_length=255)
  status = models.CharField(max_length=255, choices=StatusChoices, default=StatusChoices.PENDING)
  registration_date = models.DateTimeField(default=timezone.now)

  def save(self, args, **kwargs):
    self.full_name = f"{self.first_name}{(
      f" {self.middle_name}" if self.middle_name else ""
    )} {self.last_name}"

    super().save(args, **kwargs)

  def str(self):
    return self.id

  class Meta:
    verbose_name = "Visitor Detail"
    verbose_name_plural = "Visitor Details"
    constraints = [
      # Ensures no two combinations id_type and id_number are the same
      UniqueConstraint(
        fields=['id_type', 'id_number'],
        name="unique_id_type_and_id_number"
      )
    ]


class IdTypes(models.Model):
  type = models.CharField(max_length=255)

  def __str__(self):
    return self.type

  class Meta:
    verbose_name = "ID Type"
    verbose_name_plural = "ID Types"