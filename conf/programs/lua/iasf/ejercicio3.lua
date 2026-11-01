-- IASF: ejercicio 3 - El cancerbero
-- Primera version: avanzar y evitar obstaculos

-- Leer los grupos de sensores
local groups = tc.getGroups()
local group0 = groups.group0  -- izquierda
local group1 = groups.group1  -- diagonal izquierda
local group2 = groups.group2  -- frente
local group3 = groups.group3  -- diagonal derecha
local group4 = groups.group4  -- derecha

-- Por defecto, avanzar recto
local vlin = 0.20
local vlat = 0.0
local vrot = 0.0

if group0 == nil or group1 == nil or group2 == nil
    or group3 == nil or group4 == nil then

    -- Si aun no hay datos, permanecer parado
    vlin = 0.0

elseif group2 < 0.90 then
    -- Obstaculo delante: parar y girar hacia el lado mas libre
    vlin = 0.30

    if group1 > group3 then
        vrot = 150.0       -- izquierda
    else
        vrot = -150.0      -- derecha
    end

elseif group1 < 0.40 then
    -- Obstaculo en diagonal izquierda: desviarse a la derecha
    vlin = 0.20
    vrot = -50.0

elseif group3 < 0.40 then
    -- Obstaculo en diagonal derecha: desviarse a la izquierda
    vlin = 0.20
    vrot = 50.0

elseif group0 < 0.30 then
    -- Pared u obstaculo demasiado cerca por la izquierda
    vlin = 0.20
    vrot = -15.0

elseif group4 < 0.30 then
    -- Pared u obstaculo demasiado cerca por la derecha
    vlin = 0.20
    vrot = 20.0
end
distancia_frontal = group2

if group2 ~= nil then
    if distancia_anterior ~= nil then
        cambio_frontal = distancia_anterior - group2
    end

    distancia_anterior = group2
end
-- Enviar velocidades: m/s, m/s y grados/s
tc.setVelocities(vlin, vlat, vrot)