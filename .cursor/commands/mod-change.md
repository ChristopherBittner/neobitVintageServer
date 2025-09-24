# Mod Modification Request Template

Use this template to efficiently request mod modifications for the neobitVintageServer project.

## Related Commands
- **For creating new recipes**: @grid-recipes.md
- **For JSON patching**: @json-patch.md
- **For variants and compatibility**: @variants-compatibility.md

## Mod Information
- **Mod Name**: [e.g., "fueledwearablelights", "vinconomy", "electricalprogressiveequipment"]
- **Mod Version**: [e.g., "1.0.2", "5.0.2", "2.2.1"]
- **Mod ID**: [e.g., "fueledwearablelights", "vinconomy", "electricalprogressiveequipment"]

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

**Ingredient Changes**:
- [Item]: [Current quantity] → [New quantity]
- [Item]: [Current item] → [New item]
- Add: [New item] (quantity: [X])
- Remove: [Item to remove]

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
- [ ] Remove from handbook display
- [ ] Create multiple trait alternatives
- [ ] Double output for same cost
- [ ] Use different materials (e.g., fat instead of resin)
- [ ] Shapeless recipe
- [ ] Tool durability cost
- [ ] Returned stack (non-consumed items)
- [ ] Liquid container requirements
- [ ] Copy attributes from ingredients
- [ ] Recipe groups for handbook organization

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
1. Copy this template
2. Fill in the relevant sections
3. Use the quick reference guides for common values
4. Be specific about quantities and item codes
5. Include any special requirements or instructions
6. **Run the pack and install script** after modifications

## Final Step: Pack and Install
After completing all modifications, run the pack and install script:

```bash
./pack_and_install.sh
```

This will:
- Package the mod into a ZIP file
- Install it to the Vintage Story mods directory
- Update the mod version automatically

This template will help provide all necessary information for efficient mod modifications!
