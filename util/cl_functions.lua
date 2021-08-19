RegisterNetEvent('drawEditorV:ShowBusySpinner')

function editorStartNewProject(_name)
    project = {
        name = _name,
        drawNicks = {
            --"draw1",
        },
        draws = {
            --[[ ['Draw1'] = {
                type = 'text',
                nick = "Draw1",
                font = 0,
                scale = 0.5,
                colour = {r = 255, g = 255, b = 255, a = 255},
                dropShadow = {dist = 0, r = 255, g = 255, b = 255, a = 255},
                edge = {dist = 1, r = 0, g = 0, b = 0, a = 255},
                outline = true,
                justification = 2,
                warp = {left = 0.01, right = 0.97},
                string = "Drawable Text",
                xCoord = 0.85,
                yCoord = 0.08,
            },]]
        }
    }
end

function editorCreateNewTextDraw(_nick)
    project.drawNicks[#project.drawNicks + 1] = _nick
    project.draws[_nick] = {
        type = 'text',
        nick = _nick,
        font = 0,
        scale = 0.9,
        colour = {r = 255, g = 255, b = 255, a = 255},
        dropShadow = {dist = 0, r = 255, g = 255, b = 255, a = 255},
        edge = {dist = 1, r = 0, g = 0, b = 0, a = 255},
        outline = true,
        justification = 1,
        warp = {left = 0.01, right = 0.99},
        string = "New Drawable Text",
        xCoord = 0.5,
        yCoord = 0.5,
    }
end
function editorCreateNewRectDraw(_nick)
    project.drawNicks[#project.drawNicks + 1] = _nick
    project.draws[_nick] = {
        type = 'rect',
        nick =_nick,
        x = 0.5,
        y = 0.5,
        width = 0.2,
        height = 0.2,
        r = 255, g = 255, b = 255, a = 255
    }
end

function alert(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function notify(string, colID)
    if colID ~= nil then
        ThefeedSetNextPostBackgroundColor(colID)
    end
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(string)
    EndTextCommandThefeedPostTicker(true, true)
end

AddEventHandler('drawEditorV:ShowBusySpinner', function(type, toggle, string, colID)
    if type == "save" then
        if toggle == 1 then
            BeginTextCommandBusyspinnerOn("STRING")
            AddTextComponentSubstringPlayerName("Saving "..string..".")
            EndTextCommandBusyspinnerOn(1)
        elseif toggle == 0 then
            BusyspinnerOff()
            notify(string, colID)
        end
    end
end)