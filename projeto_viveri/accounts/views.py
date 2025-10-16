from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, JsonResponse

from django.views.generic.edit import CreateView, UpdateView, DeleteView, DetailView
from django.urls import reverse_lazy
from .models import SegurancaModeracao
from .models import Usuario

# ---------------------------
# CRUD Usuário
# ---------------------------

# CREATE - Adicionar um novo usuário
def adicionar_usuario(request):
    novo_usuario = Usuario.objects.create_user(
        username="joao@gmail.com",
        first_name="João",
        last_name="Silva",
        email="joao@gmail.com",
        password="senha123"
    )
    return HttpResponse(f"Usuário '{novo_usuario.get_full_name()}' criado com sucesso!")

# READ - Listar todos os usuários
def usuario_list(request):
    usuarios = Usuario.objects.all()
    data = list(usuarios.values('id', 'first_name', 'last_name', 'email'))
    return JsonResponse(data, safe=False)

# UPDATE - Atualizar o nome de um usuário
def atualizar_usuario(request, user_id):
    usuario = get_object_or_404(Usuario, id=user_id)
    novo_nome = "João Atualizado"
    usuario.first_name = novo_nome
    usuario.save()
    return HttpResponse(f"Usuário ID {usuario.id} atualizado para '{usuario.first_name}'.")

# DELETE - Deletar um usuário
def deletar_usuario(request, user_id):
    usuario = get_object_or_404(Usuario, id=user_id)
    nome_usuario = usuario.get_full_name()
    usuario.delete()
    return HttpResponse(f"Usuário '{nome_usuario}' deletado com sucesso!")

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

