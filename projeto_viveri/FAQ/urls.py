from django.urls import path, include
from .views import *
from rest_framework.routers import DefaultRouter


app_name = 'FAQ'
router = DefaultRouter()
router.register(r'pergunta', PerguntaViewSet) # Registra o ViewSet no router
router.register(r'resposta', RespostaViewSet)
router.register(r'denuncia', DenunciaViewSet)
router.register(r'notificacao', NotificacaoViewSet, basename="notificacao")

urlpatterns = [
    path('pergunta/<int:pergunta_id>/votar/', votar, name='votar'),
    path('', include(router.urls)), # Inclui todas as rotas geradas automaticamente
]