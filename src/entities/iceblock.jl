module IceBlock

using ..Ahorn, Maple

placements = Dict{String, Ahorn.EntityPlacement}(
    "Ice Block" => Ahorn.EntityPlacement(
        Maple.IceBlock,
        "rectangle"
    ),
)

function minimumSize(entity::Maple.Entity)
    if entity.name == "iceBlock"
        return true, 8, 8
    end
end

function resizable(entity::Maple.Entity)
    if entity.name == "iceBlock"
        return true, true, true
    end
end

function selection(entity::Maple.Entity)
    if entity.name == "iceBlock"
        x, y = Ahorn.entityTranslation(entity)

        width = Int(get(entity.data, "width", 8))
        height = Int(get(entity.data, "height", 8))

        return true, Ahorn.Rectangle(x, y, width, height)
    end
end

edgeColor = (108, 214, 235, 255) ./ 255
centerColor = (76, 168, 214, 102) ./ 255

function render(ctx::Ahorn.Cairo.CairoContext, entity::Maple.Entity, room::Maple.Room)
    if entity.name == "iceBlock"
        x = Int(get(entity.data, "x", 0))
        y = Int(get(entity.data, "y", 0))

        width = Int(get(entity.data, "width", 32))
        height = Int(get(entity.data, "height", 32))

        Ahorn.drawRectangle(ctx, 0, 0, width, height, centerColor, edgeColor)

        return true
    end

    return false
end

end