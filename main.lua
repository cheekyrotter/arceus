Arceus = SMODS.current_mod
Arceus.prfx = "{Arceus} "

-- I won't use bulk loading in this library because getting it to work with itself seems like a pain
assert(SMODS.load_file("data/scripts/get_mod.lua"))()
assert(SMODS.load_file("data/scripts/batch_load.lua"))()