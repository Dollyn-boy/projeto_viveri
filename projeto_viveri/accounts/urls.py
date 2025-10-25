from django.urls import include
from rest_framework.routers import DefaultRouter
from .views import (
    UsuarioViewSet,
    PessoaFisicaViewSet,
    PessoaJuridicaViewSet, 
    SegurancaModeracaoViewSet
)


router = DefaultRouter() 

#Registro dos ViewSets
router.register('usuarios', UsuarioViewSet)
router.register('pessoas-fisicas', PessoaFisicaViewSet)
router.register('pessoas-juridicas', PessoaJuridicaViewSet) 
router.register('moderacao', SegurancaModeracaoViewSet) 

#Mapeamento
urlpatterns = [
   # Inclui todas as rotas geradas pelo router
   path('', include(router.urls)), 
]