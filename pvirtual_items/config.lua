local cfg = {}

-- Client
cfg.pos = {
    { cds = vector3(), text = ""},
}

-- Server
cfg.recipes_items = {    
    {      
        perm = "",
        reagents = {'item'} , -- or items {'a','b'}
        reagents_qty = {1}, -- quantity or quantity items {1,2}
        products = {'leite'},
        products_qty = {1}
    },
    {              
        reagents = nil,
        reagents_qty = nil,
        products = {'item'},
        products_qty = {1}
    }
}

return cfg
