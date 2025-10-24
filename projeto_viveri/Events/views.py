from django.shortcuts import redirect, get_object_or_404
from django.http import JsonResponse
from .models import Local, Eventos, Reserva, Categoria
from datetime import datetime


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
    context = {
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
