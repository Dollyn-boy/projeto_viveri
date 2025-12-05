import json
from django.shortcuts import render, redirect, get_object_or_404
from .models import *
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from rest_framework import viewsets
from .serializers import *
from rest_framework.permissions import IsAuthenticated
from .permissions import *
from rest_framework.authentication import TokenAuthentication
from rest_framework.decorators import api_view, authentication_classes, permission_classes, action


class PerguntaViewSet(viewsets.ModelViewSet):
    queryset = Pergunta.objects.all()
    serializer_class = PerguntaSerializer
    permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]

    def get_queryset(self):
        queryset = Pergunta.objects.all()
        evento_id = self.request.query_params.get('evento', None)
        
        if evento_id is not None:
            queryset = queryset.filter(evento_id=evento_id)
        
        return queryset

    def perform_create(self, serializer):
        serializer.save(usuario=self.request.user)


class RespostaViewSet(viewsets.ModelViewSet):
    queryset = Resposta.objects.all()
    serializer_class = RespostaSerializer
    permission_classes = [IsAuthenticated, IsOwnerOrReadOnly]

    def get_queryset(self):
        queryset = Resposta.objects.all()
        pergunta_id = self.request.query_params.get('pergunta', None)
        
        if pergunta_id is not None:
            queryset = queryset.filter(pergunta_id=pergunta_id)
        
        return queryset
    
    def perform_create(self, serializer):
        # 1. Salva a resposta e associa ao autor (request.user)
        resposta = serializer.save(usuario=self.request.user)
        
        # --- LÓGICA DE NOTIFICAÇÃO COMEÇA AQUI ---
        
        # 2. Pega a pergunta que foi respondida
        pergunta = resposta.pergunta
        
        # 3. Pega o autor da pergunta (quem VAI RECEBER a notificação)
        autor_da_pergunta = pergunta.usuario
        
        evento_pergunta = pergunta.evento

        # 4. A "Inteligência": Não notificar o usuário se ele respondeu a própria pergunta
        #if autor_da_pergunta != self.request.user:
            
        # 5. Cria a notificação
        Notificacao.objects.create(
            usuario=autor_da_pergunta,
            evento=evento_pergunta,
            conteudo=f"Sua pergunta foi respondida por {self.request.user}.",
            pergunta=pergunta
            # (Aqui você colocaria o link para a pergunta/resposta)
            # link=f"/perguntas/{pergunta.id}/" 
        )
            

# Em seu_app/views.py
from .models import Notificacao # Importe seu modelo

class NotificacaoViewSet(viewsets.ReadOnlyModelViewSet):
    """
    API para listar as notificações do usuário.
    """
    serializer_class = NotificacaoSerializer
    permission_classes = [IsAuthenticated] # Certifique-se de importar IsAuthenticated

    def get_queryset(self):
        usuario_logado = self.request.user
        return Notificacao.objects.filter(usuario=usuario_logado)

class DenunciaViewSet(viewsets.ModelViewSet):
    queryset = Denuncia.objects.all()
    serializer_class = DenunciaSerializer
    permission_classes = [IsAuthenticated]
    
    def perform_create(self, serializer):
        serializer.save(usuario=self.request.user)



@api_view(['POST', 'DELETE'])  # Aceita POST e DELETE
@permission_classes([IsAuthenticated])
def votar(request, pergunta_id):
    pergunta = get_object_or_404(Pergunta, id=pergunta_id)
    usuario = request.user
    
    # DELETE = Remover voto
    if request.method == "DELETE":
        Voto.objects.filter(usuario=usuario, pergunta=pergunta).delete()
        return JsonResponse({"mensagem": "Voto removido!"})
    
    # POST = Votar
    try:
        data = json.loads(request.body)
        tipo = data.get("tipo")
    except json.JSONDecodeError:
        return JsonResponse({"erro": "JSON inválido"}, status=400)

    # Validação
    if tipo not in [TipoVoto.UP, TipoVoto.DOWN]:
        return JsonResponse({"erro": "Tipo de voto inválido"}, status=400)

    voto, criado = Voto.objects.get_or_create(
        usuario=usuario,
        pergunta=pergunta,
        defaults={'tipo': tipo}
    )

    if not criado:
        if voto.tipo == tipo:
            # Mesmo voto = remover (toggle)
            voto.delete()
            mensagem = "Voto removido!"
        else:
            # Voto diferente = alterar
            voto.tipo = tipo
            voto.save(update_fields=['tipo'])
            mensagem = "Voto atualizado!"
    else:
        mensagem = "Voto registrado!"

    return JsonResponse({"mensagem": mensagem})