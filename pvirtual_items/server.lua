--[[   
    Codigo original: 
   https://github.com/contatosummerz/vrpex/tree/master/vrp_trafico 
   Codigo adaptado by: Blues.      
   credits: Sighmir e Zé
 ]] -- vRP TUNNEL/PROXY
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
vRPvi = {}
Tunnel.bindInterface("pvirtual_items", vRPvi)

-- CFG
local cfg = module("pvirtual_items", "config")
local list = cfg.recipes_items

function removeInventoryItems(user_id, items) 
  local removedItems = {}
  for k, v in pairs(items) do
    local itemRemoved = vRP.tryGetInventoryItem(user_id, k, v)
    if not itemRemoved then
      insertInventoryItems(user_id, removedItems)
      return false
    end      
    removedItems[k] = items[k]
  end   
  return true
end  

function insertInventoryItems(user_id, items)
  for k, v in pairs(items) do 
      vRP.giveInventoryItem(user_id, k, v)
  end
end

function checkWeightTypeTable(user_id, items)   
  if not items then return end   
  for k, v in pairs(items) do    
    if vRP.getInventoryWeight(user_id) + vRP.getItemWeight(k) * v > vRP.getInventoryMaxWeight(user_id) then         
      return false
    end
  end
  return true
end

function vRPvi.startRecipe(id)
  local source = source
  local user_id = vRP.getUserId(source)
  if user_id == nil then return end   
 
  local acessReagents = list[id].reagents  
  if acessReagents ~= nil and type(acessReagents) ~= "table" then
    TriggerClientEvent('notify:client:SendAlert', source, { type = 'erro',  text = "Este farm não pode ser realizado." })   
    return false
  end
  local acessProducts = list[id].products 
   
  local acessRecipe = list[id].permission
  if not (vRP.hasPermission(user_id, acessRecipe) and checkWeightTypeTable(user_id, acessProducts)) then
    TriggerClientEvent('notify:client:SendAlert', source, { type = 'erro',  text = "Você não tem permissão ou sua mochila está cheia" })       
    return
  end

  if type(acessReagents) == "table" then 
    if not removeInventoryItems(user_id, acessReagents) then
      return
    end
  end

  insertInventoryItems(user_id, acessProducts)
  vRPclient._playAnim(source, false, {{"mini@repair", "fixing_a_ped"}}, true)
  return true

end

