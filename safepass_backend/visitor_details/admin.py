from django.contrib import admin
from . import models

class VisitorDetailsAdmin(admin.ModelAdmin):
    list_display = ('get_full_name',)
    search_fields = ('full_name', 'first_name', 'last_name')

    def get_full_name(self, obj):
        return obj.full_name
    get_full_name.short_description = 'Visitor Details'  # Column header name

# Register your models here.
admin.site.register(models.IdTypes)
admin.site.register(models.VisitorDetails, VisitorDetailsAdmin)
