# Arceus (Libary/Utility Mod)

## About 
This is a library/utility mod that adds:
- Safe and batch loading files
- Auto loading all data files (including semi-automatic crossmod detection)
- Optional error handling for joker functions
- Error UI that provides full tracebacks (currently only for the features mentioned above)
- [UNFINISHED] Config menu maker
- [UNFINISHED] Checking for updates for mods
- [PLANNED] Centralised achievement menu

This is primarily for developers to reduce disruption during testing playtesting.

## Disclaimer

This mod is untested, so ironically this may cause crashes I haven't thought of.
If you encounter any problems,

## Demos



## For Users



## For Developers

I will work on documentation soon, but for now here is a list of available functions (each have LSP definitions for Visual Studio Code).

```lua
Arceus.add_menu_hook(func)
Arceus.add_menu_popup(ui, name)
Arceus.make_overlay(ui)
Arceus.safe_load(name)
Arceus.batch_load(folder, in_data)
Arceus.auto_load()
```

The settings for your mod can be configured as follow (the default settings if left unchanged):

```lua
SMODS.current_mod.arceus_config {
    data_folder = "data/",
    crossmod_folder = "crossmod/",
    crossmod_in_data = true,
    auto_load_exclude = {},
    safe_calc = true
}```

Crossmod loading works by reading each folder name (e.g. crossmod/Cryptid/) and checking if the corresponding mod is loaded.