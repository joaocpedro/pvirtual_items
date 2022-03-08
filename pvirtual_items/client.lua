--[[   
    Codigo original: 
   https://github.com/contatosummerz/vrpex/tree/master/vrp_trafico 
   Codigo adaptado by: Blues.      
   credits: Sighmir e Zé
 ]] 
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPvi = Tunnel.getInterface("pvirtual_items")

local cfg = module("pvirtual_items", "config")
local position = cfg.pos
local procedure = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    Sleep = true
    local pPos = GetEntityCoords(PlayerPedId())
    for placeIndex, placePropertiers in ipairs(position) do
      local vector = placePropertiers.cds -- vector = cdsVec3. v.cds vai pegar o valor de  'CDS'            
      if #(pPos - vector) <= 5 and not procedure then
        Sleep = false
        DrawText3D(vector.x, vector.y, vector.z + 0.3, 'APERTE ~g~E~w~ PARA ' .. placePropertiers.text)
        --		drawTxt("Pressione ~g~E~w~ para "..v.text,4,0.5,0.93,0.45,255,255,255,180)    			
        if #(pPos - vector) <= 1.5 then
          --[[   checkPermInArea(placePropertiers.perm, placeIndex) ]]
          if IsControlJustPressed(0, 38) then
            if vRPvi.startRecipe(placeIndex) then
              procedure = true
              TriggerEvent("progress", 5000, "Produzindo item")
              Wait(5000)
              procedure = false
              ClearPedTasks(PlayerPedId())
            end
          end
        end
      end
    end
    if Sleep then
      Citizen.Wait(1000)
    end
  end
end)

function DrawText3D(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x, y, z, 0)
  DrawText(0.0, 0.0)
  local factor = (string.len(text)) / 370
  DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
  ClearDrawOrigin()
end

