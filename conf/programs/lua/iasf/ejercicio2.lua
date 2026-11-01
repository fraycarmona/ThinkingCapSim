-- IASF: ejercicio 2 - Escapada del minotauro
-- Estrategia inicial: seguir la pared derecha
-- Medición del tiempo real
inicio = inicio or os.time()
tiempo = os.time() - inicio
-- Leer los grupos de sensores
local groups = tc.getGroups()
local group0 = groups.group0  -- izquierda
local group1 = groups.group1  -- diagonal izquierda
local group2 = groups.group2  -- frente
local group3 = groups.group3  -- diagonal derecha
local group4 = groups.group4  -- derecha

-- Movimiento por defecto: avanzar recto
local vlin = 0.30
local vlat = 0.0
local vrot = 0.0

if group2 == nil or group3 == nil or group4 == nil then
    -- Si aún no hay datos de los sensores, permanecer parado
    vlin = 0.0

elseif group2 < 0.40 or group3 < 0.30 then
    -- Obstáculo delante o en diagonal derecha
    -- Parar y girar hacia la izquierda
    vlin = 0.0
    vrot = 45.0

elseif group4 < 0.30 then
    -- Pared derecha demasiado cerca: separarse
    vlin = 0.10
    vrot = 20.0

elseif group4 > 0.45 then
    -- Pared derecha demasiado lejos: acercarse
    vlin = 0.10
    vrot = -20.0
end

-- Enviar el movimiento: m/s, m/s y grados/s
tc.setVelocities(vlin, vlat, vrot)