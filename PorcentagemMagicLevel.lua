-- Variáveis para armazenar o progresso inicial e posição da HUD
local initialMagicLevel = Player.getSkills().magic
local initialMagicProgress = Player.getSkills().magicPercent  -- Progresso inicial
local savedX, savedY = 100, 100  -- Posição padrão inicial

-- Função para carregar a posição salva da HUD
local function loadSavedPosition()
    -- Carregar a posição salva (exemplo fictício, substituir pelo método de armazenamento persistente se disponível)
    -- Aqui estamos simulando o carregamento, substitua com o método de recuperação de posição salva
    savedX = savedX or 100
    savedY = savedY or 100
end

-- Carrega a posição salva ao iniciar
loadSavedPosition()

-- Função para atualizar o texto com o Magic Level e progresso
local function updateMagicLevelHUDText(hudTextElement)
    local skills = Player.getSkills()
    local magicLevel = skills.magic
    local magicProgress = 100 - skills.magicPercent  -- Quanto falta para o próximo nível

    -- Formata o texto com cores para diferenciar Magic Level atual e inicial
    local hudText = string.format("<font color='red'>Magic Level Atual: %d (Falta %d%%)</font><br><font color='green'>Inicial: ML %d (%d%%)</font>",
        magicLevel, magicProgress, initialMagicLevel, initialMagicProgress)
    
    -- Atualiza o texto na HUD
    hudTextElement:setText(hudText)
end

-- Cria a HUD de ícone e a HUD de texto para o Magic Level e progresso na posição salva
local MAGIC_ICON = HUD.new(savedX, savedY, 35290)  -- Ícone do item Magic Level
local MAGIC_TEXT = HUD.new(savedX + 130, savedY, "Magic Level: Calculando...")  -- HUD de texto ao lado do ícone

-- Configurações de estilo para o texto
MAGIC_TEXT:setColor(255, 0, 0)  -- Define o texto inicial em vermelho para o Magic Level atual
MAGIC_TEXT:setFontSize(12)

-- Função para sincronizar o movimento do texto com o ícone
local function syncTextPosition()
    local iconPos = MAGIC_ICON:getPos()
    MAGIC_TEXT:setPos(iconPos.x + 130, iconPos.y)  -- Mantém o texto à direita do ícone
end

-- Função para salvar a posição atual do ícone
local function saveHUDPosition()
    local iconPos = MAGIC_ICON:getPos()
    savedX, savedY = iconPos.x, iconPos.y
    -- Substitua a linha abaixo pelo método de armazenamento persistente para salvar as variáveis savedX e savedY
    print("Posição da HUD salva em:", savedX, savedY)
end

-- Torna o ícone arrastável, sincroniza o movimento do texto e salva a posição ao soltar
MAGIC_ICON:setDraggable(true)
MAGIC_ICON:setCallback(function()
    syncTextPosition()
    saveHUDPosition()
end)

-- Atualiza o texto da HUD uma vez para exibir as informações iniciais
updateMagicLevelHUDText(MAGIC_TEXT)

-- Configura o temporizador para atualizar o HUD de texto a cada 1 segundo e manter o movimento sincronizado
local hudTimer = Timer.new("hudUpdateTimer", function()
    updateMagicLevelHUDText(MAGIC_TEXT)
    syncTextPosition()
end, 1000)

-- Inicia o temporizador
hudTimer:start()

-- Função para destruir a HUD e parar o temporizador quando não for mais necessário
local function destroyMagicLevelHUD()
    MAGIC_ICON:destroy()
    MAGIC_TEXT:destroy()
    hudTimer:stop()
    destroyTimer("hudUpdateTimer")
    print("HUD de Magic Level removido e temporizador parado")
end

-- Exemplo de chamada para destruir o HUD
-- destroyMagicLevelHUD()
