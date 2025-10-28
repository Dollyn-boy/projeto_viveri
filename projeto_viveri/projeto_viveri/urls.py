from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('FAQ.urls')),
    path('usuarios/', include('accounts.urls')),
    path('eventos/', include('Events.urls')),
]
