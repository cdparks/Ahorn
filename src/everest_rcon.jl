module EverestRcon
using HTTP, YAML

queryurl(url, query) = url * HTTP.escapeuri(query)

function request(url::String, query::Dict{String, Any}=Dict{String, Any}())
    try
        res = HTTP.get(queryurl(url, query), readtimeout=1)

        return true, String(res.body)
        
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            return false, String(e.response.body)

        else
            println(e)
            return false, "Connection timed out"
        end
    end
end

respawn(baseUrl::String) = request("$baseUrl/respawn?")

focus(baseUrl::String) = request("$baseUrl/focus")

reload(baseUrl::String, area::String) = request("$baseUrl/reloadmap?", Dict("area" => area))
reload(baseUrl::String, area::String, side::String) = request("$baseUrl/reloadmap?", Dict("area" => area, "side" => side))

# Ahorn doesn't support sides yet, ignore for now
teleport(baseUrl::String, area::String, room::String; force::Bool=true) = request("$baseUrl/tp?", Dict("area" => area, "room" => room, "forcenew" => force))
teleport(baseUrl::String, area::String, room::String, x::Integer, y::Integer; force::Bool=true) = request("$baseUrl/tp?", Dict("area" => area, "room" => room, "forcenew" => force, "x" => x, "y" => y))

teleportToRoom(baseUrl::String, level::String; force::Bool=true) = request("$baseUrl/tp?", Dict("level" => level, "forcenew" => force))
teleportToRoom(baseUrl::String, level::String, x::Integer, y::Integer; force::Bool=true) = request("$baseUrl/tp?", Dict("level" => level, "forcenew" => force, "x" => x, "y" => y))

function session(baseUrl::String)
    success, data = request("$baseUrl/session")

    if success
        return true, YAML.load(data)

    else
        return false, data
    end
end

end