Config lib mod documentation
# Overview

Config lib is a mod library for modders, that streamlines settings for mods, and provides a player-friendly in-game GUI for changing these settings (including optional input-validation, localized labels and tooltips, as well as widgets like checkbuttons and sliders).

These settings can then be used as tokens in json-patches. This allows content mods to be configurable, without any C# code needed.
Main features

    Define mod-settings in json, including metadata like tooltips, labels, and input-range validations.
    Player-friendly editing of defined settings in an in-game GUI.
    Built-in JSON-patch system that can use the settings as tokens, allowing for configurable changes in content mods without any C# code needed.
    Settings can also be read from C# code, using the built-in C# api, or the event bus.
    Automatically generates a yaml configuration file containing the mod-settings, that also includes comments for increased readability when editing manually.
    Mod-settings can alternatively point to a json-file instead of a yaml-file, making it easier to adapt an existing mod.
    Mods do not need to depend on the library, unless using the C# api. If the library is not installed, default values from assets will be used.

# Examples


Examples
Adding an in-game settings GUI to an existing mod

Using the fileproperty in the configlib-patches.json file, you can instruct ConfigLib to read and write to a specified json-file, instead of creating a new yaml-file for the configurations.

This means that you can add ConfigLib to an existing mod that uses json-files for its configurations, and this then lets the player change the mod-settings from a GUI inside the game, instead of having to edit the configuration file manually.

In the following example, we'll add ConfigLib to an existing mod, in order to let the player edit an existing configuration file using an in-game settings GUI.

(The complete example is also available in the VS-SomniumConfiglibDemoJsonConfig GitHub Repository)

This is the existing SomniumConfiglibDemoJsonConfig.json configuration file used for the example:

{
  "BranchyDropRate": 0.8,
  "LeavesDropRate": 1.0,
  "DiminishingDrops": false,
  "ExtraAxeDamage": true
}

Firstly, ensure that the configlib library is installed and chosen as active in the mod manager when using this feature.

Secondly, create a configlib-patches.json file in a assets subfolder called config (i.e. on the same level as patches, lang, etc).

This file follows the format described in the api-specification above, and the purpose of this file is to link the settings from the existing configuration file to the in-game settings GUI.

Create ConfigLib settings in the file for each setting in the json-configuration file above, following these guidelines:

    The format of the file follows the api-specification above.
    The file property should contain the name of the existing json configuration file (including path if the file is located in a subfolder). This path is relative to the ModConfig folder.
    The value of the code field should match the name and optionally the path of the property in the json-file.
    The type and default should be defined with the same types as in the configuration file.
    Optionally, you can add fields like range as usual, to add additional validations to the values the player can change in the GUI.
    Optionally, you can add separator blocks, and these will be displayed in the GUI.
    Optionally, you can add a ingui property if you want a custom translation key for the setting. Otherwise, the value of code will be used as a translation string if possible.
    In this example the patches section is empty, but you can add patches as normal, using the code of the settings to patch in values from the settings. This means that your mod can also take advantage of the configurable json patch features of Configlib.

Adding entries in configlib-patches.json for each setting in the json configuration file:

{
  "version": 0,
  "file": "SomniumConfiglibDemoJsonConfig.json",
  "patches": {},
  "settings": [
    {
      "type": "separator",
      "title": "TreechopSettings"
    },
    {
      "code": "DiminishingDrops",
      "comment": "DiminishingDropsComment",
      "type": "boolean",
      "default": false
    },
    {
      "code": "ExtraAxeDamage",
      "comment": "ExtraAxeDamageComment",
      "type": "boolean",
      "default": false
    },
    {
      "code": "LeavesDropRate",
      "comment": "LeavesDropRateComment",
      "type": "float",
      "default": 1.0,
      "range": {
        "min": 0.0,
        "max": 1.0
      }
    },
    {
      "code": "BranchyDropRate",
      "comment": "BranchyDropRateComment",
      "type": "float",
      "default": 0.8,
      "range": {
        "min": 0.0,
        "max": 1.0
      }
    }
  ]
}

Finally, you can optionally add translations. The value of code and comment in settings, as well as the title and text in separators, will be used as a translation key if possible, and otherwise will display the untranslated value in the GUI instead.

Adding translations to en.json corresponding to the title, code and comment properties above:

{
  "TreechopSettings": "Configure tree chopping settings",
  "DiminishingDrops": "Diminishing drops",
  "DiminishingDropsComment": "Whether the chance of additional drops should be decreased for each drop. (vanilla: true)",
  "ExtraAxeDamage": "Extra axe damage",
  "ExtraAxeDamageComment": "Whether the durability cost to the axe scales with the number of log blocks harvested. (vanilla: true)",
  "LeavesDropRate": "Leaves drop-rate",
  "LeavesDropRateComment": "Drop rate factor affecting the default drop-rate from each leaves block (vanilla: 1.0)",
  "BranchyDropRate": "Branchy leaves drop-rate",
  "BranchyDropRateComment": "Drop rate factor affecting the default drop-rate from each branchy leaves block (vanilla: 0.8)"
}

# JSON API
somniumtd edited this page on May 14, 2024 · 15 revisions
Documentation of JSON API of Config lib
General description

Config lib is an optional dependency, which means that you don't need to add it to the dependencies list in modinfo. When config lib is not installed, config files just won't be applied and default values in assets themselves will be used. To add config with Config lib you just need to add configlib-patches.json file into assets/your-domain/config/ folder of your mod. This file defines set of settings, patches that change values in your assets, formatting of configuration file. It also specified version. If you want to regenerate config files for players with default values just increase version in your configlib-patches.json file.

Example:

{
  "version": 2,
  "patches": {
    "integer": {
      "maltiezfirearms:itemtypes/ammunition/bullet.json": {
        "behaviors/1/properties/damageTypesByType/*-steel/0/tier": "STEEL_BULLET_TIER"
      }
    }
  },
  "settings": {
    "integer": {
      "STEEL_BULLET_TIER": {
        "name": "steel-bullet-tier",
        "ingui": "maltiezfirearms:setting-steel-bullet-tier",
        "weight": 2.6,
        "comment": "Attack tier of a steel bullet (main usecase against heavily armoured players). It is balanced (at tier 7) to deal more damage to player in fullplate steel armour then lead alternative",
        "default": 7,
        "range": {
          "min": 0,
          "max": 20
        }
      }
    }
  },
  "formatting": [
    {
      "type": "separator",
      "weight": 1.0
    }
  ]
}

Configuration files

Conflig lib allows for content mod to add optional configuration files that can be edited via GUI in-game or directly in ModConfig folder. Configuration files will be autogenerated into ModConfig folder and named domain.yaml where domain is your mod's domain. Config files are in YAML format.

Config files can have version that is used to regenerate old config file with new default values. Also, config files support formatting blocks like titles and separators (that are also displayed in GUI).

Example of configuration file:

version: 2
# Match being put out when player is swimming
match-put-out-by-water: Enabled # value from: Enabled, Disabled
# Chance that schematic will spawn in ruins in chests.Higher number means higher chance to find.But high chance will result in jonas parts becoming rare, cause they share smae stack randomizers.
schematic-spawn-chance: 1 # from 0 to 100 with step of 1
# Multiplies damage caused by firearms projectiles. It is recommended to leave in on 1.0. Default damages are balanced with considiration to vanilla animals and mobs hp values.
damage-multiplier: 1 # from 0.5 to 2
# Lower values correspond to higher accuracy
dispersion-multiplier: 1 # from 0 to 3


########################
### Bayonet settings ###
########################

# Value in description will not change and will show wrong number
bayonet-damage-when-attached: 4.8 # value from: 4.3, 4.8, 5.3
# Affects it effectiveness against armor. Steel falx has 5, all spears have 0. Value in description will not change and will show wrong number.
bayonet-damage-tier-when-attached: 5 # from 0 to 6 with step of 1

Patches

Config lib implements its own patching system. You can patch any assets including JSON patches using settings values. With a patch you can change value in an asset or add a value into array in asset. These patches are meant for configuring existing values, so their functionality is limited. You can patch assets in other mods (or vanilla assets), that can allow you to make a mod that will add configuration to another mod. It can be useful for configuring mods for servers.

Patches has types that define what settings they can use and what values they will patch in. There are: boolean, float, integer, string and other types of patches. They support corresponding types of settings, except for integer and float types, that support any numerical settings and also support math expressions and functions:

pi
e
sin(angle-in-radians)
cos(angle-in-radians)
abs(value)
sqrt(value)
ceiling(value)
floor(value)
exp(value)
log(value)
round(value)
sign(value),
clamp(value, min, max),
max(value),
min(value),
greater(left, right, if-left-greater, if-left-not-greater)
lesser(left, right, if-left-lesser, if-not-left-lesser)
equal(left, right, if-equal, if-not-equal)
notequal(left, right, if-not-equal, if-equal)

Additionally, value can be used in expressions as well. This special keyword will be replaced with the default value of the path when the patch is applied. So for instance, value * 1.1 could be used in an expression, to patch a value to the game's default value + 10%

Example:

"patches": {
    "float": {
      "maltiezfirearms:itemtypes/firearms/musket.json": {
        "behaviors/2/properties/systems/projectile/damageMultiplier": "DAMAGE * 1.63",
        "behaviors/2/properties/systems/aiming/dispersionMin_MOA": "DISPERSION * 60",
        "behaviors/2/properties/systems/melee/attacks/bayonet/damageTypes/0/damage": "BAYONET_DAMAGE",
        "behaviors/2/properties/systems/melee/attacks/bayonet/damageTypes/0/tier": "BAYONET_TIER",
        "behaviors/2/properties/systems/particles/fire/0/intensity": "SMOKE_DENSITY * 1.6",
        "behaviors/2/properties/systems/particles/fire/4/intensity": "FIREBLAST_DENSITY * 1.6"
      },
      "maltiezfirearms:patches/schematics.json": {
        "0/value/chance": "SCHEMATIC_CHANCE"
      }
    }
  }

Settings

Patches use values from settings. Settings are what will be in configuration files and GUI. Settings can be of different types: boolean, float, integer, string and other.

Each setting has some general properties. Let's look at boolean setting that is the simplest one. Setting code is used in patches to refer to a setting.

name is used in YAML config file. It can't have spaces of special characters like :. You can use _ and - to make it more readable.

ingui if defined is used as a translation key for displaying a translation in the GUI window, if it is not set, setting name will be used instead.

weight is used to sort settings in config file and GUI window. Should be greater than 0.

comment if set to a string will be added before setting in config file and as hint in GUI window. If the value is a valid translation key, the translation will be displayed instead.

default default value of a setting, player will be able to reset settings to default values in GUI, also this value will be used to generate new config file.

Example:

"SETTING_CODE": {
    "name": "yaml-code",
    "ingui": "domain:translation-key",
    "weight": 1.0,
    "comment": "some optional comment",
    "default": true
}

boolean and string settings don't have any other fields.

float and integer settings can also have range or values or mapping field, and logarithmic.

In range you can specify maximum value, minimum value, step (that will define the slider step in GUI), or any combination of them.

If both a "min" and a "max" value is given, a slider will be shown for the setting in the GUI.

The GUI will use the range for input validation (setting the value to either the lowest or highest allowed value, if the value entered by the player is outside of the range).

In values you can define a set of available values, and mapping allows you to substitute value with a string in config file and GUI, default should be equal to a valid value from either values or mapping.

Though the fields above do not prevent the user from entering invalid values in config file directly, they are mentioned in autogenerated comments in the config file.

If logarithmic is true, the slider in the GUI will be logarithmic.

"POWDER_CONSUMPTION": {
    "name": "powder-to-flask-ratio",
    "ingui": "maltiezfirearms:setting-powder-to-flask-ratio",
    "weight": 2.3,
    "comment": "How much flask durability one powder item will fill",
    "default": 8,
    "logarithmic": true,
    "range": {
        "min": 1,
        "max": 64,
        "step": 1
    }
},
"BAYONET_DAMAGE": {
    "name": "bayonet-damage-when-attached",
    "ingui": "maltiezfirearms:setting-bayonet-damage-when-attached",
    "weight": 3.1,
    "comment": "Value in description will not change and will show wrong number",
    "default": 4.8,
    "values": [
        4.3,
        4.8,
        5.3
    ]
},
"MATCH_PUT_OUT": {
    "name": "match-put-out-by-water",
    "ingui": "maltiezfirearms:setting-match-put-out-by-water",
    "comment": "Match being put out when player is swimming",
    "default": "Enabled",
    "weight": 0.1,
    "mapping": {
        "Enabled": 1.0,
        "Disabled": 0.0
    }
},

other settings only have mapping additional field, but you can put any JSON token as value in it.
Formatting

You can specify additional blocks in config file and GUI window. They are:

    Separator - adds a line into GUI and 2 empty lines in config file. Weight is used to sort formatting blocks and settings in file and GUI.

{
    "type": "separator",
    "weight": 1.0
}

    Title - separator with title

{
    "type": "separator",
    "title": "Title"
    "weight": 1.0
}

###########
## Title ##
###########

    Text - separator with text

{
    "type": "separator",
    "text": "Some text\nSome more text"
    "weight": 1.0
}

# Some text
# Some more text

Localization

Settings and separators can be displayed as translated text, by providing a translation key:
For settings:

If ingui is specified for a setting, the value will be used as a translation key. If no ingui property is specified, name will be used instead.

If comment is specified for a setting, the value will be used as a translation key if possible. If no translation is found, it will instead display the value as it is written.
For separators:

The text given for the title and text will be used as translation keys if possible. If no translation is found, it will instead show the value as it is written.
Format of translation key:

When specifying a translation key, if no domain prefix is given, it will default to the mod's own domain. For instance, in a mod with mod-id examplemod, the following setting properties:

"ingui": "examplemod:setting-name"

and

"ingui": "setting-name"

would both look in e.g. examplemod:lang/en.json for the translation, looking for a key called setting-name.
Advanced feature: Conditional patches

In a patch, you can use a boolean expresson to choose between multiple values. This allows for more advanced patching - for instance, this can be used to only apply a patch, if the player sets a toggleable setting to true.

Conditional patches use the following syntax:

(<boolean expression>) ? <value used for patching if the expression is true> : <value used for patching if the expression is false>

If numeric, the value can be combined with math operators and expression like any other patches.

Additionally, the word value can be used as a stand-in for the default value from the game files.

As an example, consider the configlib-patches.json file below. This conditional patch lets the player harvest 8 currants every time a bush is harvested, if the boolean setting is toggled to true. If the setting is false, it will instead use the default value (so in this case, a berry bush will drop the amount of berries that is default for the game, i.e. an average of 4.4).

"patches": {
   "float": {
      "game:blocktypes/plant/bigberrybush.json": {
         "behaviorsByType/*-ripe/0/properties/harvestedStack/quantity/avg": "(PLENTIFUL_BERRIES_TOGGLE) ? 8.0 : value"
      }
   }
},
"settings": [
   {
      "code": "PLENTIFUL_BERRIES_TOGGLE",
	  "name": "plentiful-berries-toggle",
	  "type": "boolean",
	  "default": true,
	  "comment": "If toggled, you harvest additional currant berries."
   },
   {
      "code": "PLENTIFUL_BERRY_AMOUNT",
	  "name": "plentiful-berry-amount",
	  "type": "float",
	  "default": 10.0,
	  "comment": "How many currant berries are harvested."
   }
]

A few variations of the example above:
Variant 1: Change the value if the boolean expression is false:

If the patch is changed to

"behaviorsByType/*-ripe/0/properties/harvestedStack/quantity/avg": "(PLENTIFUL_BERRIES_TOGGLE) ? 8.0 : 0.0"

the currant bush will drop 8 berries if the setting is true - but only 0 berries if the setting is false, instead of the default amount.
Variant 2: Use a different setting as the value used to replace the original in the patch:

If the patch is changed to

"behaviorsByType/*-ripe/0/properties/harvestedStack/quantity/avg": "(PLENTIFUL_BERRIES_TOGGLE) ? PLENTIFUL_BERRY_AMOUNT : value"

the currant bush will drop an amount equal to the value of another setting, PLENTIFUL_BERRY_AMOUNT, if the toggle setting is true. I.e. the bush will drop 10.0 berries, and the exact amount can be changed by the player in the mod-settings. If the setting is false, the default number of berries will be harvested, no matter the value of the second setting.
Variant 3: Using math operators to modify the value:

If the patch is changed to

"behaviorsByType/*-ripe/0/properties/harvestedStack/quantity/avg": "(PLENTIFUL_BERRIES_TOGGLE) ? (value + PLENTIFUL_BERRY_AMOUNT) : value"

the currant bush will drop the value of the PLENTIFUL_BERRY_AMOUNT setting added to the default amount, if the toggle setting is true. I.e. the player can choose how many additional currant berries should be harvested, if the toggle is true.