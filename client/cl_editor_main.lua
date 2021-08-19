print('--[[============================drawEditorV=================================]]--')
print('                               Editor loaded                                    ')
print('--[[============================drawEditorV=================================]]--')

view = "project"
currentDraw = 0

project = {
    name = "Project Name",
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

Citizen.CreateThread(function()
    setInstructionalButtons(instButtonText[view])

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
                    TriggerEvent('drawEditorV:OpenDrawsMenu')
                end
            end
        end

        if view == 'draws' then
            for i,k in pairs(project.draws) do
                drawText(k)
            end
        elseif view == 'drawEditor' then
            for i,k in pairs(project.draws) do
                if k.nick ~= currentDraw then
                    drawText(k, 80)
                else
                    drawText(k)
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
        SetTextDropshadow(_data.dropShadow.dist, _data.dropShadow.r, _data.dropShadow.g, _data.dropShadow.b, _overrideAlpha)
        SetTextEdge(_data.edge.dist, _data.edge.r, _data.edge.g, _data.edge.b, _overrideAlpha)
    else
        SetTextColour(_data.colour.r, _data.colour.g, _data.colour.b, _data.colour.a)
        SetTextDropshadow(_data.dropShadow.dist, _data.dropShadow.r, _data.dropShadow.g, _data.dropShadow.b, _data.dropShadow.a)
        SetTextEdge(_data.edge.dist, _data.edge.r, _data.edge.g, _data.edge.b, _data.edge.a)
    end
    SetTextDropShadow()
    SetTextOutline()
    SetTextJustification(_data.justification)
    SetTextWrap(_data.warp.left, _data.warp.right)
    SetTextEntry("STRING")
    AddTextComponentString(_data.string)
    DrawText(_data.xCoord, _data.yCoord)
end