# Use uma imagem base do Crystal
FROM crystallang/crystal


# Defina o diretório de trabalho dentro do container
WORKDIR /app

# Copie o conteúdo do repositório para o diretório de trabalho do container
COPY . /app


