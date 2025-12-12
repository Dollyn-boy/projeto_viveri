from django.shortcuts import redirect, get_object_or_404
from django.http import JsonResponse
from .models import Local, Eventos, Reserva, Categoria
from datetime import datetime
from . serializers import EventosSerializer, LocalSerializer, CategoriaSerializer, ReservaSerializer
from rest_framework.decorators import api_view, action
from rest_framework.response import Response
from rest_framework import viewsets
#from rest_framework.permissions import IsAuthenticated

#modelviewset é uma abstração do viewset
#fazer tabela de eventos populares
#view de interesse em evento ou reserva: fazer views avuldas ou usar api_view (mais fácil, pode usar routers)


class LocalViewSet(viewsets.ModelViewSet):
    queryset = Local.objects.all()
    serializer_class = LocalSerializer

    @action(detail=True, methods=['get'])
    def confirmar(self, request, pk=None):
        local = self.get_object_or_404(Local, pk=pk)
        serializer = LocalSerializer(local)
        return Response(serializer.data)

    def post(self, request):
        serializer = LocalSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201) #status 201=criado com sucesso
        return Response(serializer.errors, status=400) #status 400=erro do cliente

    def get(self,request):
        locais = Local.objects.all()
        serializer = LocalSerializer(locais, many=True)
        return Response(serializer.data)
    

class EventosViewSet(viewsets.ModelViewSet):
    queryset = Eventos.objects.all()
    serializer_class = EventosSerializer
    '''
    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            return [IsAuthenticated()]
        return []
    '''

    @action(detail=True, methods=['get'])
    def confirmar(self, request, pk=None):
        evento = self.get_object_or_404(Eventos, pk=pk)
        serializer = EventosSerializer(evento)
        return Response(serializer.data)

    def post(self, request):
        serializer = EventosSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201) 
        return Response(serializer.errors, status=400) 
    
    def get_queryset(self): #Data e situação não iniciada
        queryset = Eventos.objects.all()
        data_atual = datetime.now()
        queryset = queryset.filter(data__gte=data_atual)
        queryset = queryset.filter(situação="NÃO INICIADO")
        queryset = queryset.order_by('data')
        return queryset

    def get(self, request):
        eventos = self.get_queryset()
        serializer = EventosSerializer(eventos, many=True)
        return Response(serializer.data)
    
    def get(self,request,pk):
        evento=self.get_object_or_404(Eventos,pk=pk)
        serializer=EventosSerializer(evento)
        return Response(serializer.data)

class CategoriaViewSet(viewsets.ModelViewSet):
    queryset = Categoria.objects.all()
    serializer_class = CategoriaSerializer
    
    @action(detail=True, methods=['get'])
    def confirmar(self, request, pk=None):
        categoria = self.get_object_or_404(Categoria, pk=pk)
        serializer = CategoriaSerializer(categoria)
        return Response(serializer.data)

    def post(self, request):
        serializer = CategoriaSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400) 

    def get(self, request):
        categorias = Categoria.objects.all()
        serializer = CategoriaSerializer(categorias, many=True)
        return Response(serializer.data)
    
    def get(self,request,pk):
        categoria=self.get_object_or_404(Categoria,pk=pk)
        serializer=CategoriaSerializer(categoria)
        return Response(serializer.data)

class ReservaViewSet(viewsets.ModelViewSet):
    queryset = Reserva.objects.all()
    serializer_class = ReservaSerializer

    @action(detail=True, methods=['get'])
    def confirmar(self, request, pk=None):
        reserva = self.get_object_or_404(Reserva, pk=pk)
        serializer = ReservaSerializer(reserva)
        return Response(serializer.data)

    def post(self, request):
        serializer = ReservaSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201) 
        return Response(serializer.errors, status=400) 
    
    def get(self, request):
        reservas = Reserva.objects.all()
        serializer = ReservaSerializer(reservas, many=True)
        return Response(serializer.data)
