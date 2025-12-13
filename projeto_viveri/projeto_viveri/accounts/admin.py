from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import Usuario, PessoaFisica, PessoaJuridica, SegurancaModeracao

class CustomUserAdmin(UserAdmin):
    model = Usuario
    
    fieldsets = UserAdmin.fieldsets + (
        ('Informações Extras', {
            'fields': ('foto', 'status_conta', 'flag_userPF', 'flag_userPJ')
        }),
    )
    
    add_fieldsets = UserAdmin.add_fieldsets + (
        (None, {
            'fields': ('email', 'foto', 'flag_userPF', 'flag_userPJ')
        }),
    )

admin.site.register(Usuario, CustomUserAdmin)
admin.site.register(PessoaFisica)
admin.site.register(PessoaJuridica)
admin.site.register(SegurancaModeracao)