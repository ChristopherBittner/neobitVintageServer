# Variants & Compatibility Command

Create variants and ensure mod compatibility for Vintage Story. Based on [Vintage Story Variants](https://wiki.vintagestory.at/Special:MyLanguage/Modding:Variants) and [CompatibilityLib](https://wiki.vintagestory.at/Special:MyLanguage/Modding:CompatibilityLib) documentation.

## Quick Start
For mod modification requests, use: @mod-change.md
For creating recipes, use: @grid-recipes.md
For JSON patching, use: @json-patch.md
For dependency management, use: @dependency-management.md

## Variants System

### Basic Variant Groups
Create multiple variants of items/blocks with shared functionality:

```json
{
  "code": "hammer",
  "variantgroups": [
    { 
      "code": "metal", 
      "states": ["copper", "tinbronze", "bismuthbronze", "blackbronze", "gold", "silver", "iron", "meteoriciron", "steel"] 
    }
  ]
}
```

### Multiple Variant Groups
Create combinations of variants:

```json
{
  "code": "seashell",
  "variantgroups": [
    { "code": "type", "states": ["scallop", "sundial", "turritella", "clam", "conch", "seastar", "volute"] },
    { "code": "color", "states": ["latte", "plain", "seafoam", "darkpurple", "cinnamon", "turquoise"] }
  ]
}
```

### World Properties Variants
Load variants from world properties:

```json
{
  "variantgroups": [
    { "code": "rock", "loadFromProperties": "block/rock" }
  ]
}
```

### Skip Specific Variants
Exclude unwanted combinations:

```json
{
  "variantgroups": [
    { "code": "type", "states": ["scallop", "clam", "conch"] },
    { "code": "color", "states": ["latte", "turquoise"] }
  ],
  "skipVariants": [
    "seashell-clam-turquoise"
  ]
}
```

### Allow Specific Variants
Create only selected variants:

```json
{
  "variantgroups": [
    { "code": "type", "states": ["scallop", "clam", "conch"] },
    { "code": "color", "states": ["latte", "turquoise"] }
  ],
  "allowVariants": [
    "seashell-scallop-latte",
    "seashell-clam-latte",
    "seashell-conch-turquoise"
  ]
}
```

## Variant Substitutions

### Wildcards in Codes
Use `*` for any variant:

```json
{
  "code": "hammer-*",
  "texturesByType": {
    "*": {
      "metal": { "base": "block/metal/ingot/{metal}" }
    }
  }
}
```

### Variant Group Substitutions
Use `{variantgroup}` syntax:

```json
{
  "code": "seashell-{type}-{color}",
  "texturesByType": {
    "*": {
      "type": { "base": "item/seashell/{type}" },
      "color": { "base": "item/seashell/{color}" }
    }
  }
}
```

## ByType Properties

### Tool Tier by Type
Different tool tiers for different variants:

```json
{
  "tooltierbytype": {
    "*-copper": 2,
    "*-gold": 2,
    "*-silver": 2,
    "*-bismuthbronze": 3,
    "*-tinbronze": 3,
    "*-blackbronze": 3,
    "*-iron": 4,
    "*-meteoriciron": 4,
    "*-steel": 5
  }
}
```

### Durability by Type
Different durability for different variants:

```json
{
  "durabilitybytype": {
    "hammer-stone": 60,
    "hammer-gold": 250,
    "hammer-silver": 250,
    "hammer-copper": 500,
    "hammer-tinbronze": 750,
    "hammer-bismuthbronze": 900,
    "hammer-blackbronze": 1100,
    "hammer-iron": 1800,
    "hammer-meteoriciron": 2100,
    "hammer-steel": 4500
  }
}
```

### Attack Power by Type
Different attack power for different variants:

```json
{
  "attackpowerbytype": {
    "hammer-stone": 1,
    "hammer-copper": 1.25,
    "hammer-gold": 1.5,
    "hammer-silver": 1.5,
    "hammer-bismuthbronze": 1.5,
    "hammer-tinbronze": 1.75,
    "hammer-blackbronze": 2,
    "hammer-iron": 2.25,
    "hammer-meteoriciron": 2.35,
    "hammer-steel": 2.5
  }
}
```

### Textures by Type
Different textures for different variants:

```json
{
  "texturesByType": {
    "*": {
      "metal": { "base": "block/metal/ingot/{metal}" },
      "wood": { "base": "item/tool/material/wood" }
    }
  }
}
```

## Mod Compatibility

### CompatibilityLib Integration
Ensure mods work together without conflicts:

```json
{
  "type": "content",
  "modid": "yourmod",
  "name": "Your Mod",
  "dependencies": {
    "game": "1.21.1",
    "compatibilitylib": "1.0.0"
  }
}
```

### Cross-Mod Variants
Create variants that work with other mods:

```json
{
  "variantgroups": [
    { 
      "code": "material", 
      "states": ["wood", "stone", "iron", "steel", "modded-material"] 
    }
  ],
  "texturesByType": {
    "*": {
      "material": { 
        "base": "item/tool/{material}",
        "alternates": [
          { "base": "item/tool/modded/{material}", "when": "modded-material" }
        ]
      }
    }
  }
}
```

### Recipe Compatibility
Ensure recipes work with variant systems:

```json
{
  "ingredientPattern": "H",
  "ingredients": {
    "H": { 
      "type": "item", 
      "code": "game:hammer-*",
      "name": "material"
    }
  },
  "width": 1,
  "height": 1,
  "output": { 
    "type": "item", 
    "code": "yourmod:tool-{material}" 
  }
}
```

### Cross-Mod Recipe Integration
Common patterns for integrating with other mods:

```json
// Wilderlands Waymarkers buoylantern example
{
  "ingredientPattern": "TL_,PGP,FRS",
  "ingredients": {
    "T": { "type": "item", "code": "game:torch-burning" },
    "L": { "type": "item", "code": "game:rope" },
    "P": { "type": "block", "code": "game:plank-*", "name": "wood" },
    "G": { "type": "item", "code": "game:fat" },
    "F": { "type": "item", "code": "game:fat" },
    "R": { "type": "item", "code": "game:rope" },
    "S": { "type": "block", "code": "game:stone-*" }
  },
  "width": 3,
  "height": 3,
  "output": { 
    "type": "block", 
    "code": "wwaymarkers:buoylantern-{wood}" 
  }
}
```

## Common Variant Patterns

### Metal Tools
```json
{
  "code": "tool",
  "variantgroups": [
    { "code": "metal", "states": ["copper", "tinbronze", "bismuthbronze", "blackbronze", "gold", "silver", "iron", "meteoriciron", "steel"] }
  ],
  "tooltierbytype": {
    "*-copper": 2, "*-gold": 2, "*-silver": 2,
    "*-bismuthbronze": 3, "*-tinbronze": 3, "*-blackbronze": 3,
    "*-iron": 4, "*-meteoriciron": 4, "*-steel": 5
  }
}
```

### Wood Variants
```json
{
  "code": "plank",
  "variantgroups": [
    { "code": "wood", "loadFromProperties": "block/wood" }
  ],
  "texturesByType": {
    "*": {
      "wood": { "base": "block/wood/plank/{wood}" }
    }
  }
}
```

### Colored Items
```json
{
  "code": "dyed-cloth",
  "variantgroups": [
    { "code": "color", "states": ["red", "blue", "green", "yellow", "purple", "orange", "black", "white"] }
  ],
  "texturesByType": {
    "*": {
      "color": { "base": "item/cloth/{color}" }
    }
  }
}
```

## Advanced Variant Features

### Conditional Variants
Create variants based on conditions:

```json
{
  "variantgroups": [
    { "code": "type", "states": ["normal", "enchanted", "cursed"] }
  ],
  "texturesByType": {
    "*": {
      "type": { 
        "base": "item/weapon/{type}",
        "alternates": [
          { "base": "item/weapon/{type}-glow", "when": "enchanted" },
          { "base": "item/weapon/{type}-dark", "when": "cursed" }
        ]
      }
    }
  }
}
```

### Variant-Specific Behaviors
Different behaviors for different variants:

```json
{
  "behaviors": [
    { "name": "GroundStorable" },
    { 
      "name": "Enchanted", 
      "when": "enchanted"
    },
    { 
      "name": "Cursed", 
      "when": "cursed"
    }
  ]
}
```

## Troubleshooting Variants

### Common Issues
- **Missing variants**: Check variant group definitions
- **Wrong textures**: Verify `texturesByType` paths
- **Recipe conflicts**: Ensure variant codes match
- **Performance issues**: Use `skipVariants` or `allowVariants` to limit combinations

### Debugging Tips
1. Check variant group syntax
2. Verify state names match exactly
3. Test with simple variants first
4. Use console commands to list variants

## Integration with Other Commands

### Recipe Integration
Use variants in recipes with @grid-recipes.md:

```json
{
  "ingredientPattern": "H",
  "ingredients": {
    "H": { "type": "item", "code": "game:hammer-*", "name": "metal" }
  },
  "output": { "type": "item", "code": "yourmod:tool-{metal}" }
}
```

### Patching Integration
Patch variants with @json-patch.md:

```json
{
  "file": "yourmod:itemtypes/tool/hammer",
  "op": "addmerge",
  "path": "/variantgroups/0/states/-",
  "value": "titanium"
}
```

## Final Step: Pack and Install
**ALWAYS run the pack and install script after creating variants or compatibility features:**

```bash
./pack_and_install.sh
```

This will:
- Package the mod into a ZIP file
- Install it to the Vintage Story mods directory
- Update the mod version automatically

**Important**: This step is mandatory after every variant/compatibility session.

## Documentation References
- [Vintage Story Variants](https://wiki.vintagestory.at/Special:MyLanguage/Modding:Variants)
- [CompatibilityLib](https://wiki.vintagestory.at/Special:MyLanguage/Modding:CompatibilityLib)
- [Grid Recipes Guide](https://wiki.vintagestory.at/Special:MyLanguage/Modding:Grid_Recipes_Guide)
- [JSON Patching](https://wiki.vintagestory.at/Modding:JSON_Patching)
