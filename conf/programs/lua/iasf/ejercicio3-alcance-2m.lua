-- IASF: ejercicio 3 - El cancerbero
-- Control reactivo sencillo con deteccion delantera y trasera

-- Leer los grupos de sensores
local groups = tc.getGroups()

local group0 = groups.group0  -- izquierda
local group1 = groups.group1  -- diagonal izquierda
local group2 = groups.group2  -- frente
local group3 = groups.group3  -- diagonal derecha
local group4 = groups.group4  -- derecha
local group5 = groups.group5  -- detras

-- Movimiento normal: avanzar recto
local vlin = 0.20
local vlat = 0.0
local vrot = 0.0

-- Variables para observar en el Lua Monitor
distancia_frontal = group2
distancia_trasera = group5

if group0 == nil or group1 == nil or group2 == nil
    or group3 == nil or group4 == nil or group5 == nil then

    -- Si no hay datos de los sensores, permanecer parado
    vlin = 0.0

elseif group2 < 0.50 then

    -- Obstaculo muy cerca delante: parar y girar
    vlin = 0.0

    if group1 > group3 then
        vrot = 90.0
    else
        vrot = -90.0
    end

elseif group2 < 1.20 then

    -- Obstaculo delante: reducir velocidad y girar
    vlin = 0.20

    if group1 > group3 then
        vrot = 45.0
    else
        vrot = -45.0
    end

elseif group1 < 0.40 then

    -- Obstaculo en diagonal izquierda
    vlin = 0.10
    vrot = -50.0

elseif group3 < 0.40 then

    -- Obstaculo en diagonal derecha
    vlin = 0.10
    vrot = 50.0

elseif group0 < 0.40 then

    -- Obstaculo a la izquierda
    vlin = 0.20
    vrot = -15.0

elseif group4 < 0.40 then

    -- Obstaculo a la derecha
    vlin = 0.10
    vrot = 20.0

elseif group5 < 1.20 then

    -- Algo esta cerca por detras: avanzar e intentar apartarse
    vlin = 0.20

    if group1 > group3 and group0 > 0.40 then
        vrot = 45.0       -- girar hacia la izquierda

    elseif group4 > 0.40 then
        vrot = -45.0      -- girar hacia la derecha
    end
end

-- Enviar velocidades: m/s, m/s y grados/s
tc.setVelocities(vlin, vlat, vrot)