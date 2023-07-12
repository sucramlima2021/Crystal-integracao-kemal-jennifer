def media(tab)
    listDimensoes = [] of Hash(String, String|Array(Hash(String, JSON::Any))|Float64)
    dimensoes = Array(String).new
    contador = Array(Int32).new
    # cria uma lista com as dimensões exixtentes no array
    tab.each do |pp|
        if dimensoes.index(pp["dimension"]) == nil
            dimensoes << pp["dimension"].to_s
        end
    end
    #cria um hash com o nome da dimensão os locais daquela dimensão e a média de personagens residentes
    #a média de habitantes é obtida pelo somatório dos personagens / número de locais
    dimensoes.each do |tt|
        resid = 0
        qt = 0
        locals = [] of Hash(String, JSON::Any)
        tab.each do |pp|
            if pp["dimension"].to_s == tt
                resid = resid + pp["residents"].size
                qt = qt + 1
                locals << pp
            end
    end
    mediaDimensao = resid / qt
    listDimensoes << {"dimensao" => tt, "locals" => locals, "media" => mediaDimensao}
end

    #ordena os locais de cada dimensão
    listDimensoes.each do |dim|     
        locals = dim["locals"].to_json
        locals = Array(Hash(String, JSON::Any)).from_json(locals) 
        locals.sort_by!{|p|{p["residents"].size, p["name"].as_s}}
        dim["locals"] = locals
    end
    #ordena as dimesões baseado nas médias de cada uma 
    final = listDimensoes.to_json
    final = Array(Hash(String, JSON::Any)).from_json(final)
    final.sort_by!{|p|{p["media"].as_f, p["dimensao"].as_s}}
    #cria uma lista final somente com as localizações de forma ordenada
    localsOrd = [] of Hash(String, JSON::Any)
    final.each do |d|
        loc = Array(Hash(String, JSON::Any)).from_json(d["locals"].to_json)
        loc.each do |l|
            localsOrd << l
        end
    end
    return localsOrd
end