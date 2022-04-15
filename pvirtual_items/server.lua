--[[   
    Codigo original: 
   https://github.com/contatosummerz/vrpex/tree/master/vrp_trafico 
   Codigo adaptado by: Blues.      
   credits: Sighmir e Zé
 ]] 
 -- vRP TUNNEL/PROXY
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")


vRPvi = {}
Tunnel.bindInterface("pvirtual_items", vRPvi)

-- CFG
local cfg = module("pvirtual_items", "config")
local list = cfg.recipes_items

function getMultipleInventoryItems(user_id, items, qtds) -- credits <
  local hasAllItems = false -- variavel boolean para verificar se possui todos os items
  local takenItems = {} -- variavel para contar items tirados do inventory e devolver caso nao possua todos
  for k, v in pairs(items) do -- para cada item da tabela tira eles do inventory
    hasAllItems = vRP.tryGetInventoryItem(user_id, items[k], qtds[k]) -- tira item de re[k] com reqt[k]
    if not hasAllItems then -- se por algum motivo nao tiver um dos itens para esse loop          
      break                 
    end                  
    takenItems[k] = items[k]       
  end
  if not hasAllItems then -- se acabar o loop por que ele nao tinha todos dos itens necessarios
    for k, v in pairs(takenItems) do     
      vRP.giveInventoryItem(user_id, v, qtds[k]) -- devolve itens que foram retirados
    end
  end
  return hasAllItems
end

function checkWeightTypeTable(user_id, items, qtds) -- função para verificar se o player tem espaço para o item
  for k, v in pairs(items) do
    if vRP.getInventoryWeight(user_id) + vRP.getItemWeight(items[k]) * qtds[k] >= vRP.getInventoryMaxWeight(user_id) then 
      TriggerClientEvent('notify:client:SendAlert', source, {
        type = 'avs',
        text = "Espaço insuficiente para esta produção"
      })
      return false
    end
  end
  return true
end

function receiveAllItems(user_id, items, qtds) -- receber os items (percorrendo a tabela).
  for k, v in pairs(items) do 
    vRP.giveInventoryItem(user_id, v, qtds[k])
  end
end
  
function vRPvi.startRecipe(id)  
  local source = source 
  local user_id = vRP.getUserId(source)  
  local acessReagents = list[id].reagents -- Retira o item necessario da tabela.
  local acessReagentsQty = list[id].reagents_qty -- Retira a quantidade respectiva
  local acessProducts = list[id].products -- fornece o item necessario
  local acessProductsQty = list[id].products_qty -- fornece a quantidade respectiva  
  local permRecipe = list[id].perm
  
  if not user_id then return end    
  
  if not (vRP.hasPermission(user_id,permRecipe) or permRecipe == "") then return end
  if not (type(acessProducts) == "table") then return end -- verifica se é uma tabela de itens.
  if not checkWeightTypeTable(user_id,acessProducts,acessProductsQty) then return end -- verifica peso no inventario 
      
  if not acessReagents then -- caso reagentes não seja necessario (nil)
    receiveAllItems(user_id, acessProducts, acessProductsQty)
    vRPclient._playAnim(source, false, {{"mini@repair", "fixing_a_ped"}}, true)
    return true
  end    
                
  if type(acessReagents) == "table" then -- caso reagente seja necessario    
    if not getMultipleInventoryItems(user_id, acessReagents, acessReagentsQty) then return end        
    receiveAllItems(user_id, acessProducts, acessProductsQty)
    vRPclient._playAnim(source, false, {{"mini@repair", "fixing_a_ped"}}, true)
    return true    
  end    

   return false
end
