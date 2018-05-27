function showFileOpenDialog(leaf::Gtk.GtkMenuItemLeaf=MenuItem())
    celesteDir = config["celeste_dir"]
    mapsDir = joinpath(celesteDir, "ModContent", "Maps")

    if isdir(celesteDir)
        if !isdir(mapsDir)
            mkpath(mapsDir)
        end

        cd(mapsDir)
    end

    filename = ""
    cd(mapsDir) do
        filename = open_dialog("Select map binary", window, tuple("*.bin"))
    end

    # Did we actually select a file?
    if filename != ""
        loadedState.filename = filename
        loadedState.map = loadMap(filename)
        loadedState.roomName = ""
        loadedState.room = nothing

        persistence["files_lastroom"] = loadedState.roomName
        persistence["files_lastfile"] = loadedState.filename
        
        packageName = loadedState.map.package

        updateTreeView!(roomList, getTreeData(loadedState.map))

        setproperty!(window, :title, "$baseTitle - $packageName")

        draw(canvas)
    end
end

# save_dialog only warns on overwrite, but will ONLY return the filename
function showFileSaveDialog(leaf::Gtk.GtkMenuItemLeaf=MenuItem())
    celesteDir = config["celeste_dir"]
    mapsDir = joinpath(celesteDir, "ModContent", "Maps")

    if isdir(celesteDir)
        if !isdir(mapsDir)
            mkpath(mapsDir)
        end

    end

    filename = ""
    cd(mapsDir) do
        filename = save_dialog("Save as", window)
    end

    if filename != ""
        loadedState.filename = filename
        
        saveFile(loadedState.map, filename)
    end
end

function menuFileSave(leaf::Gtk.GtkMenuItemLeaf=MenuItem())
    if loadedState.filename === nothing || loadedState.filename == ""
        showFileSaveDialog(leaf)

    else
        saveFile(loadedState.map, loadedState.filename)
    end
end

saveFile(m::Map, filename::String) = splitext(filename)[2] == ".bin"? encodeMap(m, filename) : encodeMap(m, filename * ".bin")
