from django.contrib import admin
from .models import Usuario, PessoaFisica, PessoaJuridica, SegurancaModeracao
admin.site.register(Usuario)
admin.site.register(PessoaFisica)
admin.site.register(PessoaJuridica)
admin.site.register(SegurancaModeracao)