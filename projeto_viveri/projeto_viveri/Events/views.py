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


def listar_locais(request):
    locais = list(Local.objects.values())
    return JsonResponse({'locais': locais})


def endereco_local(request, id):
    try:
        enderecoLocal = Local.objects.get(id=id)
        data = {'endereco': enderecoLocal.endereco}
        return JsonResponse(data)
    except Local.DoesNotExist:
        return JsonResponse({'error': 'Local não encontrado'}, status=404)


def descricao_evento(request):
    descricao = list(Eventos.objects.values())
    return JsonResponse({'descricao': descricao})


def criar_evento(request):
    if request.method != 'POST':
        return JsonResponse({'erro': 'Método inválido, use POST'}, status=405)

    nome = request.POST.get('nome')
    descricao = request.POST.get('descricao')
    data_str = request.POST.get('data')
    link = request.POST.get('link')
    local_id = request.POST.get('local_id')
    usuario_id = request.POST.get('usuario_id')

    if not (nome and data_str and local_id):
        return JsonResponse({'erro': 'Campos obrigatórios ausentes'}, status=400)

    # ajustar conforme o formato da sua data, ex: 'YYYY-MM-DD'
    try:
        data = datetime.fromisoformat(data_str)
    except Exception:
        return JsonResponse({'erro': 'Formato de data inválido'}, status=400)

    try:
        # use 'id' ou 'id_local' conforme seu model
        local = get_object_or_404(Local, id=local_id)
        evento = Eventos.objects.create(
            nome=nome,
            descricao=descricao,
            data=data,
            link=link,
            local=local,
            usuario_id=usuario_id  # válido se o campo no model for ForeignKey chamado usuario
        )
    except Exception as e:
        return JsonResponse({'erro': 'Falha ao criar evento', 'detalhe': str(e)}, status=500)

    return JsonResponse({'mensagem': 'Evento criado com sucesso', 'id_evento': getattr(evento, 'id_evento', evento.pk)}, status=201)


def detalhe_evento(request, id_evento):
    evento = get_object_or_404(Eventos, id_evento=id_evento)
    
    foto_organizador_url  = foto_url = ""
    if evento.foto:
        foto_url = request.build_absolute_uri(evento.foto.url)
    
    lista_tags = [] #Exemplo: "Festa, Verão" vira ["Festa", "Verão"]
    if evento.tags:
        lista_tags = [t.strip() for t in evento.tags.split(',')]
        
    if hasattr(evento.usuario, 'foto') and evento.usuario.foto:
        foto_organizador_url = request.build_absolute_uri(evento.usuario.foto.url)
    
    nome_organizador = evento.usuario.get_full_name()
    if not nome_organizador:
        nome_organizador = evento.usuario.username
        
    quantidade_compras = Reserva.objects.filter(evento=evento).count()    
    
    context = {
        'evento': {
            'id': evento.id_evento,
            'nome': evento.nome,
            'descricao': evento.descricao,
            'data': evento.data,
            'link': evento.link,
            'faixa_etaria': evento.faixa_etaria,
            'foto': foto_url,
            'tags': lista_tags,
            'total_ingressos_vendidos': quantidade_compras,
            'tipo': evento.tipo,
        },
        'local': {
            'id': evento.local.pk,
            'nome': evento.local.nome,
            'latitude': evento.local.latitude, 
            'longitude': evento.local.longitude,
        },
        'usuario': {
            'id': evento.usuario.id,
            'nome': nome_organizador,
            'foto': foto_organizador_url
        }
    }
    return JsonResponse(context)

def listar_eventos(request):
    eventos = list(Eventos.objects.values())
    return JsonResponse({'eventos': eventos})


def listarCategorias(request):
    categorias = list(Categoria.objects.values())
    return JsonResponse({'categorias': categorias})


def criarCategoria(request):
    if request.method == 'POST':
        nome = request.POST.get('nome')
        categoria = Categoria.objects.create(nome=nome)
        return JsonResponse({'mensagem': 'Categoria criada com sucesso', 'id_categoria': categoria.id})
    return JsonResponse({'erro': 'Método inválido, use POST'}, status=405)


def listarReservas(request):
    reservas = list(Reserva.objects.values())
    return JsonResponse({'reservas': reservas})


def detalheReserva(request, id_reserva):
    reserva = get_object_or_404(Reserva, id_reserva=id_reserva)
    context = {
        'reserva': {
            'id': reserva.id_reserva,
            'data': reserva.data_reserva
        },
        'evento': {
            'id': reserva.evento.id_evento,
            'nome': reserva.evento.nome
        },
        'local': {
            'id': reserva.evento.local.id,
            'nome': reserva.evento.local.nome
        }
    }
    return JsonResponse(context)