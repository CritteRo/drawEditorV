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
                wrap = {left = 0.01, right = 0.97},
                string = "Drawable Text",
                xCoord = 0.85,
                yCoord = 0.08,
            },]]
        }
    }
end

function editorCreateNewTextDraw(_nick, _copy)
    project.drawNicks[#project.drawNicks + 1] = _nick
    if _copy ~= nil then
        project.draws[_nick] = {
            type = 'text',
            nick = _nick,
            font = project.draws[_copy].font,
            scale = project.draws[_copy].scale,
            colour = project.draws[_copy].colour,
            dropShadow = project.draws[_copy].dropShadow,
            dropShadow2 = project.draws[_copy].dropShadow2,
            edge = project.draws[_copy].edge,
            outline = project.draws[_copy].outline,
            justification = project.draws[_copy].justification,
            wrap = project.draws[_copy].wrap,
            string = project.draws[_copy].string,
            xCoord = project.draws[_copy].xCoord,
            yCoord = project.draws[_copy].yCoord,
        }
    else
        project.draws[_nick] = {
            type = 'text',
            nick = _nick,
            font = 0,
            scale = 0.9,
            colour = {r = 255, g = 255, b = 255, a = 255},
            dropShadow = {dist = 1, r = 1, g = 1, b = 1, a = 255},
            dropShadow2 = true,
            edge = {dist = 3, r = 0, g = 0, b = 0, a = 255},
            outline = true,
            justification = 1,
            wrap = {left = 0.01, right = 0.99},
            string = "New Drawable Text",
            xCoord = 0.5,
            yCoord = 0.5,
        }
    end
end
function editorCreateNewRectDraw(_nick, _copy)
    project.drawNicks[#project.drawNicks + 1] = _nick
    if _copy ~= nil then
        project.draws[_nick] = {
            type = 'rect',
            nick =_nick,
            x = project.draws[_copy].x,
            y = project.draws[_copy].y,
            width = project.draws[_copy].width,
            height = project.draws[_copy].height,
            r = project.draws[_copy].r, g = project.draws[_copy].g, b = project.draws[_copy].b, a = project.draws[_copy].a
        }
    else
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
end

function editorCreateNewImgDraw(_nick, _copy)
    project.drawNicks[#project.drawNicks + 1] = _nick
    if _copy ~= nil then
        project.draws[_nick] = {
            type = 'img',
            nick =_nick,
            txd = project.draws[_copy].txd,
            txn = project.draws[_copy].txn,
            x = project.draws[_copy].x,
            y = project.draws[_copy].y,
            width = project.draws[_copy].width,
            height = project.draws[_copy].height,
            heading = project.draws[_copy].heading,
            r = project.draws[_copy].r, g = project.draws[_copy].g, b = project.draws[_copy].b, a = project.draws[_copy].a
        }
    else
        project.draws[_nick] = {
            type = 'img',
            nick =_nick,
            txd = "textureDirectory",
            txn = "textureName",
            x = 0.5,
            y = 0.5,
            width = 0.2,
            height = 0.2,
            heading = 0.0,
            r = 255, g = 255, b = 255, a = 255
        }
    end
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
            AddTextComponentSubstringPlayerName(string)
            EndTextCommandBusyspinnerOn(1)
        elseif toggle == 0 then
            BusyspinnerOff()
            notify(string, colID)
        end
    end
end)