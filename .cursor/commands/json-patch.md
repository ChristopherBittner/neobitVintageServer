# JSON Patching Command

Create JSON patches for Vintage Story mods using the official patching system. Based on [Vintage Story JSON Patching documentation](https://wiki.vintagestory.at/Modding:JSON_Patching).

## Quick Start
For simple mod modifications, use: @mod-change.md

## JSON Patch Structure

```json
[
  {
    "file": "domain:path/to/file",
    "op": "operation",
    "path": "/json/path/to/target",
    "value": "new_value",
    "side": "server|client"
  }
]
```

## Patch Operations

### Basic Operations
- **`add`** - Add a new property or array element
- **`remove`** - Remove a property or array element  
- **`replace`** - Replace an existing value
- **`move`** - Move a value to a new location
- **`copy`** - Copy a value to a new location

### Advanced Operations
- **`addmerge`** - Add/merge properties into an object
- **`addeach`** - Add elements to each item in an array

## File Targeting

### Domain Format
```
domain:path/to/file
```

**Common Domains:**
- `game:` - Vanilla Vintage Story assets
- `modid:` - Your mod or other mods (e.g., `fueledwearablelights:`)

**File Paths:**
- `recipes/grid/recipe-name` - Grid recipes
- `recipes/smithing/recipe-name` - Smithing recipes
- `entities/land/entity-name` - Land entities
- `blocktypes/block-name` - Block definitions

## Path Syntax

### JSON Path Examples
```
/server/behaviors/9/aitasks/0/damage    # Nested object with array indices
/drops/-                                # Append to end of array
/ingredients/M/quantity                 # Modify specific ingredient
/requiresTrait                          # Add trait requirement
```

### Path Components
- **Labels** (followed by `:`) - Object properties
- **Numbers** - Array indices (start from 0)
- **`-`** - Append to end of array
- **`/`** - Path separator

## Common Patch Examples

### Add Trait Requirement
```json
{
  "file": "modid:recipes/grid/recipe-name",
  "op": "addmerge",
  "path": "/requiresTrait",
  "value": "prospector",
  "side": "server"
}
```

### Modify Ingredient Quantity
```json
{
  "file": "modid:recipes/grid/recipe-name",
  "op": "addmerge", 
  "path": "/ingredients/M/quantity",
  "value": 10,
  "side": "server"
}
```

### Remove Recipe (Disable)
```json
{
  "file": "modid:recipes/grid/recipe-name",
  "op": "add",
  "path": "/enabled",
  "value": false,
  "side": "server"
}
```

### Add New Drop
```json
{
  "file": "game:entities/land/wolf-male",
  "op": "add",
  "path": "/drops/-",
  "value": {
    "type": "item",
    "code": "game:stick",
    "quantity": { "avg": 2, "var": 1 }
  },
  "side": "server"
}
```

### Replace Damage Value
```json
{
  "file": "game:entities/land/wolf-male",
  "op": "replace",
  "path": "/server/behaviors/9/aitasks/0/damage",
  "value": 6,
  "side": "server"
}
```

## Side Targeting
Use `"side": "server"` or `"side": "client"` to target specific sides:
- **Server**: Recipes, entities, block behaviors
- **Client**: UI elements, rendering, sounds

## Patch File Location
Place patch files in: `assets/yourmodid/patches/`

## Testing Patches

### With Errors
Check game logs for patch errors and warnings.

### Without Errors  
Verify changes in-game and test functionality.

## Advanced Examples

### Multiple Recipe Modifications
```json
[
  {
    "file": "fueledwearablelights:recipes/grid/carbidelamp",
    "op": "addmerge",
    "path": "/requiresTrait", 
    "value": "prospector",
    "side": "server"
  },
  {
    "file": "fueledwearablelights:recipes/grid/candlelamp",
    "op": "addmerge",
    "path": "/requiresTrait",
    "value": "pioneer", 
    "side": "server"
  }
]
```

### Complex Ingredient Changes
```json
[
  {
    "file": "electricalprogressiveequipment:recipes/grid/eaxe",
    "op": "addmerge",
    "path": "/ingredients/M/quantity",
    "value": 15,
    "side": "server"
  },
  {
    "file": "electricalprogressiveequipment:recipes/grid/eaxe", 
    "op": "addmerge",
    "path": "/ingredients/B/quantity",
    "value": 8,
    "side": "server"
  }
]
```

## Troubleshooting

### Common Issues
- **Wrong domain**: Use correct mod ID as domain
- **Incorrect path**: Count array indices starting from 0
- **Missing side**: Add `"side": "server"` for server-only assets
- **File conflicts**: Use unique patch file names

### Path Debugging
1. Open target JSON file
2. Trace path from root to target value
3. Count array indices (0-based)
4. Use labels for object properties

## Quick Reference

### Common File Paths
- `recipes/grid/` - Grid crafting recipes
- `recipes/smithing/` - Smithing recipes  
- `entities/land/` - Land creatures
- `blocktypes/` - Block definitions
- `itemtypes/` - Item definitions

### Common Operations
- `addmerge` - Add/modify properties
- `add` - Add new elements
- `remove` - Remove elements
- `replace` - Replace values

### Common Paths
- `/requiresTrait` - Add trait requirement
- `/ingredients/*/quantity` - Modify ingredient amounts
- `/drops/-` - Add new drop
- `/enabled` - Enable/disable asset

## Integration with Mod-Change
For high-level mod modification requests, use @mod-change.md first, then use this command to create the actual JSON patches.

## Documentation Reference
Full documentation: https://wiki.vintagestory.at/Modding:JSON_Patching
