from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, JsonResponse

from django.views.generic import CreateView, UpdateView, DeleteView, DetailView
from django.urls import reverse_lazy
from .models import SegurancaModeracao
from .models import Usuario
from django.contrib.auth.hashers import make_password #hash
from django.views.decorators.csrf import csrf_exempt #pro django n reclamar
from django.db import IntegrityError
import json

# ---------------------------
# CRUD Usuário
# ---------------------------

# CREATE - Adicionar um novo usuário

@csrf_exempt
def adicionar_usuario(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            return JsonResponse({"error": "corpo da requisição invalido (JSON mal formatado)"}, status=400)
     
        try:
            novo_usuario = Usuario.objects.create_user(
                username=data.get("username"),
                first_name=data.get('first_name'),
                last_name=data.get('last_name'),
                email=data.get('email'),
                password=data.get("password")
            )
            
            return JsonResponse({
                "message": f"Usuário '{novo_usuario.get_full_name()}' criado com sucesso!"
            }, status=201) 

        except IntegrityError:
            
            return JsonResponse({"error": "usuario ja existe"}, status=400)
        except Exception as e:
            
            return JsonResponse({"error": f"ocorreu esse erro ao criar usuário -> {str(e)}"}, status=500)
            
    else:
        return JsonResponse({"error": "requisicao invalida tem q ser POST"}, status=405)
    #exemplo de body
    '''
    {
        "username": "tulio_zinga666",
        "email": "tulio@zinga.com.br",
        "password": "senha1234",
        "first_name": "tulio",
        "last_name": "zinga"
    }
    '''

# READ - Listar todos os usuários
def usuario_list(request):
    usuarios = Usuario.objects.all()
    data = list(usuarios.values('id', 'first_name', 'last_name', 'email'))
    return JsonResponse(data, safe=False)



@csrf_exempt
def atualizar_usuario(request,user_id):
    if request.method == 'PATCH':
        try:
            data = json.loads(request.body)
        except json.JSONDecodeError:
            
            return JsonResponse({"error": "corpo da requisição invalido (JSON mal formatado)"}, status=400)
     
        try:
            usuario = get_object_or_404(Usuario, id=user_id)
            
            if(data.get("username")):
                usuario.username = data.get("username")
            if(data.get("email")):
                usuario.email = data.get("email")
            if(data.get("first_name")):
                usuario.first_name = data.get("first_name")
            if(data.get("last_name")):
                usuario.last_name = data.get("last_name")
                
            usuario.save()
                

            return JsonResponse({
                "message": f"Usuário ID {usuario.id} atualizado com sucesso."
            }, status=201) 
            

        except IntegrityError:
            
            return JsonResponse({"error": "algum usuario ja possui esses dados"}, status=400)
        except Exception as e:
            
            return JsonResponse({"error": f"ocorreu esse erro ao alterar usuário -> {str(e)}"}, status=500)
            
    else:
        return JsonResponse({"error": "requisicao invalida tem q ser PATCH"}, status=405)
    #exemplo de body
    '''
    {
        "username": "tulio_zinga666",
        "email": "tulio@zinga.com.br",
        "password": "senha1234",
        "first_name": "tulio",
        "last_name": "zinga"
    }
    '''

# DELETE - Deletar um usuário
@csrf_exempt
def deletar_usuario(request, user_id):
    if request.method == "DELETE":
        usuario = Usuario.objects.filter(pk=user_id).first()
        if usuario is None:
            return JsonResponse({"error": "Usuário não encontrado"}, status=404)
        nome_usuario = usuario.get_full_name()
        usuario.delete()
        return JsonResponse({"message": f"Usuário {nome_usuario} deletado com sucesso"})
    return JsonResponse({"error": "Requisição inválida"}, status=405)


def detalhar_usuario(request, user_id):
    if request.method == 'GET':
        try:
            usuario = get_object_or_404(Usuario, id=user_id)
            data = {
                'id': usuario.id,
                'username': usuario.username,
                'email': usuario.email,
                'first_name': usuario.first_name,
                'last_name': usuario.last_name,
                'status_conta': usuario.status_conta,
                'flag_userPF': usuario.flag_userPF,
                'flag_userPJ': usuario.flag_userPJ,
            }
            return JsonResponse(data, status=200)
        except Usuario.DoesNotExist: # This case is handled by get_object_or_404, but explicit check is fine
             return JsonResponse({"error": "Usuário não encontrado"}, status=404)
        except Exception as e:
            return JsonResponse({"error": f"Ocorreu um erro: {str(e)}"}, status=500)
    else:
        return JsonResponse({"error": "Requisição inválida, deve ser GET"}, status=405)


# ---------------------------
# Segurança e Moderação
# ---------------------------

# create
class SegurancaModeracaoCreateView(CreateView):
    model = SegurancaModeracao
    fields = ['usuario_denunciado', 'tipo_denuncia','descricao']

    
    def form_valid(self, form):
        form.instance.usuario_denunciante = self.request.user
        return super().form_valid(form)
    
    #  Retorna a URL de detalhe com o PK do objeto recÃ©m-criado
    def get_success_url(self):
        return reverse_lazy('detalhe-denuncia', kwargs={'pk': self.object.pk})
    
# read
class SegurancaModeracaoReadView(DetailView):
    model = SegurancaModeracao
    context_object_name = 'denuncia'
    
# update
class SegurancaModeracaoUpdateView(UpdateView):
    model = SegurancaModeracao
    fields = ['usuario_denunciado', 'tipo_denuncia', 'descricao', 'status_denuncia']


   # Retorna a URL de detalhe com o PK do objeto atualizado
    def get_success_url(self):
        return reverse_lazy('detalhe-denuncia', kwargs={'pk': self.object.pk})
# delete
class SegurancaModeracaoDeleteView(DeleteView): 
    model = SegurancaModeracao
    success_url = reverse_lazy('denuncia-lista') 

