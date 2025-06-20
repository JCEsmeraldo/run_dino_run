local M = {}
local timers = {}

-- Adiciona e retorna o ID
function M.performWithDelay(delay, listener, iterations)
    local id = timer.performWithDelay(delay, listener, iterations)
    timers[#timers + 1] = id
    return id
end

function M.cancel(id)
    if id then
        timer.cancel(id)
        -- Remove do nosso array
        for i = #timers, 1, -1 do
            if timers[i] == id then table.remove(timers, i) end
        end
    end
end

function M.pauseAll()
    for _, id in ipairs(timers) do timer.pause(id) end
end

function M.resumeAll()
    for _, id in ipairs(timers) do timer.resume(id) end
end

function M.cancelAll()
    for _, id in ipairs(timers) do timer.cancel(id) end
    timers = {}
end

return M
