from django.urls import path
from .views import *

urlpatterns = [
    path('listar_perguntas', listar_perguntas),
    path('detalhe_pergunta', detalhe_pergunta)
]