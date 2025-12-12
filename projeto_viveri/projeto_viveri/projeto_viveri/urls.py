from django.contrib import admin
from django.urls import path, include
from rest_framework import routers

#router=DefaultRouter()


urlpatterns = [
    path('admin/', admin.site.urls),
    path('FAQ/', include('FAQ.urls')),
    path('usuarios/', include('accounts.urls')),
    path('Events/', include('Events.urls')),
]
