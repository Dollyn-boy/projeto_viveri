from django.urls import path, include
from . import views
from rest_framework.routers import DefaultRouter
app_name="Eventos"

#url específica pro JWT
#registrar TODO viewset no router

router=DefaultRouter()

router.register(r'locais', views.LocalViewSet, basename='local')
router.register(r'eventos', views.EventosViewSet, basename='evento')
router.register(r'categorias', views.CategoriaViewSet, basename='categoria')
router.register(r'reservas', views.ReservaViewSet, basename='reserva')

urlpatterns=[
    path('api/', include(router.urls)),
]