# Mod Modification Request Template

Use this template to efficiently request mod modifications for the neobitVintageServer project.

## Related Commands
- **For creating new recipes - needed if a receipe would need to require more traits than 1**: @grid-recipes.md
- **For JSON patching**: @json-patch.md
- **For variants and compatibility**: @variants-compatibility.md
- **For dependency management**: @dependency-management.md

## CRITICAL: Always Examine Original Files First

**BEFORE making any patches, ALWAYS examine the original mod files to understand:**
1. **Actual ingredient letter mappings** (e.g., M=metal-parts, B=temporal-gears, P=coils, E=engineshaft, etc.)
2. **Correct file paths** for itemtypes (e.g., `static-armor.json` not `echestplate.json`)
3. **Array structure** - whether recipes are single objects or arrays with multiple entries
4. **Existing ingredient quantities** to understand what needs to be changed

**Common Mistakes to Avoid:**
- ❌ Guessing ingredient letter mappings (M, B, P, E, etc.)
- ❌ Assuming file paths without checking
- ❌ Not understanding array vs object structure
- ❌ Modifying wrong ingredient letters
- ❌ Using wrong itemtype paths for handbook exclusions

## Mod Information
- **Mod Name**: [e.g., "fueledwearablelights", "vinconomy", "electricalprogressiveequipment"]
- **Mod Version**: [e.g., "1.0.2", "5.0.2", "2.2.1"]
- **Mod ID**: [e.g., "fueledwearablelights", "vinconomy", "electricalprogressiveequipment"]
- **Dependency Type**: [ ] Required | [ ] Optional (patch applies only if mod is present)

## Request Type
- [ ] Add trait requirements to existing recipes
- [ ] Create new recipes with trait requirements
- [ ] Modify existing recipe ingredients/quantities
- [ ] Disable/remove recipes
- [ ] Add alternative recipes for different traits

## Specific Changes

### Recipe Modifications
**Recipe Name**: [e.g., "carbide lamp", "shop register", "electric axe"]
**Current Requirements**: [e.g., "none", "carpenter", "tinkerer"]
**New Requirements**: [e.g., "prospector", "mercantile", "crafty OR tinkerer"]

**Ingredient Changes** (MUST specify correct letter mappings):
- [Letter]: [Item description] - [Current quantity] → [New quantity]
- [Letter]: [Item description] - [Current item] → [New item]
- Add: [Letter]: [Item description] (quantity: [X])
- Remove: [Letter]: [Item description]

**Example with correct mappings:**
- M: Metal parts - 2 → 16
- B: Temporal gears - 1 → 8  
- P: Coils - 4 → 16
- E: Engine shaft - 1 → 8

### New Recipes
**Recipe Name**: [e.g., "Mercantile Shop Register"]
**Trait Required**: [e.g., "mercantile"]
**Pattern**: [e.g., "SCS,PPP,SCS" or "S,T,W"]
**Ingredients**:
- [Letter]: [Item code] (quantity: [X])
- [Letter]: [Item code] (quantity: [X])
**Output**: [Item code] (quantity: [X])

**Note**: Use @grid-recipes.md for detailed recipe creation with advanced features like tool durability, returned stacks, liquid containers, etc.

### Special Instructions
- [ ] Remove from handbook display (specify correct itemtype path, e.g., `static-armor.json`)
- [ ] Create multiple trait alternatives
- [ ] Double output for same cost
- [ ] Use different materials (e.g., fat instead of resin)
- [ ] Shapeless recipe
- [ ] Tool durability cost
- [ ] Returned stack (non-consumed items)
- [ ] Liquid container requirements
- [ ] Copy attributes from ingredients
- [ ] Recipe groups for handbook organization

### Array Structure Considerations
- **Single recipe files**: Use `/requiresTrait` and `/ingredients/X/quantity`
- **Array recipe files**: Use `/0/requiresTrait`, `/1/requiresTrait`, etc. for different recipes
- **Multiple recipes in one file**: May need to modify different array indices (0, 1, 2, etc.)

---

## Example Usage

```markdown
# Mod Modification Request

## Mod Information
- **Mod Name**: fueledwearablelights
- **Mod Version**: 1.0.2
- **Mod ID**: fueledwearablelights

## Request Type
- [x] Add trait requirements to existing recipes

## Specific Changes

### Recipe Modifications
**Recipe Name**: carbide lamp
**Current Requirements**: none
**New Requirements**: prospector

**Recipe Name**: candle lamp
**Current Requirements**: none
**New Requirements**: pioneer

**Recipe Name**: oil lamp
**Current Requirements**: none
**New Requirements**: transmutation

### Special Instructions
- [x] Apply to all head variants
```

---

## Quick Reference - Common Traits
- `transmutation` - Alchemy, magical items (alchemist - 400)
- `artifice` - Decorative items, art (artisan - 200)
- `culinary` - Cooking, food preparation (chef - 300)
- `pioneer` - Basic crafting, survival (homesteader - 200)
- `carpenter` - Woodworking, construction (lumberjack - 400)
- `mason` - Stonework, construction (mason - 400)
- `mercantile` - Trading, commerce (merchant - 200)
- `prospector` - Mining, exploration tools (miner - 400)
- `transcription` - Writing, documentation (mystic - 400)
- `sentry` - Defensive items, security (ranger - 300)
- `smith` - Metalworking, weapons (smith - 500)
- `stitch_doctor` - Medical, healing (medic - 200)
- `crafty` - General crafting, tools (tinker - 500)
- `bowyer` - Archery, ranged weapons (hunter - 200)
- `improviser` - Alternative materials, creative solutions (malefactor - 200)
- `tinkerer` - Advanced machinery, electronics (clockmaker - 500)
- `merciless` - Weapons, combat (blackguard - 200)
- `clothier` - Textiles, clothing (tailor - 300)

## Quick Reference - Common Item Codes
- `game:gear-temporal` - Temporal gears
- `game:metal-parts` - Metal parts/rotors
- `game:metalplate-steel` - Steel plates
- `game:fat` - Fat
- `game:resin` - Resin
- `game:torch-burning` - Burning torch
- `game:candle` - Candle
- `game:lantern-*` - Lanterns
- `game:plank-*` - Wood planks
- `game:stone-*` - Stones
- `game:rope` - Rope
- `game:book-*` - Books
- `game:charcoal` - Charcoal
- `game:stick` - Sticks
- `game:leather-normal-plain` - Leather
- `game:ingot-*` - Metal ingots
- `game:gem-diamond-rough` - Rough diamonds

## Quick Reference - Common Mod IDs
- `fueledwearablelights` - Fueled Wearable Lights
- `hydrateordiedrate` - Hydrate or Diedrate
- `translocatorengineeringredux` - Translocator Engineering Redux
- `vinconomy` - Vinconomy
- `wwaymarkers` - Wilderlands Waymarkers
- `windchimes` - Windchimes
- `wool` - Wool
- `vsinstrumentsbase` - VSInstruments Base
- `vsinstruments_quackpack` - VSInstruments Quackpack
- `electricalprogressiveequipment` - Electrical Progressive Equipment

## Usage Instructions
1. **FIRST**: Examine original mod files to understand structure and mappings
2. Copy this template
3. Fill in the relevant sections with correct letter mappings
4. Use the quick reference guides for common values
5. Be specific about quantities and item codes with correct letters
6. Include any special requirements or instructions
7. **Specify dependency type** (required vs optional)
8. **Run the pack and install script** after modifications

## Key Lessons from electricalprogressiveequipment:
- **Chestplate**: Use `static-armor.json` not `echestplate.json` for handbook exclusion
- **Drill**: M=metal-parts, B=temporal-gears, P=coils, E=engineshaft, I=cupronickel, D=drill-tip
- **Axe**: M=metal-parts, B=temporal-gears, P=coils, E=engineshaft, Z=axe-head
- **Array recipes**: Use correct indices (/0/, /1/, /2/) for different recipe variants
- **Always check original files first** to avoid guessing ingredient mappings

## Dependency Management

### Required Dependencies
- Mod must be present for your mod to load
- Use for core functionality your mod depends on
- Add to `modinfo.json` dependencies with version requirements

### Optional Dependencies  
- Mod can be present or absent
- Patches/recipes apply only if target mod is installed
- **Method 1 (Recommended)**: Don't list in `modinfo.json` dependencies at all
- **Method 2**: Add to `modinfo.json` dependencies with empty version: `"modid": ""`
- Patches fail silently if target mod isn't present (this is normal)

## Final Step: Pack and Install
**ALWAYS run the pack and install script after making any mod changes:**

```bash
./pack_and_install.sh
```

This will:
- Package the mod into a ZIP file
- Install it to the Vintage Story mods directory
- Update the mod version automatically

**Important**: This step is mandatory after every mod modification session.

This template will help provide all necessary information for efficient mod modifications!
