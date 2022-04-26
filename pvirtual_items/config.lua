local cfg = {}

-- Client
cfg.pos = {
    { cds = vector3(), text = ""},
}

-- Server
cfg.recipes_items = {   
    {      
        permission = "",
        reagents = {
            ['item1'] = 2,
            ['item2'] = 3                           
        },     
        products = { 
            ['produto1'] = 1, 
            ['produto2'] = 2,             
        }       
    },     
    {              
        reagents = {   
            ['item1'] = 1, 
            ['item2'] = 3
        },   
        products = { 
            ['produto'] = 1                     
        }
    }
}

return cfg
