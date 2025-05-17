from django.db import models

# Create your models here.
class VisitorDetails(models.Model):
  first_name = models.CharField(max_length=255)
  middle_name = models.CharField(max_length=255, blank=True)
  last_name = models.CharField(max_length=255)
  id_type = models.ForeignKey('IdTypes', on_delete=models.PROTECT)
  id_number = models.CharField(max_length=255)
  contact_number = models.CharField(max_length=11)

  def __str__(self):
    return self.id

  class Meta:
    verbose_name = "Visitor Detail"
    verbose_name_plural = "Visitor Details"


class IdTypes(models.Model):
  type = models.CharField(max_length=255)

  def __str__(self):
    return self.type

  class Meta:
    verbose_name = "ID Type"
    verbose_name_plural = "ID Types"


class VisitPurposes(models.Model):
  purpose = models.CharField(max_length=255)

  def __str__(self):
    return self.purpose

  class Meta:
    verbose_name = "Visit Purpose"
    verbose_name_plural = "Visitor Purposes"