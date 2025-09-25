# Dependency Management Command

Manage mod dependencies for conditional patching and optional mod support in Vintage Story.

## Quick Start
For mod modification requests, use: @mod-change.md
For JSON patching, use: @json-patch.md
For creating recipes, use: @grid-recipes.md
For variants and compatibility, use: @variants-compatibility.md

## Dependency Types

### Required Dependencies
Mods that must be present for your mod to function:

```json
{
  "dependencies": {
    "game": "1.21.1",
    "coremod": "2.0.0"
  }
}
```

**Use for:**
- Core functionality your mod depends on
- Mods that provide essential APIs or systems
- Mods that your mod extends or builds upon

### Optional Dependencies
Mods that can be present or absent - patches apply only if installed:

**Method 1: No Dependencies **
```json
{
  "dependencies": {
    "game": "1.21.1"
  }
}
```

**Method 2: Empty Version Strings (Recommended)**
```json
{
  "dependencies": {
    "game": "1.21.1",
    "optionalmod": ""
  }
}
```

**Use for:**
- Mods you want to patch if they're present
- Optional integrations and compatibility
- Mods that enhance your mod but aren't required

**Note**: Method 1 is preferred as it doesn't require users to have the mods installed at all.

## Conditional Patching Strategy

### How It Works
1. **Patches fail silently** if target mod isn't installed
2. **No errors** are thrown for missing optional mods
3. **Your mod loads normally** regardless of optional mod presence
4. **Patches apply automatically** when target mods are present

### Best Practices

#### 1. Descriptive Patch Filenames
```
patches/
├── fueledwearablelights-traits.json          # Clear target mod
├── electricalprogressiveequipment-traits.json # Clear target mod
└── vinconomy-mercantile-recipes.json         # Clear target mod
```

#### 2. Document Dependencies
```markdown
## Optional Dependencies
This mod provides enhanced functionality when these mods are installed:
- **fueledwearablelights**: Adds trait requirements to wearable lights
- **electricalprogressiveequipment**: Modifies electric equipment recipes
- **vinconomy**: Adds mercantile shop recipes
```

#### 3. Test Both Scenarios
- Test with all optional mods installed
- Test with no optional mods installed
- Verify your mod loads and functions in both cases

## Example Implementation

### modinfo.json
```json
{
  "type": "content",
  "modid": "neobitvintage",
  "name": "neobit Vintage Server",
  "version": "0.0.6",
  "dependencies": {
    "game": "1.21.1"
  }
}
```

### Patch Files
```json
// patches/fueledwearablelights-traits.json
// Only applies if fueledwearablelights mod is present
[
  {
    "file": "fueledwearablelights:recipes/grid/carbidelamp",
    "op": "addmerge",
    "path": "/requiresTrait",
    "value": "prospector",
    "side": "server"
  }
]
```

```json
// patches/electricalprogressiveequipment-traits.json
// Only applies if electricalprogressiveequipment mod is present
[
  {
    "file": "electricalprogressiveequipment:recipes/grid/eaxe",
    "op": "addmerge",
    "path": "/requiresTrait",
    "value": "crafty",
    "side": "server"
  }
]
```

## Common Patterns

### Trait Requirements
Add trait requirements to existing recipes:
```json
{
  "file": "targetmod:recipes/grid/recipe-name",
  "op": "addmerge",
  "path": "/requiresTrait",
  "value": "traitname",
  "side": "server"
}
```

### Ingredient Modifications
Change ingredient quantities or types:
```json
{
  "file": "targetmod:recipes/grid/recipe-name",
  "op": "addmerge",
  "path": "/ingredients/M/quantity",
  "value": 10,
  "side": "server"
}
```

### Recipe Disabling
Disable recipes you want to replace:
```json
{
  "file": "targetmod:recipes/grid/recipe-name",
  "op": "add",
  "path": "/enabled",
  "value": false,
  "side": "server"
}
```

### New Recipes
Create new recipes in your mod's recipe directory:
```json
// recipes/grid/new-recipe.json
[
  {
    "ingredientPattern": "ABC",
    "ingredients": {
      "A": { "type": "item", "code": "game:stick" },
      "B": { "type": "item", "code": "game:rope" },
      "C": { "type": "item", "code": "game:stone" }
    },
    "width": 3,
    "height": 1,
    "requiresTrait": "crafty",
    "output": { "type": "item", "code": "yourmod:newitem" }
  }
]
```

## Troubleshooting

### Common Issues

#### Patches Not Applying
- **Check mod ID**: Ensure target mod ID is correct
- **Verify file path**: Check that the target file exists in the mod
- **Test mod presence**: Confirm the target mod is actually installed

#### Mod Not Loading
- **Required dependency missing**: Check that all required dependencies are installed
- **Version conflicts**: Ensure dependency versions are compatible
- **Mod ID conflicts**: Verify no duplicate mod IDs

#### Silent Failures
- **Normal behavior**: Patches failing silently for missing optional mods is expected
- **Check logs**: Look for actual errors vs. expected silent failures
- **Test functionality**: Verify your mod works with and without optional mods

### Debugging Steps
1. **Check modinfo.json**: Verify dependency declarations
2. **Test with minimal setup**: Load only your mod and required dependencies
3. **Add optional mods one by one**: Test each integration separately
4. **Check game logs**: Look for actual errors (not silent patch failures)

## Integration with Other Commands

### Planning Dependencies
Use @mod-change.md to plan which mods need to be required vs optional.

### Creating Patches
Use @json-patch.md to create the actual patch files for optional mods.

### Recipe Creation
Use @grid-recipes.md to create new recipes that work with optional mods.

### Variant Systems
Use @variants-compatibility.md to handle variant-based recipes across mods.

## Advanced Techniques

### Conditional Recipe Creation
Create recipes that only appear when specific mods are present by placing them in your mod's recipe directory. The recipes will only be functional if the required items exist.

### Cross-Mod Variants
Use variant systems to create recipes that work with multiple mods:
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
  "output": { 
    "type": "item", 
    "code": "yourmod:tool-{material}" 
  }
}
```

### API Integration
For code mods, use try-catch patterns to handle optional mod APIs:
```csharp
try {
    var optionalModAPI = api.ModLoader.GetModSystem<OptionalModAPI>();
    // Use optional mod functionality
} catch {
    // Handle case where optional mod isn't present
}
```

## Final Step: Pack and Install
**ALWAYS run the pack and install script after managing dependencies:**

```bash
./pack_and_install.sh
```

This will:
- Package the mod into a ZIP file
- Install it to the Vintage Story mods directory
- Update the mod version automatically

**Important**: This step is mandatory after every dependency management session.

## Documentation Reference
- [Vintage Story JSON Patching](https://wiki.vintagestory.at/Modding:JSON_Patching)
- [Vintage Story Modding Basics](https://wiki.vintagestory.at/Modding:Modding_Basics_Portal)
- [Vintage Story Grid Recipes](https://wiki.vintagestory.at/Special:MyLanguage/Modding:Grid_Recipes_Guide)
