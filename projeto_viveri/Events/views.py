from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Local, Eventos, Reserva, Categoria
from datetime import datetime
from .serializer import EventosSerializer, LocalSerializer, CategoriaSerializer, ReservaSerializer
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import viewsets
#from rest_framework.permissions import IsAuthenticated

#modelviewset é uma abstração do viewset
#fazer tabela de eventos populares
#view de interesse em evento ou reserva: fazer views avuldas ou usar api_view (mais fácil, pode usar routers)


class LocalViewSet(viewsets.ModelViewSet):
    queryset = Local.objects.all()
    serializer_class = LocalSerializer

class EventosViewSet(viewsets.ModelViewSet):
    queryset = Eventos.objects.all()
    serializer_class = EventosSerializer
    '''
    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsAuthenticated()]
        return []
    '''

class CategoriaViewSet(viewsets.ModelViewSet):
    queryset = Categoria.objects.all()
    serializer_class = CategoriaSerializer

class ReservaViewSet(viewsets.ModelViewSet):
    queryset = Reserva.objects.all()
    serializer_class = ReservaSerializer
