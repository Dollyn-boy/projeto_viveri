# Adrielle, Duda e Taylon
import pytest
from django.urls import reverse
from numpy.ma.testutils import assert_equal
from rest_framework import status
from rest_framework.test import APITestCase, APIClient

from Events.models import Eventos, Local
from FAQ.models import Pergunta, Denuncia, Notificacao, TipoNotificacao, Resposta
from accounts.models import Usuario


class IntegrationTest(APITestCase):
    _API_CLI = APIClient()

    @classmethod
    def setUpTestData(cls):
        cls.usuario = Usuario.objects.create_user(username='test', password='senhaforte')
        cls.local = Local.objects.create(id_local="12334")
        cls.evento = Eventos.objects.create(
            nome='Evento De Test',
            usuario=cls.usuario,
            local=cls.local,
        )

        Pergunta.objects.bulk_create([
            Pergunta(texto="Hora?", usuario=cls.usuario, evento=cls.evento),
            Pergunta(texto="Dia?", usuario=cls.usuario, evento=cls.evento),
            Pergunta(texto="Mes?", usuario=cls.usuario, evento=cls.evento),
        ])

        cls.pergunta1 = Pergunta.objects.create(texto="Comeu?", usuario=cls.usuario, evento=cls.evento)
        cls.pergunta2 = Pergunta.objects.create(texto="Dormiu?", usuario=cls.usuario, evento=cls.evento)

        Notificacao.objects.bulk_create([
            Notificacao(tipo = TipoNotificacao.INFO, mensagem = "Nova pergunta", usuario = cls.usuario, evento = cls.evento),
            Notificacao(tipo = TipoNotificacao.ALERTA, mensagem = "Alerta!", usuario = cls.usuario, evento = cls.evento)
        ])

        cls.resposta = Resposta.objects.create(texto = "ás 12:15", usuario=cls.usuario, pergunta=cls.pergunta2)


    def setUp(self):
        self.client.force_authenticate(user=self.usuario)

    @pytest.fixture
    def usuario(cls):
        return Usuario.objects.create_user(
            username="Douglas", password="LOUVRE", email="patinhas@uefs.com"
        )

    @pytest.fixture
    def evento(cls):
        return Eventos.objects.create(nome = "Conserto do BTS", descricao = "Melhor banda do mundo")

    @pytest.fixture
    def pergunta(cls):
        from FAQ.models import Pergunta

        return Pergunta.objects.create(texto = "Tem pipoca", usuario = usuario, evento = evento)


    @pytest.mark.django_db
    def test_criar_pergunta(api_client):
        data = {
            "texto": "Tem pipoca",
            "evento": api_client.evento.id,
            "usuario": api_client.usuario.id
        }
        response = api_client.post("/api/pergunta", data)
        assert response.status.code == 201
        assert pergunta.objects.count() == 1

    @pytest.mark.django_db
    def test_list_perguntas(cls):
        url = reverse("pergunta-list")
        resp = cls.client.get(url)

        pergunta = Pergunta.objects.get(texto="Hora?")

        assert pergunta is not None

        cls.assertEqual(resp.status_code, 200)

        textos = [D["texto"] for D in resp.data]

        cls.assertIn(pergunta.texto, textos)
        cls.assertEqual(len(textos), 5)

    @pytest.mark.django_db
    def test_criar_resposta(api_client, usuario, pergunta):
        data = {
            "texto": "Será domingo?", "pergunta": pergunta.id, "usuario": usuario.id
        }
        response = api_client.post("/api/pergunta", data)
        assert response.status_code == 201
        assert pergunta.objects.count() == 1


    @pytest.mark.django_db
    def test_list_notificacao (cls):
        url = reverse("notificacao-list")
        resp = cls.client.get(url)

        cls.assertEqual(resp.status_code, 200)

        data: list[dict] = resp.data

        cls.assertEqual(len(data), 2)

        notificacao = Notificacao.objects.get(mensagem="Alerta!")

        for N in data:
            if N["tipo"] == notificacao.tipo:
                break
        else:
            cls.fail()


    @pytest.mark.django_db
    def test_criar_notificacao(self):
        url = reverse("notificacao-list")
        data = {
            "tipo": "Socorro",
            "mensagem": "Novo evento",
            "evento": self.evento.id_evento,
            "usuario": self.usuario.id,
            "pergunta": self.pergunta1.id,
        }
        response = self.client.post(url, data, format = "json")
        self.assertEqual(response.status_code, 201)
        self.assertTrue(Notificacao.objects.filter(mensagem="Novo evento").exists())

    @pytest.mark.django_db
    def test_list_denuncias(cls):
        url = reverse("denuncia-list")
        response = cls.client.get(url)

        cls.assertEqual(response.status_code, 200)

    @pytest.mark.django_db
    def test_criar_denuncia(self):
        url = reverse("denuncia-list")
        data = {
            "descricao": "Roubaram minha goiaba",
            "pergunta": self.pergunta2.id,
            "resposta": self.resposta.id,
        }
        response = self.client.post(url, data, format="json")

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Denuncia.objects.filter(descricao="Roubaram minha goiaba").exists())

        new = Denuncia.objects.get(descricao="Roubaram minha goiaba")
        self.assertEqual(new.pergunta, self.pergunta2)
        self.assertEqual(new.resposta, self.resposta)

        self.assertIsNotNone(new)


