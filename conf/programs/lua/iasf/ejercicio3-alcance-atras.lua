-- IASF: ejercicio 3 - prueba opcional de alcance por detras
-- Los grupos 0 a 4 conservan las direcciones del controlador original.

local groups = tc.getGroups()
local group0 = groups.group0  -- izquierda
local group1 = groups.group1  -- diagonal izquierda
local group2 = groups.group2  -- frente
local group3 = groups.group3  -- diagonal derecha
local group4 = groups.group4  -- derecha
local group5 = groups.group5  -- detras

local vlin = 0.20
local vlat = 0.0
local vrot = 0.0

-- Variables visibles en el monitor. Una lectura menor puede indicar
-- una aproximacion, pero tambien cambia cuando se mueve el robot.
distancia_trasera = group5
se_acerca_por_detras = false
if group5 ~= nil then
    if distancia_trasera_anterior ~= nil then
        cambio_trasero = distancia_trasera_anterior - group5
        if group5 < 1.50 and cambio_trasero > 0.01 then
            se_acerca_por_detras = true
        end
    end
    distancia_trasera_anterior = group5
end

if group0 == nil or group1 == nil or group2 == nil
    or group3 == nil or group4 == nil or group5 == nil then
    vlin = 0.0
elseif group2 < 0.90 then
    vlin = 0.30
    if group1 > group3 then
        vrot = 150.0
    else
        vrot = -150.0
    end
elseif group1 < 0.40 then
    vlin = 0.20
    vrot = -50.0
elseif group3 < 0.40 then
    vlin = 0.20
    vrot = 50.0
elseif group0 < 0.30 then
    vlin = 0.20
    vrot = -15.0
elseif group4 < 0.30 then
    vlin = 0.20
    vrot = 20.0
elseif se_acerca_por_detras then
    -- Solo acelera si las condiciones anteriores dejan el camino libre.
    vlin = 0.30
end

tc.setVelocities(vlin, vlat, vrot)
