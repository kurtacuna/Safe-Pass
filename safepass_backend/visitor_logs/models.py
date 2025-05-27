from django.db import models
from visitor_details import models as visitor_details_model

class visitor_logs(models.Model):
    log_datetime = models.DateTimeField(auto_now=True)
    visitor_details = models.ForeignKey(visitor_details_model.VisitorDetails,on_delete=models.PROTECT)
    check_in = models.TimeField()
    check_out = models.TimeField(blank = True, null = True)
    visit_date = models.DateField()
    purpose = models.ForeignKey('VisitPurposes', on_delete=models.PROTECT)
    status = models.ForeignKey('visitor_status', on_delete=models.PROTECT)
    
    
    class Meta:
        verbose_name = "Visitor Log"
        verbose_name_plural = "Visitor Logs"




class visitor_status(models.Model):
    status = models.CharField(max_length=255)

    def __str__(self):
      return self.status

    class Meta:
        verbose_name = "Status"
        verbose_name_plural = "Statuses"


class VisitPurposes(models.Model):
  purpose = models.CharField(max_length=255)

  def __str__(self):
    return self.purpose

  class Meta:
    verbose_name = "Visit Purpose"
    verbose_name_plural = "Visitor Purposes"
    
