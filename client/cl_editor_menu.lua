coreMenuStyle = {titleColor = {255, 255, 255}, subTitleColor = {255, 255, 255}, titleBackgroundSprite = {dict = 'commonmenu', name = 'interaction_bgd'}}
RequestStreamedTextureDict('commonmenu', true)


justifyItems = {"Center", "Left", "Right"}
-- justifyItems2 = {"0", "1", "2"} -- Unused

WarMenu.CreateMenu('editor.ProjectMenu.main', 'drawEditorV', 'Select a project', coreMenuStyle)

WarMenu.CreateMenu('editor.DrawsMenu.main', 'drawEditorV', 'Main Menu', coreMenuStyle)
WarMenu.CreateSubMenu('editor.DrawsMenu.newElement', 'editor.DrawsMenu.main', 'New Element', coreMenuStyle)
WarMenu.CreateSubMenu('editor.DrawsMenu.text', 'editor.DrawsMenu.main', 'Edit Text', coreMenuStyle)
WarMenu.CreateSubMenu('editor.DrawsMenu.rect', 'editor.DrawsMenu.main', 'Edit Rect', coreMenuStyle)
WarMenu.CreateSubMenu('editor.DrawsMenu.img', 'editor.DrawsMenu.main', 'Edit Texture', coreMenuStyle)
WarMenu.CreateSubMenu('editor.DrawsMenu.cam', 'editor.DrawsMenu.main', 'Edit Camera', coreMenuStyle)

AddEventHandler('drawEditorV:OpenProjectMenu', function()
    if not WarMenu.IsAnyMenuOpened() and view == 'project' then
        WarMenu.CloseMenu()
        WarMenu.OpenMenu('editor.ProjectMenu.main')
    end

    while true do
        if WarMenu.Begin('editor.ProjectMenu.main') then
            if project.name ~= 'unk' then
                WarMenu.Button('Continue "'..project.name..'" Project')
                if WarMenu.IsItemSelected() then
                    view = 'draws'
                    clearInstructionalButtons()
                    setInstructionalButtons(instButtonText[view])
                    WarMenu.CloseMenu()
                end
            end

            WarMenu.Button('Start New Project')
            if WarMenu.IsItemSelected() then
                AddTextEntry('EDI_NEW_PRJ', "Project name (will also be the file name): ")
                DisplayOnscreenKeyboard(1, "EDI_NEW_PRJ", "", "", "", "", "", 50)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    if GetOnscreenKeyboardResult() ~= "" then
                        view = 'draws'
                        clearInstructionalButtons()
                        setInstructionalButtons(instButtonText[view])
                        editorStartNewProject(GetOnscreenKeyboardResult())
                        WarMenu.CloseMenu()
                        notify(GetOnscreenKeyboardResult().." project started!", 116)
                    else
                        notify('Please add a name.', 6)
                    end
                end
            end

            WarMenu.Button('Load Existing Project')
            if WarMenu.IsItemHovered() then
                WarMenu.ToolTip('Make sure the project file name is correct, and first line is intact! File extension is also needed!')
            end
            if WarMenu.IsItemSelected() then
                AddTextEntry('EDI_NEW_PRJ', "Project filename (including file extension, CaSe SeNsItIvE)")
                DisplayOnscreenKeyboard(1, "EDI_NEW_PRJ", "", "", "", "", "", 50)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    if GetOnscreenKeyboardResult() ~= "" then
                        result = GetOnscreenKeyboardResult()
                        TriggerServerEvent('drawEditorV:LoadProject', result)
                    else
                        notify('Please specify the name.', 6)
                    end
                end
            end
            WarMenu.End()
        else
            return
        end
        Citizen.Wait(0)
    end
end)

AddEventHandler('drawEditorV:OpenDrawsMenu', function()
    if not WarMenu.IsAnyMenuOpened() and view == 'draws' then
        WarMenu.SetMenuTitle('editor.DrawsMenu.main', project.name)
        WarMenu.SetMenuTitle('editor.DrawsMenu.newElement', project.name)
        WarMenu.OpenMenu('editor.DrawsMenu.main')
    elseif not WarMenu.IsAnyMenuOpened() and view == 'drawEditor' then
        WarMenu.SetMenuTitle('editor.DrawsMenu.textEditor', project.draws[currentDraw].nick)
        WarMenu.OpenMenu('editor.DrawsMenu.'..project.draws[currentDraw].type)
    end

    while true do
        if WarMenu.Begin('editor.DrawsMenu.main') then
            WarMenu.MenuButton('Create new element:', 'editor.DrawsMenu.newElement')
            for i,k in pairs(project.drawNicks) do
                WarMenu.Button('Edit "~y~'..k..'~s~" '..project.draws[k].type)
                if WarMenu.IsItemSelected() then
                    currentDraw = k
                    view = "drawEditor"
                    editedDraw = project.draws[currentDraw]
                    clearInstructionalButtons()
                    setInstructionalButtons(instButtonText[view])
                    WarMenu.CloseMenu()
                    WarMenu.OpenMenu('editor.DrawsMenu.'..project.draws[k].type)
                    WarMenu.SetMenuTitle('editor.DrawsMenu.'..project.draws[k].type, 'Editing "'..k..'"')
                end
            end
            WarMenu.Button('~g~Export Project.~s~')
            if WarMenu.IsItemSelected() then
                --notify("can't do that now.", 6)
                TriggerServerEvent('drawEditorV:ExportProject', project, json.encode(project))
                view = "project"
                WarMenu.CloseMenu()
            end
            WarMenu.Button('~r~Exit Project.~s~')
            if WarMenu.IsItemSelected() then
                view = "project"
                WarMenu.CloseMenu()
            end
            WarMenu.End()
        elseif WarMenu.Begin('editor.DrawsMenu.newElement') then
            WarMenu.Button('Create new text draw')
            if WarMenu.IsItemSelected() then
                AddTextEntry('EDI_NEW_TXT', "Text nickname (NOT TEXT STRING / Will also be the function name): ")
                DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", "", "", "", "", 50)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    --view = 'draws'
                    --clearInstructionalButtons()
                    --setInstructionalButtons(instButtonText[view])
                    local result = GetOnscreenKeyboardResult()
                    if project.draws[GetOnscreenKeyboardResult()] ~= nil then
                        if project.draws[result].type == 'text' then
                            AddTextEntry('EDI_NEW_TXT', "Copying '"..result.."': New text nickname (NOT TEXT STRING / Will also be the function name): ")
                            DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", "", "", "", "", 50)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0);
                                Wait(0);
                            end
                            if (GetOnscreenKeyboardResult()) then
                                local result2 = GetOnscreenKeyboardResult()
                                editorCreateNewTextDraw(result2, result)
                            end
                        else
                            notify('This nickname is already taken.', 6)
                        end
                    else
                        editorCreateNewTextDraw(GetOnscreenKeyboardResult())
                    end
                    --WarMenu.CloseMenu()
                    WarMenu.OpenMenu('editor.DrawsMenu.main')
                end
            end
            WarMenu.Button('Create new rect draw')
            if WarMenu.IsItemSelected() then
                AddTextEntry('EDI_NEW_TXT', "Rect nickname (NOT TEXT STRING / Will also be the function name): ")
                DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", "", "", "", "", 50)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    --view = 'draws'
                    --clearInstructionalButtons()
                    --setInstructionalButtons(instButtonText[view])
                    local result = GetOnscreenKeyboardResult()
                    if project.draws[result] ~= nil then
                        if project.draws[result].type == 'rect' then
                            AddTextEntry('EDI_NEW_TXT', "Copying '"..result.."': New rect nickname (NOT TEXT STRING / Will also be the function name): ")
                            DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", "", "", "", "", 50)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0);
                                Wait(0);
                            end
                            if (GetOnscreenKeyboardResult()) then
                                local result2 = GetOnscreenKeyboardResult()
                                editorCreateNewRectDraw(result2, result)
                            end
                        else
                            notify('This nickname is already taken.', 6)
                        end
                    else
                        editorCreateNewRectDraw(result)
                    end
                    --WarMenu.CloseMenu()
                    WarMenu.OpenMenu('editor.DrawsMenu.main')
                end
            end
            WarMenu.Button('Create new texture draw')
            if WarMenu.IsItemSelected() then
                AddTextEntry('EDI_NEW_TXT', "Texture nickname (NOT TEXT STRING / Will also be the function name): ")
                DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", "", "", "", "", 50)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    --view = 'draws'
                    --clearInstructionalButtons()
                    --setInstructionalButtons(instButtonText[view])
                    local result = GetOnscreenKeyboardResult()
                    if project.draws[result] ~= nil then
                        if project.draws[result].type == 'img' then
                            AddTextEntry('EDI_NEW_TXT', "Copying '"..result.."': New texture nickname (NOT TEXT STRING / Will also be the function name): ")
                            DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", "", "", "", "", 50)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0);
                                Wait(0);
                            end
                            if (GetOnscreenKeyboardResult()) then
                                local result2 = GetOnscreenKeyboardResult()
                                editorCreateNewImgDraw(result2, result)
                            end
                        else
                            notify('This nickname is already taken.', 6)
                        end
                    else
                        editorCreateNewImgDraw(result)
                    end
                    --WarMenu.CloseMenu()
                    WarMenu.OpenMenu('editor.DrawsMenu.main')
                end
            end
            WarMenu.End()
        elseif WarMenu.Begin('editor.DrawsMenu.text') then ---------------------------------------------------------------------------------------
            WarMenu.Button('Change Coords (Mouse)')
            if WarMenu.IsItemSelected() then
                editorView = 'changePos'
                clearInstructionalButtons()
                setInstructionalButtons(instButtonText['changePos'])
                WarMenu.CloseMenu()
            end

            WarMenu.Button('Change Size (Mouse)')
            if WarMenu.IsItemSelected() then
                editorView = 'changeSize'
                clearInstructionalButtons()
                setInstructionalButtons(instButtonText['changeSize'])
                WarMenu.CloseMenu()
            end

            WarMenu.Button('Change String')
            if WarMenu.IsItemSelected() then
                AddTextEntry('EDI_NEW_TXT', "Set String:")
                DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", editedDraw.string, "", "", "", 50)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    editedDraw.string = GetOnscreenKeyboardResult()
                end
            end

            local _, comboBoxIndex = WarMenu.ComboBox('Change Justification', justifyItems, editedDraw.justification + 1)
            if editedDraw.justification ~= (comboBoxIndex - 1) then
                editedDraw.justification = comboBoxIndex - 1
            end

            if WarMenu.CheckBox('Outline?', editedDraw.outline) then
                editedDraw.outline = not editedDraw.outline
            end

            if WarMenu.CheckBox('Drop Shadow?', editedDraw.dropShadow2) then
                editedDraw.dropShadow2 = not editedDraw.dropShadow2
            end

            WarMenu.Button('Change Colour & Alpha')
            if WarMenu.IsItemSelected() then
                AddTextEntry('EDI_NEW_TXT', "Set ~r~RED~s~ color:")
                DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", editedDraw.colour.r, "", "", "", 3)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    editedDraw.colour.r = tonumber(GetOnscreenKeyboardResult())
                    AddTextEntry('EDI_NEW_TXT', "Set ~g~GREEN~s~ color:")
                    DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", editedDraw.colour.g, "", "", "", 3)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                        Wait(0);
                    end
                    if (GetOnscreenKeyboardResult()) then
                        editedDraw.colour.g = tonumber(GetOnscreenKeyboardResult())
                        AddTextEntry('EDI_NEW_TXT', "Set ~b~BLUE~s~ color:")
                        DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", editedDraw.colour.b, "", "", "", 3)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0);
                            Wait(0);
                        end
                        if (GetOnscreenKeyboardResult()) then
                            editedDraw.colour.b = tonumber(GetOnscreenKeyboardResult())
                            AddTextEntry('EDI_NEW_TXT', "Set ALPHA:")
                            DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", editedDraw.colour.a, "", "", "", 3)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0);
                                Wait(0);
                            end
                            if (GetOnscreenKeyboardResult()) then
                                editedDraw.colour.a = tonumber(GetOnscreenKeyboardResult())
                            end
                        end
                    end
                end
            end

            WarMenu.Button('Change Right Coord Wrap')
            if WarMenu.IsItemSelected() then
                editorView = 'changeWrapRight'
                clearInstructionalButtons()
                setInstructionalButtons(instButtonText['changeWrap'])
                WarMenu.CloseMenu()
            end

            WarMenu.Button('Change Left Coord Wrap')
            if WarMenu.IsItemSelected() then
                editorView = 'changeWrapLeft'
                clearInstructionalButtons()
                setInstructionalButtons(instButtonText['changeWrap'])
                WarMenu.CloseMenu()
            end

            WarMenu.Button('Save')
            if WarMenu.IsItemSelected() then
                project.draws[currentDraw] = editedDraw
                currentDraw = 0
                editedDraw = {}
                clearInstructionalButtons()
                view = "draws"
                setInstructionalButtons(instButtonText[view])
                WarMenu.CloseMenu()
                WarMenu.OpenMenu('editor.DrawsMenu.main')
            end
            WarMenu.Button('Cancel')
            if WarMenu.IsItemSelected() then
                view = "draws"
                editedDraw = project.draws[currentDraw]
                currentDraw = 0
                clearInstructionalButtons()
                setInstructionalButtons(instButtonText[view])
                WarMenu.CloseMenu()
                WarMenu.OpenMenu('editor.DrawsMenu.main')
            end
            WarMenu.End()
        elseif WarMenu.Begin('editor.DrawsMenu.rect') then
            WarMenu.Button('Change Coords (Mouse)')
            if WarMenu.IsItemSelected() then
                editorView = 'changePos'
                clearInstructionalButtons()
                setInstructionalButtons(instButtonText['changePos'])
                WarMenu.CloseMenu()
            end
            WarMenu.Button('Change Size (Mouse)')
            if WarMenu.IsItemSelected() then
                editorView = 'changeSize'
                clearInstructionalButtons()
                setInstructionalButtons(instButtonText['changeSize'])
                WarMenu.CloseMenu()
            end
            WarMenu.Button('Change Colour & Alpha')
            if WarMenu.IsItemSelected() then
                AddTextEntry('EDI_NEW_TXT', "Set ~r~RED~s~ color:")
                DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", editedDraw.r, "", "", "", 3)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    editedDraw.r = tonumber(GetOnscreenKeyboardResult())
                    AddTextEntry('EDI_NEW_TXT', "Set ~g~GREEN~s~ color:")
                    DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", editedDraw.g, "", "", "", 3)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                        Wait(0);
                    end
                    if (GetOnscreenKeyboardResult()) then
                        editedDraw.g = tonumber(GetOnscreenKeyboardResult())
                        AddTextEntry('EDI_NEW_TXT', "Set ~b~BLUE~s~ color:")
                        DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", editedDraw.b, "", "", "", 3)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0);
                            Wait(0);
                        end
                        if (GetOnscreenKeyboardResult()) then
                            editedDraw.b = tonumber(GetOnscreenKeyboardResult())
                            AddTextEntry('EDI_NEW_TXT', "Set ALPHA:")
                            DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", editedDraw.a, "", "", "", 3)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0);
                                Wait(0);
                            end
                            if (GetOnscreenKeyboardResult()) then
                                editedDraw.a = tonumber(GetOnscreenKeyboardResult())
                            end
                        end
                    end
                end
            end
            WarMenu.Button('Save')
            if WarMenu.IsItemSelected() then
                project.draws[currentDraw] = editedDraw
                currentDraw = 0
                editedDraw = {}
                clearInstructionalButtons()
                view = "draws"
                setInstructionalButtons(instButtonText[view])
                WarMenu.CloseMenu()
                WarMenu.OpenMenu('editor.DrawsMenu.main')
            end
            WarMenu.Button('Cancel')
            if WarMenu.IsItemSelected() then
                view = "draws"
                editedDraw = project.draws[currentDraw]
                currentDraw = 0
                clearInstructionalButtons()
                setInstructionalButtons(instButtonText[view])
                WarMenu.CloseMenu()
                WarMenu.OpenMenu('editor.DrawsMenu.main')
            end
            WarMenu.End()
        elseif WarMenu.Begin('editor.DrawsMenu.img') then------------------------------------------------------------------
            local pressed, inputText = WarMenu.InputButton('Change Texture Directory', nil, editedDraw.txd)
				if pressed then
					if inputText then
                        RequestStreamedTextureDict(inputText, 1)
						editedDraw.txd = inputText
					end
				end
            local pressed2, inputText2 = WarMenu.InputButton('Change Texture Name', nil, editedDraw.txn)
            if pressed2 then
                if inputText2 then
                    RequestStreamedTextureDict(editedDraw.txd, 1)
                    editedDraw.txn = inputText2
                end
            end
            WarMenu.Button('Change Coords (Mouse)')
            if WarMenu.IsItemSelected() then
                editorView = 'changePos'
                clearInstructionalButtons()
                setInstructionalButtons(instButtonText['changePos'])
                WarMenu.CloseMenu()
            end
            WarMenu.Button('Change Size (Mouse)')
            if WarMenu.IsItemSelected() then
                editorView = 'changeSize'
                clearInstructionalButtons()
                setInstructionalButtons(instButtonText['changeSize'])
                WarMenu.CloseMenu()
            end
            WarMenu.Button('Change Colour & Alpha')
            if WarMenu.IsItemSelected() then
                AddTextEntry('EDI_NEW_TXT', "Set ~r~RED~s~ color:")
                DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", editedDraw.r, "", "", "", 3)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    editedDraw.r = tonumber(GetOnscreenKeyboardResult())
                    AddTextEntry('EDI_NEW_TXT', "Set ~g~GREEN~s~ color:")
                    DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", editedDraw.g, "", "", "", 3)
                    while (UpdateOnscreenKeyboard() == 0) do
                        DisableAllControlActions(0);
                        Wait(0);
                    end
                    if (GetOnscreenKeyboardResult()) then
                        editedDraw.g = tonumber(GetOnscreenKeyboardResult())
                        AddTextEntry('EDI_NEW_TXT', "Set ~b~BLUE~s~ color:")
                        DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", editedDraw.b, "", "", "", 3)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0);
                            Wait(0);
                        end
                        if (GetOnscreenKeyboardResult()) then
                            editedDraw.b = tonumber(GetOnscreenKeyboardResult())
                            AddTextEntry('EDI_NEW_TXT', "Set ALPHA:")
                            DisplayOnscreenKeyboard(1, "EDI_NEW_TXT", "", editedDraw.a, "", "", "", 3)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0);
                                Wait(0);
                            end
                            if (GetOnscreenKeyboardResult()) then
                                editedDraw.a = tonumber(GetOnscreenKeyboardResult())
                            end
                        end
                    end
                end
            end
            WarMenu.Button('Save')
            if WarMenu.IsItemSelected() then
                project.draws[currentDraw] = editedDraw
                currentDraw = 0
                editedDraw = {}
                clearInstructionalButtons()
                view = "draws"
                setInstructionalButtons(instButtonText[view])
                WarMenu.CloseMenu()
                WarMenu.OpenMenu('editor.DrawsMenu.main')
            end
            WarMenu.Button('Cancel')
            if WarMenu.IsItemSelected() then
                view = "draws"
                editedDraw = project.draws[currentDraw]
                currentDraw = 0
                clearInstructionalButtons()
                setInstructionalButtons(instButtonText[view])
                WarMenu.CloseMenu()
                WarMenu.OpenMenu('editor.DrawsMenu.main')
            end
            WarMenu.End()
        else
            return
        end
        Citizen.Wait(0)
    end
end)

function GetCursorPosition()
	if(true) then
		local cursorX, cursorY = GetControlNormal(0, 239), GetControlNormal(0, 240)
		return cursorX, cursorY
	end
end