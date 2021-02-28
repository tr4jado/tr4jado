local screen = {guiGetScreenSize()}
local x, y = (screen[1]/1360), (screen[2]/768)

function reMap(posX, in_min, in_max, out_min, out_max)
    return tonumber((posX - in_min) * (out_max - out_min) / (in_max - in_min) + out_min)
end

responsiveMultipler = reMap(screen[1], 1024, 1920, 0.75, 1)

function respc(num)
    return math.ceil(num * responsiveMultipler)
end

local font = {
    [1] = dxCreateFont(':tr4jado_ui/files/fonts/medium.ttf', respc(13), false, 'cleartype_natural'),
    [2] = dxCreateFont(':tr4jado_ui/files/fonts/regular.ttf', respc(12), false, 'cleartype_natural'),
    [3] = dxCreateFont(':tr4jado_ui/files/fonts/icons2.otf', respc(50), false, 'antialiased'),
}


function dx()
    dxDrawRectangleRounded(1086, 259, 264, 250, '1', tocolor(26, 26, 26, 240))
    dxDrawRectangleRounded(1086, 259, 264, 35, '2', tocolor(18, 18, 18, 240))
    dxDrawText('', x*1158, y*307, x*1278, y*417, tocolor(255, 255, 255, 255), 1.00, font[3], 'center', 'center', false, false, false, false, false)
    dxDrawText('Modesty Discord', x*1086, y*259, x*1350, y*294, tocolor(255, 255, 255, 255), 1.00, font[1], 'center', 'center', false, false, false, false, false)

    dxDrawRectangleRounded(1096, 429, 244, 50, '3', (isCursorPosition(x*1096, y*429, x*244, y*50) and tocolor(0, 170, 255, 240) or tocolor(18, 18, 18, 240)))
    dxDrawText('Copiar', x*1096, y*429, x*1340, y*479, tocolor(255, 255, 255, 255), 1.00, font[2], 'center', 'center', false, false, false, false, false)
end

addEvent('tr4jadoDiscordOpen', true)
addEventHandler('tr4jadoDiscordOpen', getRootElement(),
    function()
        if not isEventHandlerAdded('onClientRender', getRootElement(), dx) then
            addEventHandler('onClientRender', getRootElement(), dx)
            showCursor((not isCursorShowing()))
        else
            removeEventHandler('onClientRender', getRootElement(), dx)
            showCursor(false)
        end
    end
)

bindKey('backspace', 'down',
    function()
        if isEventHandlerAdded('onClientRender', getRootElement(), dx) then
            removeEventHandler('onClientRender', getRootElement(), dx)
            local sound = playSound(':tr4jado_ui/files/sounds/click2.ogg')
            showCursor(false)
        end
    end
)

addEventHandler('onClientClick', getRootElement(),
    function(_, state)
        if (state == 'down') and (isEventHandlerAdded('onClientRender', getRootElement(), dx)) then
            if isCursorPosition(x*1096, y*429, x*244, y*50) then
                setClipboard(CONFIG.discordLink)
                local sound = playSound(':tr4jado_ui/files/sounds/click.ogg')
                triggerServerEvent('tr4jadoDiscordNotify', localPlayer, localPlayer, 1)
            end
        end
    end
)

function dxDrawRectangleRounded(posX, posY, posW, posH, type, color)
    dxDrawRectangle(x*posX, y*posY, x*posW, y*posH, color)
    if (type == '1') then
        dxDrawRectangle(x*(posX + 1), y*(posY - 1), x*(posW - 2), y*1, color)
        dxDrawRectangle(x*(posX + 2), y*(posY - 2), x*(posW - 4), y*1, color)
        dxDrawRectangle(x*(posX + 1), y*(posY + posH), x*(posW - 2), y*1, color)
        dxDrawRectangle(x*(posX + 2), y*(posY + posH + 1), x*(posW - 4), y*1, color)
    elseif (type == '2') then
        dxDrawRectangle(x*(posX + 1), y*(posY - 1), x*(posW - 2), y*1, color)
        dxDrawRectangle(x*(posX + 2), y*(posY - 2), x*(posW - 4), y*1, color)
    elseif (type == '3') then
        dxDrawRectangle(x*(posX + 1), y*(posY - 1), x*(posW - 2), y*1, color)
        dxDrawRectangle(x*(posX + 1), y*(posY + posH), x*(posW - 2), y*1, color)
    end
end

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if (type(sEventName) == 'string') and (isElement(pElementAttachedTo)) and (type(func) == 'function') then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
        if (type(aAttachedFunctions) == 'table') and (#aAttachedFunctions > 0) then
            for _, v in ipairs(aAttachedFunctions) do
                if (v == func) then
                    return true
                end
            end
        end
    end
    return false
end

function isCursorPosition(posX, posY, posW, posH)
    if (not isCursorShowing()) then
        return false
    end
    local mX, mY = getCursorPosition()
    cursorX, cursorY = mX*screen[1], mY*screen[2]
    if (cursorX > posX) and (cursorX < posX + posW) and (cursorY > posY) and (cursorY < posY + posH) then
        return true
    else
        return false
    end
end