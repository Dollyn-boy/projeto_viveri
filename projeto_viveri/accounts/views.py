from rest_framework import viewsets, status
from .models import Usuario, PessoaFisica, PessoaJuridica, SegurancaModeracao
from .serializers import UsuarioSerializer, PessoaFisicaSerializer, PessoaJuridicaSerializer, SegurancaModeracaoSerializer, LoginSerializer
from rest_framework.permissions import IsAuthenticated,IsAdminUser ,AllowAny
from rest_framework.permissions import BasePermission
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate


class IsSelf(BasePermission):
    """
    Custom permission to only allow a user to edit their own details.
    """
    def has_object_permission(self, request, view, obj):
        #verifica se o usuario é o usuario 👍👍👍👍
        return obj == request.user


class UsuarioViewSet(viewsets.ModelViewSet):
    """
    Permite visualizar, criar, atualizar e deletar instâncias de Usuario.
    Usa o Serializer customizado para tratar o hash da senha.
    """

    permission_classes = [IsAuthenticated]
    
    queryset = Usuario.objects.all()

    serializer_class = UsuarioSerializer
    
    def get_permissions(self):
        if self.action in  ['create','login']:
            permission_classes = [AllowAny]
        elif self.action == 'list':
            
            permission_classes = [IsAdminUser]
        elif self.action in ['retrieve', 'update', 'partial_update', 'destroy']:
            #so usuarios autenticados que são eles mesmos
            permission_classes = [IsAuthenticated , IsSelf]
        else:
            #por enquanto qualquer outra acao é so de admin
            permission_classes = [IsAdminUser]
            
        
        return [permission() for permission in permission_classes]
            
  
    # NOVA ACAO DO VIEWSET : LOGIN ⚠️⚠️⚠️⚠️⚠️⚠️
    @action(detail=False, methods=['post'], permission_classes=[AllowAny])  
    def login(self, request):
        serializer = LoginSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email'] #type: ignore
            password = serializer.validated_data['password'] #type: ignore
            # Autenticar o usuário
            try:
                user_obj = Usuario.objects.get(email=email)
            except Usuario.DoesNotExist: #type: ignore
                
                return Response({'error': 'Credenciais inválidas'}, status=status.HTTP_401_UNAUTHORIZED)
            
            username = user_obj.username
            user = authenticate(username=username, password=password)
            
            if user is not None:
                refresh = RefreshToken.for_user(user)
                return Response({
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                }, status=status.HTTP_200_OK)
            else:
                return Response({'error': 'Credenciais inválidas'}, status=status.HTTP_401_UNAUTHORIZED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



class PessoaFisicaViewSet(viewsets.ModelViewSet):
    
    queryset = PessoaFisica.objects.all()
    
    serializer_class = PessoaFisicaSerializer
    


class PessoaJuridicaViewSet(viewsets.ModelViewSet):
    queryset = PessoaJuridica.objects.all()

    serializer_class = PessoaJuridicaSerializer



class SegurancaModeracaoViewSet(viewsets.ModelViewSet):
    queryset = SegurancaModeracao.objects.all()

    serializer_class = SegurancaModeracaoSerializer

