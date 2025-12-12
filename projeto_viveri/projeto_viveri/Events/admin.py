from django.contrib import admin
from .models import Reserva, Local, Eventos, Categoria
admin.site.register(Reserva)
admin.site.register(Local)
admin.site.register(Eventos)
admin.site.register(Categoria)
# Register your models here.