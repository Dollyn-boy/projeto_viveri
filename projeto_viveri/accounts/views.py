from rest_framework import viewsets
from .models import Usuario, PessoaFisica, PessoaJuridica, SegurancaModeracao
from .serializers import UsuarioSerializer, PessoaFisicaSerializer, PessoaJuridicaSerializer, SegurancaModeracaoSerializer




class UsuarioViewSet(viewsets.ModelViewSet):
    """
    Permite visualizar, criar, atualizar e deletar instâncias de Usuario.
    Usa o Serializer customizado para tratar o hash da senha.
    """
    queryset = Usuario.objects.all()

    serializer_class = UsuarioSerializer

class PessoaFisicaViewSet(viewsets.ModelViewSet):
    queryset = PessoaFisica.objects.all()

    serializer_class = PessoaFisicaSerializer


class PessoaJuridicaViewSet(viewsets.ModelViewSet):
    queryset = PessoaJuridica.objects.all()

    serializer_class = PessoaJuridicaSerializer

class SegurancaModeracaoViewSet(viewsets.ModelViewSet):
    queryset = SegurancaModeracao.objects.all()

    serializer_class = SegurancaModeracaoSerializer

