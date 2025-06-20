local M = {}

M.ENABLED = false -- Ativa ou desativa TODO o modo desenvolvedor

M.options = {
    noDeath = true,         -- Dino não morre ao colidir
    noFireball = false,     -- Não gera meteoros
    noCollision = false,    -- Ignora qualquer colisão
    infiniteLife = false,   -- Exemplo: pode adicionar outras flags para testes futuros
    debugPrint = true,      -- Ativa prints extras no console
    forceShield = true,    -- Força o escudo a aparecer sempre
}

function M.isEnabled(flag)
    return M.ENABLED and M.options[flag] == true
end

return M
