Scaleform = {}

function Scaleform.Request(scaleform)
    local scaleform_handle = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform_handle) do
        Citizen.Wait(0)
    end
    return scaleform_handle
end

function Scaleform.CallFunction(scaleform, returndata, the_function, ...)
    BeginScaleformMovieMethod(scaleform, the_function)
    local args = {...}

    if args ~= nil then
        for i = 1,#args do
            local arg_type = type(args[i])

            if arg_type == "boolean" then
                ScaleformMovieMethodAddParamBool(args[i])
            elseif arg_type == "number" then
                if not string.find(args[i], '%.') then
                    ScaleformMovieMethodAddParamInt(args[i])
                else
                    ScaleformMovieMethodAddParamFloat(args[i])
                end
            elseif arg_type == "string" then
                ScaleformMovieMethodAddParamTextureNameString(args[i])
            end
        end

        if not returndata then
            EndScaleformMovieMethod()
        else
            return EndScaleformMovieMethodReturnValue()
        end
    end
end

--[[===---===---===---===---===---===---===---===---===---===---===---===---===---===---===]]--


instButtonText = {
    ['project'] = {
        {input = "~INPUT_ENTER~", text = "Open drawEditorV"},
    },
    ['draws'] = {
        {input = "~INPUT_ENTER~", text = "Open Project Menu"},
    },
    ['drawEditor'] = {
        {input = "~INPUT_ENTER~", text = "Open Editor Menu"},
    },
    ['changePos'] = {
        {input = "~INPUT_ENTER~", text = "Open Editor Menu"},
        {input = "~INPUT_ATTACK~", text = "Move Text"},
    },
    ['changeSize'] = {
        {input = "~INPUT_ENTER~", text = "Open Editor Menu"},
        {input = "~INPUT_VEH_CINEMATIC_UP_ONLY~", text = "Change Size"},
        {input = "~INPUT_VEH_CINEMATIC_DOWN_ONLY~", text = "Change Size"},
    },
    ['changeWarp'] = {
        {input = "~INPUT_ENTER~", text = "Open Editor Menu"},
        {input = "~INPUT_ATTACK~", text = "Edit Warp"},
    },
}


function requestButtonScaleform()
    buttonScaleformId = Scaleform.Request("instructional_buttons")
    DrawScaleformMovieFullscreen(buttonScaleformId, 255, 255, 255, 0, 0)

    Scaleform.CallFunction(buttonScaleformId, false, "SET_BACKGROUND_COLOUR", 0,0,0,80)
    Scaleform.CallFunction(buttonScaleformId, false, "CLEAR_ALL")
    Scaleform.CallFunction(buttonScaleformId, false, "SET_CLEAR_SPACE", 200)
end


function clearInstructionalButtons()
    Scaleform.CallFunction(buttonScaleformId, false, "CLEAR_ALL")
    Scaleform.CallFunction(buttonScaleformId, false, "SET_CLEAR_SPACE", 200)
end

function setInstructionalButtons(setArray)
    for i,k in pairs(setArray) do
        Scaleform.CallFunction(buttonScaleformId, false, "SET_DATA_SLOT",i, k.input, k.text)
    end

    Scaleform.CallFunction(buttonScaleformId, false, "DRAW_INSTRUCTIONAL_BUTTONS")
end