print('--[[============================drawEditorV=================================]]--')
print('                               Editor loaded                                    ')
print('--[[============================drawEditorV=================================]]--')

view = "project"
editorView = ""
currentDraw = 0
editedDraw = {

}

project = {
    name = "unk",
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
        },
        ['draw2'] = {
            type = 'rect',
            nick ='draw2',
            x = 0.0,
            y = 0.0,
            width = 1.0,
            height = 1.0,
            r = 255, g = 255, b = 255, a = 255
        },
        ['draw3'] = {
            type = 'rect',
            nick ='draw2',
            x = 0.0,
            y = 0.0,
            width = 1.0,
            height = 1.0,
            r = 255, g = 255, b = 255, a = 255
        },
        
        ]]

    },
}

Citizen.CreateThread(function()
    requestButtonScaleform()
    setInstructionalButtons(instButtonText[view])
    SetNuiFocus(true,true)

    while true do
        if not WarMenu.IsAnyMenuOpened() then
            DrawScaleformMovieFullscreen(buttonScaleformId, 255, 255, 255, 255)

            if IsControlJustReleased(0,  23) then  -- F
                if view == 'project' then
                    clearInstructionalButtons()
                    setInstructionalButtons(instButtonText[view])
                    TriggerEvent('drawEditorV:OpenProjectMenu')
                elseif view == 'draws' then
                    clearInstructionalButtons()
                    setInstructionalButtons(instButtonText[view])
                    TriggerEvent('drawEditorV:OpenDrawsMenu')
                elseif view == 'drawEditor' then
                    clearInstructionalButtons()
                    setInstructionalButtons(instButtonText[view])
                    editorView = ""
                    TriggerEvent('drawEditorV:OpenDrawsMenu')
                end
            end
        end

        if view == 'draws' then
            for i,k in pairs(project.draws) do
                if k.type == 'text' then
                    drawText(k)
                elseif k.type == 'rect' then
                    DrawRect(k.x, k.y, k.width, k.height, k.r, k.g, k.b, k.a)
                elseif k.type == 'img' then
                    DrawSprite(k.txd, k.txn, k.x, k.y, k.width, k.height, k.heading, k.r, k.g, k.b, k.a)
                end
            end
        elseif view == 'drawEditor' then
            if not WarMenu.IsAnyMenuOpened() then
                SetMouseCursorActiveThisFrame()
            end
            --local x,y = GetCursorPosition()
            --drawText2(x+0.000001, y+0.000001)
            for i,k in pairs(project.draws) do
                if k.nick ~= currentDraw then
                    if k.type == 'text' then
                        drawText(k, 80)
                    elseif k.type == 'rect' then
                        DrawRect(k.x, k.y, k.width, k.height, k.r, k.g, k.b, 80)
                    elseif k.type == 'img' then
                        DrawSprite(k.txd, k.txn, k.x, k.y, k.width, k.height, k.heading, k.r, k.g, k.b, 80)
                    end
                else
                    if k.type == 'text' then
                        drawText(editedDraw)
                    elseif k.type == 'rect' then
                        DrawRect(editedDraw.x, editedDraw.y, editedDraw.width, editedDraw.height, editedDraw.r, editedDraw.g, editedDraw.b, editedDraw.a)
                    elseif k.type == 'img' then
                        DrawSprite(editedDraw.txd, editedDraw.txn, editedDraw.x, editedDraw.y, editedDraw.width, editedDraw.height, editedDraw.heading, editedDraw.r, editedDraw.g, editedDraw.b, editedDraw.a)
                    end
                end
            end
            if editorView == "changePos" then
                if IsControlPressed(0,  24) then  -- click
                    if editedDraw.type == 'text' then
                        editedDraw.xCoord, editedDraw.yCoord = GetCursorPosition()
                    elseif editedDraw.type == 'rect' then
                        editedDraw.x, editedDraw.y = GetCursorPosition()
                    elseif editedDraw.type == 'img' then
                        editedDraw.x, editedDraw.y = GetCursorPosition()
                    end
                end
            elseif editorView == "changeSize" then
                if editedDraw.type == 'text' then
                    editedX, editedY = GetCursorPosition()
                    if IsControlJustPressed(0,  96) then  -- up
                        editedDraw.scale = editedDraw.scale + 0.05
                    elseif IsControlJustPressed(0,  97) then  -- down
                        editedDraw.scale = editedDraw.scale - 0.05
                    end
                elseif editedDraw.type == 'rect' then
                    if IsControlPressed(0,  24) then
                        editedDraw.width, editedDraw.height = GetCursorPosition()
                    end
                elseif editedDraw.type == 'img' then
                    if IsControlPressed(0,  24) then
                        editedDraw.width, editedDraw.height = GetCursorPosition()
                    end
                end
            elseif editorView == "changeWarpRight" then
                if editedDraw.type == 'text' then
                    if IsControlPressed(0,  24) then
                        editedDraw.warp.right, retval = GetCursorPosition()
                    end
                    DrawRect(editedDraw.warp.right, 0.5, 0.01, 1.01, 255, 0, 0, 150)
                    DrawRect(editedDraw.warp.left, 0.5, 0.01, 1.01, 255, 0, 0, 80)
                end
            elseif editorView == "changeWarpLeft" then
                if editedDraw.type == 'text' then
                    if IsControlPressed(0,  24) then
                        editedDraw.warp.left, retval = GetCursorPosition()
                    end
                    
                    DrawRect(editedDraw.warp.right, 0.5, 0.01, 1.01, 255, 0, 0, 80)
                    DrawRect(editedDraw.warp.left, 0.5, 0.01, 1.01, 255, 0, 0, 150)
                end
            end
        end
        Citizen.Wait(0)
    end
end)

function drawText(_data, _overrideAlpha)
    SetTextFont(_data.font)
    SetTextProportional(1)
    SetTextScale(0.0, _data.scale)
    if _overrideAlpha ~= nil then
        SetTextColour(_data.colour.r, _data.colour.g, _data.colour.b, _overrideAlpha)
        --SetTextDropshadow(_data.dropShadow.dist, _data.dropShadow.r, _data.dropShadow.g, _data.dropShadow.b, _overrideAlpha)
        SetTextEdge(_data.edge.dist, _data.edge.r, _data.edge.g, _data.edge.b, _overrideAlpha)
    else
        SetTextColour(_data.colour.r, _data.colour.g, _data.colour.b, _data.colour.a)
        --SetTextDropshadow(_data.dropShadow.dist, _data.dropShadow.r, _data.dropShadow.g, _data.dropShadow.b, _data.dropShadow.a)
        SetTextEdge(_data.edge.dist, _data.edge.r, _data.edge.g, _data.edge.b, _data.edge.a)
    end
    if _data.outline then
        SetTextOutline()
    end
    if _data.dropShadow2 then
        SetTextDropShadow()
    end
    SetTextJustification(_data.justification)
    SetTextWrap(_data.warp.left, _data.warp.right)
    SetTextEntry("STRING")
    AddTextComponentString(_data.string)
    DrawText(_data.xCoord, _data.yCoord)
end

function drawTextHelper(string, x, y)
    SetTextFont(0)
    SetTextProportional(2)
    SetTextScale(0.0, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextJustification(1)
    SetTextWrap(0.01, 0.99)
    SetTextEntry("STRING")
    AddTextComponentString(string)
    DrawText(x, y)
end