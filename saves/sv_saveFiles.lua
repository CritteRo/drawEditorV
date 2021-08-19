RegisterNetEvent('drawEditorV:ExportProject')

AddEventHandler('drawEditorV:ExportProject', function(project)
    local src = source
    local json = json.encode(project)
    TriggerClientEvent('drawEditorV:ShowBusySpinner', src, 'save', 1, '~y~drawEditorV_export_'..project.name..'.lua~s~')
    file=io.open("drawEditorV\\drawEditorV_export_"..project.name..".lua", "w+")
    io.output(file)
    if file ~= nil then
        for i,k in pairs(project.draws) do
            if k.type == 'text' then
                io.write("--[[  :: "..k.nick.." ::  ]]--\nSetTextFont("..k.font..")\nSetTextProportional(1)\nSetTextScale(0.0, "..k.scale..")\n")
                Citizen.Wait(10)
                io.write("SetTextColour("..k.colour.r..", "..k.colour.g..", "..k.colour.b..", "..k.colour.a..")\nSetTextDropshadow("..k.dropShadow.dist..", "..k.dropShadow.r..","..k.dropShadow.g..", "..k.dropShadow.b..", "..k.dropShadow.a..")\n")
                Citizen.Wait(10)
                io.write("SetTextEdge("..k.edge.dist..", "..k.edge.r..","..k.edge.g..", "..k.edge.b..", "..k.edge.a..")\nSetTextDropShadow()\nSetTextOutline()\nSetTextJustification("..k.justification..")\nSetTextWrap("..k.warp.left..", "..k.warp.right..")\n")
                Citizen.Wait(10)
                io.write("SetTextEntry('STRING')\nAddTextComponentString('"..k.string.."')\nDrawText("..k.xCoord..", "..k.yCoord..")\n--[[  :: END OF "..k.nick.." ::  ]]--\r\n")
            elseif k.type == 'rect' then
                io.write("--[[  :: "..k.nick.." ::  ]]--\nDrawRect("..k.x..", "..k.y..", "..k.width..", "..k.height..", "..k.r..", "..k.g..", "..k.b..", "..k.a..")\n--[[  :: END OF "..k.nick.." ::  ]]--\r\n")
            end
        end
        io.write('--[[ TEXT DRAWS BUILT USING drawEditorV for FiveM. Resource created by CritteR ]]--')
        TriggerClientEvent('drawEditorV:ShowBusySpinner', src, 'save', 0, 'Export finished!', 116)
    else
        print(' EXPORTING A FILE TO \\drawEditorV\\filename.lua !!!')
        print(' YOU SHOULD GO TO THE FOLDER WHERE YOUR SERVER START IS LOCATED, AND OPEN drawEditorV TO OPEN THE FILE!')
        print(' IF YOU DON\'T SEE A drawEditorV FOLDER, YOU MUST CREATE IT YOURSELF IN ORDER TO SAVE FILES!!!')
        TriggerClientEvent('drawEditorV:ShowBusySpinner', src, 'save', 0, 'Export failed! Check console!', 6)
    end
    io.close()
end)

AddEventHandler('drawEditorV:')

--[[
function drawText(_data, _overrideAlpha)
    SetTextFont(_data.font)
    SetTextProportional(1)
    SetTextScale(0.0, _data.scale)
    SetTextColour(_data.colour.r, _data.colour.g, _data.colour.b, _data.colour.a)
    SetTextDropshadow(_data.dropShadow.dist, _data.dropShadow.r, _data.dropShadow.g, _data.dropShadow.b, _data.dropShadow.a)
    SetTextEdge(_data.edge.dist, _data.edge.r, _data.edge.g, _data.edge.b, _data.edge.a)
    SetTextDropShadow()
    SetTextOutline()
    SetTextJustification(_data.justification)
    SetTextWrap(_data.warp.left, _data.warp.right)
    SetTextEntry("STRING")
    AddTextComponentString(_data.string)
    DrawText(_data.xCoord, _data.yCoord)
end


]]