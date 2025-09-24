# Grid Recipes Command

Create and modify grid recipes for Vintage Story mods. Based on [Vintage Story Grid Recipes Guide](https://wiki.vintagestory.at/Special:MyLanguage/Modding:Grid_Recipes_Guide).

## Quick Start
For mod modification requests, use: @mod-change.md
For JSON patching, use: @json-patch.md
For variants and compatibility, use: @variants-compatibility.md
For dependency management, use: @dependency-management.md

## Basic Recipe Structure

```json
{
  "ingredientPattern": "ABC,DEF,GHI",
  "ingredients": {
    "A": { "type": "item", "code": "game:stick" },
    "B": { "type": "item", "code": "game:rope" },
    "C": { "type": "item", "code": "game:stone-*" }
  },
  "width": 3,
  "height": 3,
  "output": { "type": "item", "code": "yourmod:item", "quantity": 1 }
}
```

## Advanced Recipe Features

### Type-Based Recipes (Variants)
Use wildcards and names for multiple variants:

```json
{
  "ingredientPattern": "L",
  "ingredients": {
    "L": { "type": "block", "code": "game:log-*-ud", "name": "wood" }
  },
  "width": 1,
  "height": 1,
  "output": { "type": "block", "code": "game:planks-{wood}-hor", "quantity": 4 }
}
```

### Trait Requirements
Restrict recipes to specific classes:

```json
{
  "ingredientPattern": "FFS,FF_",
  "requiresTrait": "clothier",
  "ingredients": {
    "F": { "type": "item", "code": "game:flaxtwine" },
    "S": { "type": "item", "code": "game:stick" }
  },
  "width": 3,
  "height": 2,
  "output": { "type": "item", "code": "game:sewingkit" }
}
```

### Shapeless Recipes
For order-independent crafting:

```json
{
  "ingredientPattern": "S,C",
  "ingredients": {
    "S": { "type": "item", "code": "game:paper-parchment" },
    "C": { "type": "block", "code": "game:crate" }
  },
  "shapeless": true,
  "width": 1,
  "height": 2,
  "output": { "type": "block", "code": "game:crate" }
}
```

### Tool Durability Cost
Make tools consume more durability:

```json
{
  "ingredientPattern": "HL_,CL_,_L_",
  "ingredients": {
    "H": { "type": "item", "code": "game:hammer-*", "isTool": true, "toolDurabilityCost": 10 },
    "C": { "type": "item", "code": "game:chisel-*", "isTool": true, "toolDurabilityCost": 10 },
    "L": { "type": "block", "code": "game:log-placed-*-ud", "name": "wood" }
  },
  "width": 3,
  "height": 3,
  "output": { "type": "item", "code": "game:pounder-oak", "quantity": 1 }
}
```

### Returned Stack (Non-Consumed Items)
Keep items but convert them:

```json
{
  "ingredientPattern": "SBS,_L_",
  "ingredients": {
    "L": { "type": "block", "code": "game:linen-*" },
    "S": { "type": "item", "code": "game:powderedsulfur" },
    "B": {
      "type": "block", 
      "code": "game:bowl-honey",
      "returnedStack": { "type": "block", "code": "game:bowl-burned" }
    }
  },
  "width": 3,
  "height": 2,
  "output": { "type": "item", "code": "game:poultice-linen-honey-sulfur", "quantity": 4 }
}
```

### Recipe Groups
Separate recipes on handbook pages:

```json
{
  "ingredientPattern": "S_S,SSS,S_S",
  "ingredients": {
    "S": { "type": "item", "code": "game:stick" }
  },
  "width": 3,
  "height": 3,
  "recipeGroup": 1,
  "output": { "type": "block", "code": "game:ladder-wood-north", "quantity": 3 }
}
```

### Copy Attributes
Copy attributes from ingredients:

```json
{
  "ingredientPattern": "S,C",
  "ingredients": {
    "S": { "type": "item", "code": "game:paper-parchment" },
    "C": { "type": "block", "code": "game:crate" }
  },
  "shapeless": true,
  "copyAttributesFrom": "C",
  "width": 1,
  "height": 2,
  "output": { 
    "type": "block", 
    "code": "game:crate", 
    "attributes": { "label": "paper-empty" } 
  }
}
```

### Hide from Handbook
Hide recipes from "Created by" section:

```json
{
  "ingredientPattern": "H",
  "ingredients": {
    "H": { "type": "block", "code": "game:hay-normal-ud" }
  },
  "showInCreatedBy": false,
  "width": 1,
  "height": 1,
  "output": { "type": "item", "code": "game:drygrass", "quantity": 8 }
}
```

### Liquid Container Requirements
Require specific liquid in containers:

```json
{
  "ingredientPattern": "SBS,_L_",
  "ingredients": {
    "L": { "type": "block", "code": "game:linen-*" },
    "S": { "type": "item", "code": "game:powderedsulfur" },
    "B": { "type": "block", "code": "game:bowl-fired" }
  },
  "attributes": {
    "liquidContainerProps": {
      "requiresContent": { "type": "item", "code": "game:honeyportion" },
      "requiresLitres": 0.25
    }
  },
  "width": 3,
  "height": 2,
  "output": { "type": "item", "code": "game:poultice-linen-honey-sulfur", "quantity": 4 }
}
```

## Ingredient Types

### Item Ingredients
```json
"A": { "type": "item", "code": "game:stick" }
"A": { "type": "item", "code": "game:stick", "quantity": 2 }
"A": { "type": "item", "code": "game:stick-*", "name": "wood" }
```

### Block Ingredients
```json
"B": { "type": "block", "code": "game:log-*-ud", "name": "wood" }
"B": { "type": "block", "code": "game:stone-*" }
```

### Tool Ingredients
```json
"T": { "type": "item", "code": "game:axe-*", "isTool": true }
"T": { "type": "item", "code": "game:hammer-*", "isTool": true, "toolDurabilityCost": 10 }
```

## Output Types

### Item Output
```json
"output": { "type": "item", "code": "yourmod:item", "quantity": 1 }
```

### Block Output
```json
"output": { "type": "block", "code": "yourmod:block", "quantity": 1 }
```

### Block with Attributes
```json
"output": { 
  "type": "block", 
  "code": "yourmod:block", 
  "attributes": { "label": "custom-label" } 
}
```

## Pattern Examples

### 1x1 Pattern
```
"A"
```

### 2x1 Pattern
```
"AB"
```

### 1x2 Pattern
```
"A",
"B"
```

### 2x2 Pattern
```
"AB",
"CD"
```

### 3x3 Pattern
```
"ABC",
"DEF", 
"GHI"
```

### L-Shaped Pattern
```
"A_",
"AB"
```

### T-Shaped Pattern
```
"ABA",
"_B_"
```

## Common Recipe Patterns

### Simple 2x2
```json
{
  "ingredientPattern": "AB,CD",
  "ingredients": {
    "A": { "type": "item", "code": "game:stick" },
    "B": { "type": "item", "code": "game:rope" },
    "C": { "type": "item", "code": "game:stone-*" },
    "D": { "type": "item", "code": "game:leather-normal-plain" }
  },
  "width": 2,
  "height": 2,
  "output": { "type": "item", "code": "yourmod:item" }
}
```

### Cross Pattern
```json
{
  "ingredientPattern": "_A_,ABA,_A_",
  "ingredients": {
    "A": { "type": "item", "code": "game:stick" },
    "B": { "type": "item", "code": "game:rope" }
  },
  "width": 3,
  "height": 3,
  "output": { "type": "item", "code": "yourmod:item" }
}
```

### Border Pattern
```json
{
  "ingredientPattern": "AAA,A_A,AAA",
  "ingredients": {
    "A": { "type": "item", "code": "game:stick" }
  },
  "width": 3,
  "height": 3,
  "output": { "type": "item", "code": "yourmod:item" }
}
```

## Recipe File Location
Place recipe files in: `assets/yourmodid/recipes/grid/`

## Troubleshooting Common Recipe Errors

### Pattern and Size Mismatches
- **Wrong pattern size**: Ensure `width` and `height` match the `ingredientPattern` dimensions
- **Missing ingredients**: All letters in pattern must have corresponding ingredients
- **Extra ingredients**: Don't define ingredients not used in the pattern

### Item Code Issues
- **Incorrect mod IDs**: Verify mod IDs exist and are spelled correctly
- **Wrong item codes**: Check that item codes match the actual mod's item definitions
- **Missing variants**: Ensure variant codes match between ingredients and output

### Variant System Problems
- **Variant mismatches**: Input and output variants must be compatible
- **Missing variant groups**: Check that variant groups are properly defined
- **Incorrect variant syntax**: Use `{variant}` syntax correctly in codes

### Trait and Output Issues
- **Invalid traits**: Ensure trait names match the game's trait system
- **Wrong output codes**: Verify output item codes exist in the target mod
- **Quantity problems**: Check that output quantities are reasonable

### Example Error Fixes
```json
// WRONG: Pattern doesn't match width/height
{
  "ingredientPattern": "ABC,DEF",
  "width": 2,
  "height": 2,  // Should be 3
  "ingredients": { "A": {...}, "B": {...}, "C": {...}, "D": {...}, "E": {...}, "F": {...} }
}

// CORRECT: Pattern matches dimensions
{
  "ingredientPattern": "ABC,DEF",
  "width": 3,
  "height": 2,
  "ingredients": { "A": {...}, "B": {...}, "C": {...}, "D": {...}, "E": {...}, "F": {...} }
}
```

## Integration
- Use @mod-change.md for planning modifications
- Use @json-patch.md for patching existing recipes
- Use @variants-compatibility.md for variant systems
- Use this command for creating new recipes

## Documentation Reference
Full documentation: https://wiki.vintagestory.at/Special:MyLanguage/Modding:Grid_Recipes_Guide
