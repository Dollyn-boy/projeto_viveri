from django.urls import path,include
from rest_framework.routers import DefaultRouter
from .views import (
    ForgotPasswordAPIView,
    UsuarioViewSet,
    PessoaFisicaViewSet,
    PessoaJuridicaViewSet, 
    SegurancaModeracaoViewSet,
    VerifyCodeAPIView
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
   path('', include(router.urls)),  # suas rotas automáticas do router
    path('auth/forgot-password/', ForgotPasswordAPIView.as_view(), name='forgot_password'),
    path('auth/verify-code/', VerifyCodeAPIView.as_view(), name='verify_code'),
]