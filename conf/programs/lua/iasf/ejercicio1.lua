-- IASF: ejercicio 1 - Limpia suelos
-- Controlador Lua equivalente a la versión Java actual

-- Variables que conservan su valor entre ciclos
extra = extra or 0
dir = dir or 1.0

-- Leer los grupos de sensores
local groups = tc.getGroups()
local group0 = groups.group0  -- izquierda
local group1 = groups.group1  -- diagonal izquierda
local group2 = groups.group2  -- frente
local group3 = groups.group3  -- diagonal derecha
local group4 = groups.group4  -- derecha

-- Valores iniciales de movimiento
local vlin = 0.30
local vlat = 0.0
local vrot = 0.0

if group2 == nil then
    -- Si todavía no hay datos de los sensores, permanecer parado
    vlin = 0.0

elseif group2 < 0.20 or extra > 0 then
    -- Obstáculo frontal: elegir lado y realizar un giro extra
    if extra <= 0 then
        if group1 > group3 then
            dir = 1.0
        else
            dir = -1.0
        end

        extra = math.floor(math.random() * 15)
    else
        extra = extra - 1
    end

    vlin = 0.0
    vrot = dir * 150.0 * (0.7 + 0.3 * math.random())

elseif group1 < 0.20 then
    -- Obstáculo en diagonal izquierda
    vlin = 0.0
    vrot = -30.0

elseif group0 < 0.25 then
    -- Obstáculo a la izquierda
    vlin = 0.2
    vrot = -15.0

elseif group3 < 0.20 then
    -- Obstáculo en diagonal derecha
    vlin = 0.0
    vrot = 30.0

elseif group4 < 0.25 then
    -- Obstáculo a la derecha
    vlin = 0.2
    vrot = 15.0

elseif group2 < 0.30 then
    -- Reducir la velocidad al acercarse de frente
    vlin = 0.15
end

-- Enviar la acción: m/s, m/s y grados/s
tc.setVelocities(vlin, vlat, vrot)