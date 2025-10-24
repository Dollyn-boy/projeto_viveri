from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('FAQ/', include('FAQ.urls')),
    path('usuarios/', include('accounts.urls'))
]
