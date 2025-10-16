from django.urls import path

from . import views
from .views import (
    SegurancaModeracaoCreateView,
    SegurancaModeracaoReadView,
    SegurancaModeracaoUpdateView,
    SegurancaModeracaoDeleteView,
    SegurancaModeracaoListView,
)

urlpatterns = [
    # Usuário CRUD
    path('', views.usuario_list, name='usuario_list'),
    path('adicionar/', views.adicionar_usuario, name='adicionar_usuario'),
    path('atualizar/<int:user_id>/', views.atualizar_usuario, name='atualizar_usuario'),
    path('deletar/<int:user_id>/', views.deletar_usuario, name='deletar_usuario'),

    # Segurança e Moderação
    path('denuncias/', SegurancaModeracaoListView.as_view(), name='denuncia-lista'),
    path('denuncia/criar/', SegurancaModeracaoCreateView.as_view(), name='criar-denuncia'),
    path('denuncia/<int:pk>/', SegurancaModeracaoReadView.as_view(), name='detalhe-denuncia'),
    path('denuncia/<int:pk>/editar/', SegurancaModeracaoUpdateView.as_view(), name='atualizar-denuncia'),
    path('denuncia/<int:pk>/deletar/', SegurancaModeracaoDeleteView.as_view(), name='deletar-denuncia'),
]
