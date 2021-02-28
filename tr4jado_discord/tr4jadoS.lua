for _, command in ipairs(CONFIG.commands) do
    addCommandHandler(command,
        function(source)
            triggerClientEvent(source, 'tr4jadoDiscordOpen', source)
        end
    )
end

addEvent('tr4jadoDiscordNotify', true)
addEventHandler('tr4jadoDiscordNotify', getRootElement(),
    function(source, number)
        local number = tonumber(number)
        if (number) then
            if (number == 1) then
                exports.tr4jado_ui:addBox(source, 'success', 'Você copiou o link de nosso discord com sucesso.')
            end
        end
    end
)