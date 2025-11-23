FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Diretório da aplicação
WORKDIR /app

# Dependências do sistema (compilação do psycopg2)
RUN apt-get update && apt-get install -y build-essential && apt-get clean

# Copiar requirements
COPY requirements.txt .

# Instalar dependências Python
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copiar código da aplicação
COPY . .

# Criar usuário não-root
RUN useradd -m -r appuser && chown -R appuser /app
USER appuser

# Porta exposta
EXPOSE 8000

# Iniciar Gunicorn apontando para *projeto_viveri*
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "projeto_viveri.wsgi:application"]
