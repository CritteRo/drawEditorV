menuStyle = {titleColor = {255, 255, 255}, subTitleColor = {255, 255, 255}, --[[titleBackgroundSprite = {dict = 'commonmenu', name = 'interaction_bgd'}]]}

WarMenu.CreateMenu('editor.ProjectMenu.main', 'drawEditorV', 'Select a project', menuStyle)

WarMenu.CreateMenu('editor.DrawsMenu.main', 'drawEditorV', 'Main Menu')
WarMenu.CreateSubMenu('editor.DrawsMenu.textEditor', 'editor.DrawsMenu.main', 'Edit Text')

AddEventHandler('drawEditorV:OpenProjectMenu', function()
    if not WarMenu.IsAnyMenuOpened() and view == 'project' then
        WarMenu.CloseMenu()
        WarMenu.OpenMenu('editor.ProjectMenu.main')
    end

    while true do
        if WarMenu.Begin('editor.ProjectMenu.main') then

            WarMenu.Button('Start New Project')
            if WarMenu.IsItemSelected() then
                AddTextEntry('EDI_NEW_PRJ', "Project name (will also be the file name): ")
                DisplayOnscreenKeyboard(1, "EDI_NEW_PRJ", "", "", "", "", "", 50)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    view = 'draws'
                    clearInstructionalButtons()
                    setInstructionalButtons(instButtonText[view])
                    editorStartNewProject(GetOnscreenKeyboardResult())
                    WarMenu.CloseMenu()
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
        WarMenu.OpenMenu('editor.DrawsMenu.main')
    elseif not WarMenu.IsAnyMenuOpened() and view == 'drawEditor' then
        WarMenu.SetMenuTitle('editor.DrawsMenu.textEditor', project.draws[currentDraw].nick)
        WarMenu.OpenMenu('editor.DrawsMenu.textEditor')
    end

    while true do
        if WarMenu.Begin('editor.DrawsMenu.main') then
            for i,k in pairs(project.drawNicks) do
                WarMenu.Button('Edit "~y~'..k..'~s~"')
                if WarMenu.IsItemSelected() then
                    currentDraw = k
                    view = "drawEditor"
                    clearInstructionalButtons()
                    setInstructionalButtons(instButtonText[view])
                    WarMenu.CloseMenu()
                    WarMenu.OpenMenu('editor.DrawsMenu.textEditor')
                end
            end
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
                    editorCreateNewTextDraw(GetOnscreenKeyboardResult())
                    --WarMenu.CloseMenu()
                end
            end
            WarMenu.End()
        elseif WarMenu.Begin('editor.DrawsMenu.textEditor') then
            WarMenu.Button('Go back')
            if WarMenu.IsItemSelected() then
                currentDraw = 0
                clearInstructionalButtons()
                view = "draws"
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