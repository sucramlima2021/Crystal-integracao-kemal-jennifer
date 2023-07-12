require "kemal"
require "../config/config"
require "json"
require "http/client"
require "http/status"
require "./queries"


get "/travel_plans" do |env|
    expand, optimize = false, false
    
    if env.params.query.has_key?("expand") && env.params.query["expand"] == "true"
        expand = true
    end
    if env.params.query.has_key?("optimize") && env.params.query["optimize"] == "true"
        optimize = true
    end
    
    if expand==true && optimize == false
        retorno = buscaExpandida()
    end
    if expand==false && optimize == true
        retorno = buscaOtimizada()
    end    
    if expand==true && optimize == true
        retorno = buscaCompleta()
    end
    if expand==false && optimize == false
        retorno =  buscaSimples()
    end
    env.response.content_type = " application/json"
    retorno.to_json
end


get "/travel_plans/:id" do |env|
    id = env.params.url["id"].to_i
    if Travel.where{_id == id}.exists?
    
        expand, optimize = false, false
        
        if env.params.query.has_key?("expand") && env.params.query["expand"] == "true"
            expand = true
        end
        if env.params.query.has_key?("optimize") && env.params.query["optimize"] == "true"
            optimize = true
        end
        
        if expand==true && optimize == false
            retorno = buscaExpandida(id)
        end
        if expand==false && optimize == true
            retorno = buscaOtimizada(id)
        end    
        if expand==true && optimize == true
            retorno = buscaCompleta(id)
        end
        if expand==false && optimize == false
            retorno = buscaSimples(id)
        end
            env.response.content_type = " application/json"
            retorno.to_json
    else
        env.response.status = HTTP::Status.new(404)
    end
end


post "/travel_plans" do |env|
    paradas = Array(Int32).from_json(env.params.json["travel_stops"].to_json)
    adiciona(paradas)
    env.response.status = HTTP::Status.new(201)
    env.response.content_type = " application/json"
    Travel.last.to_json
end


put "/travel_plans/:id" do |env|
    id = env.params.url["id"].to_i
    if Travel.where{_id == id}.exists?
        paradas = Array(Int32).from_json(env.params.json["travel_stops"].to_json)
        altera(id, paradas)
        env.response.status = HTTP::Status.new(200)
        env.response.content_type = " application/json"
        Travel.where{ _id == id }.first.to_json
    else
        env.response.status = HTTP::Status.new(404)
    end
end


delete "/travel_plans/:id" do |env|
    id = env.params.url["id"].to_i
    if Travel.where{_id == id}.exists?
        apaga(id)
        env.response.status = HTTP::Status.new(204) 
    else
        env.response.status = HTTP::Status.new(404)
    end 
end

put "/travel_plans/:id/append" do |env|
    id = env.params.url["id"].to_i
    if Travel.where{_id == id}.exists?
        paradas = Array(Int32).from_json(env.params.json["travel_stops"].to_json)
        adicionaParadas(id, paradas)
        env.response.status = HTTP::Status.new(200)
        env.response.content_type = " application/json"
        Travel.where{ _id == id }.first.to_json
    else
        env.response.status = HTTP::Status.new(404)
    end
end

Kemal.run