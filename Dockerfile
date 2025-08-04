# Usar Python 3.11 slim como base
FROM python:3.11-slim

# Establecer variables de entorno
ENV PYTHONUNBUFFERED=1 \
	PYTHONDONTWRITEBYTECODE=1 \
	PIP_NO_CACHE_DIR=1 \
	PIP_DISABLE_PIP_VERSION_CHECK=1

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
	curl \
	&& rm -rf /var/lib/apt/lists/*

# Crear directorio de trabajo
WORKDIR /app

# Instalar uv para gestión de dependencias
RUN pip install uv

# Copiar archivos de dependencias
COPY pyproject.toml uv.lock README.md ./

# Instalar dependencias del proyecto
RUN uv venv
# RUN source .venv/bin/activate
RUN uv pip install -r pyproject.toml

# Copiar código fuente
COPY . .

# Exponer puerto por defecto de LangGraph
EXPOSE 2026

# Comando por defecto para ejecutar el servidor LangGraph
CMD ["uv", "run", "langgraph", "dev", "--no-browser", "--host", "0.0.0.0", "--port", "2026"]
