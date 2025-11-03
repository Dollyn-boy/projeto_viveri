from django.shortcuts import render, redirect, get_object_or_404
from .models import *
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework import viewsets
from .serializers import *
from rest_framework.permissions import IsAuthenticated
from .permissions import *



class PerguntaViewSet(viewsets.ModelViewSet):
    queryset = Pergunta.objects.all()
    serializer_class = PeguntaSerializer
    permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]

    def perform_create(self, serializer):
        serializer.save(usuario=self.request.user)


class RespostaViewSet(viewsets.ModelViewSet):
    queryset = Resposta.objects.all()
    serializer_class = RespostaSerializer
    permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]
    
    def perform_create(self, serializer):
        serializer.save(usuario=self.request.user)


"""
def listar_perguntas(request):
    perguntas = Pergunta.objects.all()
    
    dados = list(perguntas.values('id', 'txt', 'data', 'usuario_id', 'evento_id'))

    return JsonResponse(dados, safe=False)


def perguntas_porEvento(request, id_e):
    evento = get_object_or_404(Eventos, id=id_e)
    perguntas = Pergunta.objects.filter(evento=evento)

    dados = list(perguntas.values('id', 'txt', 'data', 'usuario_id', 'evento_id'))
    return JsonResponse(dados, safe=False)

@csrf_exempt
def criar_pergunta(request):
    if request.method == "POST":

        novo_usuario = Usuario.objects.create_user(
            username="joao@gmail.com",
            first_name="João",
            last_name="Silva",
            email="joao@gmail.com",
            password="senha123"
        )
        
            
        novo_evento = Eventos.objects.create(
            nome = "evento teste",
            descricao = "teste",
            data = '2025-12-10',
            link = '',
            #local = ,
            usuario = novo_usuario
        )

        txt = request.POST.get("txt")
        Pergunta.objects.create(txt=txt, usuario = novo_usuario, evento = novo_evento)
        return JsonResponse({"status": "ok", "mensagem": "Pergunta criada com sucesso"})
    
    return JsonResponse({"erro": "Método não permitido"}, status=405)


def detalhe_pergunta(request, id_p):
    pergunta = get_object_or_404(Pergunta, id=id_p)
    respostas = list(Resposta.objects.filter(pergunta=pergunta).values('id', 'txt', 'data', 'usuario_id'))

    dados = {
        "id": pergunta.id,
        "txt": pergunta.txt,
        "data": pergunta.data,
        "usuario_id": pergunta.usuario_id,
        "evento_id": pergunta.evento_id,
        "respostas": respostas
    }
    return JsonResponse(dados)


def delete_pergunta(request, id_p):
    pergunta = get_object_or_404(Pergunta, id=id_p)
    if request.method == "POST":
        pergunta.delete()
        return JsonResponse({"status": "ok", "mensagem": "Pergunta deletada"})
    return JsonResponse({"erro": "Método não permitido"}, status=405)



def atualizar_pergunta(request, id_p):
    pergunta = get_object_or_404(Pergunta, id=id_p)
    if request.method == "POST":
        novo_txt = request.POST.get("txt")
        pergunta.txt = novo_txt
        pergunta.save()
        return JsonResponse({"status": "ok", "mensagem": "Pergunta atualizada com sucesso"})
    return JsonResponse({"erro": "Método não permitido"}, status=405)
"""
