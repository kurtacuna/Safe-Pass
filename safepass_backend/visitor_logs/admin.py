from django.contrib import admin
from . import models

# Register your models here.
admin.site.register(models.visitor_logs)
admin.site.register(models.visitor_status)
admin.site.register(models.VisitPurposes)