require "./media"

def buscaSimples(id = false)
    if id == false 
        return Travel.all
    
    else
        cont = Travel.where{ _id == id }
        return cont.first
    end
end

def auxBusca(paradas)
    #faz a requisição a api e retorna uma lista com as informações das localizações
    url = "https://rickandmortyapi.com/api/location/" + paradas
    info = JSON.parse(HTTP::Client.get(url).body).as_a
    listInfo = [] of Hash(String, JSON::Any)
    info.each do |item|
        listInfo.push(item.as_h) 
    end
    return listInfo
end

def buscaExpandida(id = false)
    if id == false 
        registros = Travel.all
        retorno = [] of Hash(String, Array(Hash(String, JSON::Any))|Int64|Nil)
        registros.each do |reg|
            id = reg.id
            paradas = auxBusca(reg.travel_stops.to_json)
            paradas = paradas.map{|item| item.select!("id", "name", "type", "dimension")}
            retorno.push({"id" => id, "travel_stops" => paradas})
        end
        return retorno
    else
        reg = Travel.where{ _id == id }
        retorno = Hash(String, Array(Hash(String, JSON::Any))|Int64|Nil).new
        reg.each do |r|
            id = r.id
            paradas = auxBusca(r.travel_stops.to_json)
            paradas = paradas.map{|item| item.select!("id", "name", "type", "dimension")}
            retorno = {"id" => id, "travel_stops" => paradas}
        end
        return retorno
    end

end

def buscaOtimizada(id = false)
    if id == false 
        registros = Travel.all
        retorno = [] of Hash(String, Array(Int32)|Int64|Nil)
        registros.each do |reg|
            id = reg.id
            paradas = auxBusca(reg.travel_stops.to_json)
            paradas = media(paradas)
            paradasListInt = paradas.map{|h| h["id"].as_i }
            
            retorno.push({"id" => id, "travel_stops" => paradasListInt})
        end
        return retorno
    
    else
        registro = Travel.where{ _id == id }
        retorno = Hash(String, Int32|Array(Int32)).new
        registro.each do |reg|
            id = reg.id
            paradas = auxBusca(reg.travel_stops.to_json)
            paradas = media(paradas)
            paradasListInt = paradas.map{|h| h["id"].as_i }
            
            retorno = {"id" => id, "travel_stops" => paradasListInt}
        end
        return retorno
    end

end

def buscaCompleta(id = false)
    if id == false 
        registros = Travel.all
        retorno = [] of Hash(String, Array(Hash(String, JSON::Any))|Int64|Nil)
        registros.each do |reg|
            id = reg.id
            paradas = auxBusca(reg.travel_stops.to_json)
            paradas = media(paradas)
            paradasListCompl = paradas.map{|item| item.select!("id", "name", "type", "dimension")}
            
            retorno.push({"id" => id, "travel_stops" => paradasListCompl})
        end
        return retorno
    
    else
        registro = Travel.where{ _id == id }
        retorno = Hash(String, Array(Hash(String, JSON::Any))|Int64|Nil).new
        registro.each do |reg|
            id = reg.id
            paradas = auxBusca(reg.travel_stops.to_json)
            paradas = media(paradas)
            paradasListCompl = paradas.map{|item| item.select!("id", "name", "type", "dimension")}
            
            retorno = {"id" => id, "travel_stops" => paradasListCompl}
        end
        return retorno
    end
end

def adiciona(paradas)
    Jennifer::Adapter.default_adapter.transaction do |tx|
        Travel.create(travel_stops: paradas)
    end
end

def altera(id, paradas)
    registro = Travel.where{ _id == id }.update(travel_stops: paradas)
    
end

def apaga(id)
    Travel.delete(id)
end

def adicionaParadas(id, paradas)
    cont = Travel.where{ _id == id }
    cont.each do |c|
        n = c.travel_stops|(paradas)
        registro = Travel.where{ _id == id }.update(travel_stops: n)
    end
end