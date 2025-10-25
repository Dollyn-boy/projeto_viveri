from django.shortcuts import render, redirect, get_object_or_404
from .models import *
# Create your views here.
"""
listar_produtos(request) X
detalhe_produto(request) X
criar_produto(request) 
atualizar_produto(request) 
delete_produto(request) X
"""

def listar_perguntas(request):
    perguntas = Pergunta.objects.all()
    
    return render(request, "listar_perguntas.html", {"perguntas": perguntas})


def perguntas_porEvento(request, id_e):
    evento = get_object_or_404(Eventos, id=id_e)
    perguntas = Pergunta.objects.filter(evento=evento)
    contexto = {
        "perguntas": perguntas,
        "evento": evento 

        }
    return render(request, "perguntas_por_evento.html", contexto)


def criar_pergunta(request):
    if request.method == "POST":
        txt = request.POST.get("txt")
        Pergunta.objects.create(txt=txt)
        return redirect("listar_perguntas")

    return render(request, "criar_pergunta.html")


def detalhe_pergunta(request, id_p):
    pergunta = get_object_or_404(Pergunta, id=id_p)
    respostas = Resposta.objects.filter(pergunta=pergunta)

    contexto = {
        "pergunta": pergunta,
        "respostas": respostas
    }

    return render(request, "detalhe_pergunta.html", contexto)


def delete_pergunta(request, id_p):
    pergunta = get_object_or_404(Pergunta, id=id_p)

    if request.method == "POST":
        pergunta.delete()
        return redirect("listar_perguntas")

    return render(request, "confirmar_delete.html", {"pergunta": pergunta})

def atualizar_pergunta(request, id_p):
    pergunta = get_object_or_404(Pergunta, id=id_p)

    if request.method == "POST":
        novo_txt = request.POST.get("txt")
        pergunta.txt = novo_txt
        pergunta.save() 
        return redirect("listar_perguntas")

    return render(request, "editar_pergunta.html", {"pergunta": pergunta})







