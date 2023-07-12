# Projeto Crystal - Kemal - Jennifer
O projeto foi criado para demonstrar uma forma de implementar o framework web Kemal e o orm jennifer.
Foi utilizado o Docker para montar as imagens do sistema operacional e do banco de dados Postgresql

## impl
Este projeto consiste em uma API para planejamento de viagens no universo de Rick and Morty.

## Instalação
Executar o comando 'docker-compose up' na pasta raiz do projeto.

## Uso
A api estará rodando em localhost:3000
Os endpoints são:

 - POST /travel-plans - Adiciona um plano de viagem com uma lista de pontos de parada
    - corpo da requisição: {"travel_stops": [pontos de parada - Integer]}

 - GET /travel-plans - Retorna todos os planos de viagem gravados no banco de dados
    - parametros:
        - expand=true = expandir as paradas de cada viagem de modo que o campo travel_stops agora retorna: "id", "name", "type", "dimension"
        - optimize=true = deve reordenar as paradas para visitar todas as localizações de uma mesma dimensão antes de se pular para uma localização de outra dimensão. Dentro de uma mesma dimensão, as localizações serão visitadas em ordem crescente de popularidade e em caso de igualdade, por ordem alfabetica. Para a visita das dimensões, foi utilizada a popularidade média de suas localizações. Em caso de empate, ordenar em ordem alfabética.

 - GET /travel-plans/{id} - Retorna o plano de viagem do id correspondente 

 - PUT /travel-plans/{id} - Altera o plano de viagem do id correspondente
    -   corpo da requisição: {"travel_stops": [pontos de parada - Integer]}

 - PUT /travel-plans/{id}/append - Adiciona paradas ao plano de viagem do id correspondente
    -   corpo da requisição: {"travel_stops": [pontos de parada - Integer]}

 - DELETE /travel-plans/{id} - Apaga o plano de viagem do id correspondente


## Contributing

1. Fork it (<https://github.com/your-github-user/impl/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Marcus Lima](https://github.com/sucramlima2021) - creator and maintainer
