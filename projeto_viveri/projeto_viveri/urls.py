from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import (
 TokenObtainPairView,
 TokenRefreshView,
)



urlpatterns = [
    path('admin/', admin.site.urls),
    path('usuarios/', include('accounts.urls')),

    path('api/FAQ/', include('FAQ.urls', namespace='FAQ')),

    path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh')

]

