from rest_framework.response import Response
from rest_framework import status
from .models import Local, Eventos, Reserva, Categoria
from datetime import datetime
from .serializer import EventosSerializer, LocalSerializer, CategoriaSerializer, ReservaSerializer
from rest_framework.response import Response
from rest_framework import viewsets
from rest_framework.permissions import BasePermission, IsAuthenticated
from django.core.exceptions import ValidationError

class IsPessoaJuridica(BasePermission):
    """
    Permite acesso apenas a usuários PJ com documentação verificada
    """
    def has_permission(self, request, view):
        return bool(
            request.user and 
            request.user.is_authenticated and 
            request.user.flag_userPJ and
            hasattr(request.user, 'pessoa_juridica') and
            request.user.pessoa_juridica.documentacao_verificada
        )

class IsPessoaFisica(BasePermission):
    """
    Permite acesso apenas a usuários PF
    """
    def has_permission(self, request, view):
        return bool(
            request.user and 
            request.user.is_authenticated and 
            hasattr(request.user, 'pessoa_fisica') and
            request.user.flag_userPF
        )

class LocalViewSet(viewsets.ModelViewSet):
    queryset = Local.objects.all()
    serializer_class = LocalSerializer

    def get_permissions(self):
        if self.action == ['create']:
            # Apenas PJ verificada pode criar eventos
            return [IsPessoaJuridica()]
        elif self.action in ['update', 'partial_update']:
            # PF pode atualizar seus eventos e PJ verificada pode atualizar seus eventos
            return [IsPessoaFisica() | IsPessoaJuridica()]
        elif self.action == 'destroy':
            # Apenas PJ verificada pode deletar eventos
            return [IsPessoaJuridica()]
        elif self.action == ['list', 'view']:
            return [IsAuthenticated()]
        return []


class EventosViewSet(viewsets.ModelViewSet):
    queryset = Eventos.objects.all()
    serializer_class = EventosSerializer

    def get_permissions(self):
        if self.action == ['create']:
            # Apenas PJ verificada pode criar eventos
            return [IsPessoaJuridica()]
        elif self.action in ['update', 'partial_update']:
            # PF pode atualizar seus eventos e PJ verificada pode atualizar seus eventos
            return [IsPessoaFisica() | IsPessoaJuridica()]
        elif self.action == 'destroy':
            # Apenas PJ verificada pode deletar eventos
            return [IsPessoaJuridica()]
        elif self.action == ['list', 'view']:
            return [IsAuthenticated()]

        return []
    
    def perform_create(self, serializer):
        # Salva o usuário atual como criador do evento
        serializer.save(usuario=self.request.user)
    
    def get_queryset(self):
        """
        Se for update/delete, filtra apenas eventos do usuário atual
        """
        queryset = super().get_queryset()
        if self.action in ['update', 'partial_update', 'destroy']:
            return queryset.filter(usuario=self.request.user)
        return queryset
    

class CategoriaViewSet(viewsets.ModelViewSet):
    queryset = Categoria.objects.all()
    serializer_class = CategoriaSerializer

    def get_permissions(self):
        if self.action == ['create']:
            # Apenas PJ verificada pode criar eventos
            return [IsPessoaJuridica()]
        elif self.action in ['update']:
            # PF pode atualizar seus eventos e PJ verificada pode atualizar seus eventos
            return [IsPessoaFisica() | IsPessoaJuridica()]
        elif self.action == ['destroy']:
            # Apenas PJ verificada pode deletar eventos
            return [IsPessoaJuridica()]
        # Listar e visualizar são públicos
        elif self.action == ['list', 'view']:
            return [IsAuthenticated()]
        
        return []

class ReservaViewSet(viewsets.ModelViewSet):
    queryset = Reserva.objects.all()
    serializer_class = ReservaSerializer

    def get_permissions(self):
        if self.action == ['create']:
            # Apenas PJ verificada pode criar eventos
            return [IsPessoaJuridica() | IsPessoaFisica()]
            '''
        elif self.action in ['update', 'partial_update']:
            # PF pode atualizar seus eventos e PJ verificada pode atualizar seus eventos
            return [IsPessoaFisica() | IsPessoaJuridica()]
            '''        
        elif self.action == 'destroy':
            # Apenas PJ verificada pode deletar eventos
            return [IsPessoaJuridica() | IsPessoaFisica()]
        
        elif self.action == ['list', 'view']:
            return [IsAuthenticated()]

        return []

from rest_framework.response import Response
from rest_framework.decorators import api_view
from math import radians, cos, sin, asin, sqrt
from .models import Evento

def distancia_km(lat1, lon1, lat2, lon2):
    # Haversine
    R = 6371
    dlat = radians(lat2 - lat1)
    dlon = radians(lon2 - lon1)
    a = sin(dlat/2)**2 + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a))
    return R * c

@api_view(['GET'])
def eventos_proximos(request):
    lat = float(request.GET.get('lat'))
    lng = float(request.GET.get('lng'))
    dist_max = float(request.GET.get('dist', 5))
    
    eventos = Evento.objects.all()
    proximos = []

    for ev in eventos:
        d = distancia_km(lat, lng, ev.latitude, ev.longitude)
        if d <= dist_max:
            proximos.append({
                "id": ev.id,
                "nome": ev.nome,
                "descricao": ev.descricao,
                "data": ev.data,
                "latitude": ev.latitude,
                "longitude": ev.longitude,
                "distancia": round(d, 2),
            })

    return Response(proximos)