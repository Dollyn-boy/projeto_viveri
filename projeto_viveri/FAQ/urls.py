from django.urls import path, include
from .views import *
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r"pergunta", PerguntaViewSet)
router.register(r"respostas", RespostasViewSet)
router.register(r"votos", VotoViewSet)
router.register(r"denuncias", DenunciaViewSet)
router.register(r"notificacoes", NotificacaoViewSet, basename='notificacao')

urlpatterns = [
    path("listar_perguntas/", listar_perguntas, name="listar_perguntas"),
    path("pergunta/<int:id_p>/", detalhe_pergunta, name="detalhe_pergunta"),
    path("criar_pergunta/", criar_pergunta, name="criar_pergunta"),
    path("pergunta/<int:id_p>/editar/", atualizar_pergunta, name="atualizar_pergunta"),
    path("pergunta/<int:id_p>/deletar/", delete_pergunta, name="delete_pergunta"),
    path("evento/<int:id_e>/perguntas/", perguntas_porEvento, name="perguntas_por_evento"),

    path("api/", include(router.urls)),
]