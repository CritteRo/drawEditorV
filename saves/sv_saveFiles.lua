RegisterNetEvent('drawEditorV:ExportProject')
AddEventHandler('drawEditorV:ExportProject', function(project, json)
    local src = source
    --local json = json.encode(project)
    TriggerClientEvent('drawEditorV:ShowBusySpinner', src, 'save', 1, 'Saving ~y~'..project.name..'.draw~s~...')
    local file = assert(io.open("@".. GetCurrentResourceName() .."/output/"..project.name..".draw", 'w+'))
    if file ~= nil then
        file:write(json.."\n--[[ DO NOT REMOVE THE ABOVE LINE. IT'S USED TO LOAD THE PROJECT LATER ]]--\n")
        for i,k in pairs(project.draws) do
            if k.type == 'text' then
                file:write("--[[  :: "..k.nick.." ::  ]]--\nSetTextFont("..k.font..")\nSetTextProportional(1)\nSetTextScale(0.0, "..k.scale..")\n")
                Citizen.Wait(10)
                file:write("SetTextColour("..k.colour.r..", "..k.colour.g..", "..k.colour.b..", "..k.colour.a..")\nSetTextDropshadow("..k.dropShadow.dist..", "..k.dropShadow.r..","..k.dropShadow.g..", "..k.dropShadow.b..", "..k.dropShadow.a..")\n")
                Citizen.Wait(10)
                file:write("SetTextEdge("..k.edge.dist..", "..k.edge.r..","..k.edge.g..", "..k.edge.b..", "..k.edge.a..")\nSetTextJustification("..k.justification..")\nSetTextWrap("..k.wrap.left..", "..k.wrap.right..")\n")
                if k.outline then
                    Citizen.Wait(10)
                    file:write("SetTextOutline()\n")
                end
                if k.dropShadow2 then
                    Citizen.Wait(10)
                    file:write("SetTextDropShadow()\n")
                end
                Citizen.Wait(10)
                file:write("SetTextEntry('STRING')\nAddTextComponentString('"..k.string.."')\nDrawText("..k.xCoord..", "..k.yCoord..")\n--[[  :: END OF "..k.nick.." ::  ]]--\r\n")
            elseif k.type == 'rect' then
                file:write("--[[  :: "..k.nick.." ::  ]]--\nDrawRect("..k.x..", "..k.y..", "..k.width..", "..k.height..", "..k.r..", "..k.g..", "..k.b..", "..k.a..")\n--[[  :: END OF "..k.nick.." ::  ]]--\r\n")
            elseif k.type == 'img' then
                file:write("--[[  :: "..k.nick.." ::  ]]--\nDrawSprite('"..k.txd.."', '"..k.txn.."', "..k.x..", "..k.y..", "..k.width..", "..k.height..", "..k.heading..", "..k.r..", "..k.g..", "..k.b..", "..k.a..")\n--[[  :: END OF "..k.nick.." ::  ]]--\r\n")
            end
        end
        file:write('--[[ TEXT DRAWS BUILT USING drawEditorV for FiveM. Resource created by CritteR ]]--')
        TriggerClientEvent('drawEditorV:ShowBusySpinner', src, 'save', 0, 'Export finished!', 116)
        file:close()
    else
        print(' EXPORTING A FILE TO \\drawEditorV\\filename.lua !!!')
        print(' YOU SHOULD GO TO THE FOLDER WHERE YOUR SERVER START IS LOCATED, AND OPEN drawEditorV TO OPEN THE FILE!')
        print(' IF YOU DON\'T SEE A drawEditorV FOLDER, YOU MUST CREATE IT YOURSELF IN ORDER TO SAVE FILES!!!')
        TriggerClientEvent('drawEditorV:ShowBusySpinner', src, 'save', 0, 'Export failed! Check server console!', 6)
    end
end)

RegisterNetEvent('drawEditorV:LoadProject')
AddEventHandler('drawEditorV:LoadProject', function(name)
    local src = source
    TriggerClientEvent('drawEditorV:ShowBusySpinner', src, 'save', 1, 'Loading ~y~'..name..'~s~...')
    local file=assert(io.open("@".. GetCurrentResourceName() .."/output/"..name, 'r'))
    if file ~= nil then
        json = tostring(file:read())
        --json2 = json.decode(tostring(io.read()))
        TriggerClientEvent('drawEditorV:LoadProject', src, json)
        TriggerClientEvent('drawEditorV:ShowBusySpinner', src, 'save', 0, 'Loading finished!', 116)
        file:close(file)
    else
        -- print(' FAILED LOADING FILE IN "\\drawEditorV\\'..name..'" !!!')
        -- print(' YOU SHOULD GO TO THE FOLDER WHERE YOUR SERVER START IS LOCATED, AND OPEN drawEditorV FOLDER TO CHECK THE FILE NAME!')
        -- print(' FILE NAME NEEDS TO BE EXACT AND CaSe SeNsItIvE!')
        -- print(' IF YOU DON\'T SEE A drawEditorV FOLDER, YOU MUST CREATE IT YOURSELF IN ORDER TO SAVE FILES!!!')
        TriggerClientEvent('drawEditorV:ShowBusySpinner', src, 'save', 0, 'Loading failed! Check server console!', 6)
    end
end)

RegisterNetEvent('drawEditorV:RequestProjects', function()
    local src = source
    local output = GetOutputFiles()

    TriggerClientEvent('drawEditorV:ReceiveProjectList', src, output)

end)

function GetOutputFiles()
    local files = {}
    local dir = io.readdir("@".. GetCurrentResourceName() .."/output")
    for file in dir:lines() do
        table.insert(files, file)
    end
    dir:close()

    return files
end

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
    SetTextWrap(_data.wrap.left, _data.wrap.right)
    SetTextEntry("STRING")
    AddTextComponentString(_data.string)
    DrawText(_data.xCoord, _data.yCoord)
end


]]