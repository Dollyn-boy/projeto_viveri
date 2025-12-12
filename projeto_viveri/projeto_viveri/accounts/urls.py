from django.urls import path

from . import views
from django.urls import path
from .views import SegurancaModeracaoCreateView, SegurancaModeracaoReadView, SegurancaModeracaoUpdateView, SegurancaModeracaoDeleteView


urlpatterns = [
    # Usuário CRUD
    path('', views.usuario_list, name='usuario_list'),
    path('adicionar/', views.adicionar_usuario, name='adicionar_usuario'),
    path('atualizar/<int:user_id>/', views.atualizar_usuario, name='atualizar_usuario'),
    path('deletar/<int:user_id>/', views.deletar_usuario, name='deletar_usuario'),

  
     # URL para listar todas as denúncias
    # path('denuncias/', SegurancaModeracaoListView.as_view(), name='denuncia-lista'),
    # URL para criar uma denúncia
    path('denuncia/criar/', SegurancaModeracaoCreateView.as_view(), name='criar-denuncia'),

    # URL para ver os detalhes de uma denúncia
    path('denuncia/<int:pk>/', SegurancaModeracaoReadView.as_view(), name='detalhe-denuncia'),
    
    # URL para editar uma denúncia. O 'editar/' no final evita conflito com a URL de detalhes.
    path('denuncia/<int:pk>/editar/', SegurancaModeracaoUpdateView.as_view(), name='atualizar-denuncia'),
    
    # URL para deletar uma denúncia
    path('denuncia/<int:pk>/deletar/', SegurancaModeracaoDeleteView.as_view(), name='deletar-denuncia'),
]
