from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Local, Eventos, Reserva, Categoria
from datetime import datetime


@api_view(['GET'])
def listar_locais(request):
    locais = list(Local.objects.values())
    return Response({'locais': locais})


@api_view(['GET'])
def endereco_local(request, id):
    try:
        local = Local.objects.get(id=id)
        return Response({'endereco': local.endereco})
    
    except Local.DoesNotExist:
        return Response({'erro': 'Local não encontrado'}, status=status.HTTP_404_NOT_FOUND)
    

@api_view(['GET'])
def descricao_evento(request):
    descricao = list(Eventos.objects.values())
    return Response({'descricao': descricao})


@api_view(['POST'])
def criar_evento(request):
    nome = request.data.get('nome')
    descricao = request.data.get('descricao')
    data_str = request.data.get('data')
    link = request.data.get('link')
    id_local = request.data.get('id_local')
    id_usuario = request.data.get('id_usuario')

    if not (nome and data_str and id_local):
        return Response({'erro': 'Campos obrigatórios ausentes'}, status=status.HTTP_400_BAD_REQUEST)

    # datra
    try:
        data = datetime.fromisoformat(data_str)
    except Exception:
        return Response({'erro': 'Formato de data inválido'}, status=status.HTTP_400_BAD_REQUEST)

    # local
    try:
        local = Local.objects.get(id=id_local)
    except Local.DoesNotExist:
        return Response({'erro': 'Local não encontrado'}, status=status.HTTP_404_NOT_FOUND)

    evento = Eventos.objects.create(
        nome=nome,
        descricao=descricao,
        data=data,
        link=link,
        local=local,
        usuario_id=id_usuario,
    )

    return Response(
        {'mensagem': 'Evento criado com sucesso', 'id_evento': evento.pk},
        status=status.HTTP_201_CREATED
    )


@api_view(['GET'])
def detalhe_evento(request, id_evento):
    try:
        evento = Eventos.objects.get(id_evento=id_evento)
    except Eventos.DoesNotExist:
        return Response({'erro': 'Evento não encontrado'}, status=status.HTTP_404_NOT_FOUND)

    return Response({
        'evento': {
            'id': evento.id_evento,
            'nome': evento.nome,
            'descricao': evento.descricao,
            'data': evento.data,
            'link': evento.link
        },
        'local': {
            'id': evento.local.id,
            'nome': evento.local.nome
        },
        'usuario': evento.usuario_id
    })


@api_view(['GET'])
def listar_eventos(request):
    eventos = list(Eventos.objects.values())
    return Response({'eventos': eventos})


@api_view(['GET'])
def listarCategorias(request):
    categorias = list(Categoria.objects.values())
    return Response({'categorias': categorias})


@api_view(['POST'])
def criarCategoria(request):
    nome = request.data.get('nome')
    if not nome:
        return Response({'erro': 'Nome é obrigatório'}, status=status.HTTP_400_BAD_REQUEST)

    categoria = Categoria.objects.create(nome=nome)

    return Response({'mensagem': 'Categoria criada com sucesso', 'id_categoria': categoria.id})


@api_view(['GET'])
def listarReservas(request):
    reservas = list(Reserva.objects.values())
    return Response({'reservas': reservas})


@api_view(['GET'])
def detalheReserva(request, id_reserva):
    try:
        reserva = Reserva.objects.get(id_reserva=id_reserva)
    except Reserva.DoesNotExist:
        return Response({'erro': 'Reserva não encontrada'}, status=status.HTTP_404_NOT_FOUND)

    return Response({
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
    })