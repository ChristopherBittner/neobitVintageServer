# Core Trait Analysis for neobitVintageServer (Excluding Gloome Classes)

## Overview
This document provides a complete analysis of core traits defined across the mod collection, excluding Gloome Classes mod traits. Focus is on the primary trait system from All Classes mod and other core mods.

## Base Classes (from README.md)

### Primary Classes (All Classes Mod)
| Class Code | Class Name | Primary Trait | Description |
|------------|------------|---------------|-------------|
| `alchemyst` | Alchemist | `transmutation` | Alchemy, magical items |
| `artisan` | Artisan | `artifice` | Decorative items, art |
| `chef` | Chef | `culinary` | Cooking, food preparation |
| `homesteader` | Homesteader | `pioneer` | Basic crafting, survival |
| `lumberjack` | Lumberjack | `carpenter` | Woodworking, construction |
| `mason` | Mason | `mason` | Stonework, construction |
| `merchant` | Merchant | `mercantile` | Trading, commerce |
| `miner` | Miner | `prospector` | Mining, exploration tools |
| `mystic` | Mystic | `transcription` | Writing, documentation |
| `ranger` | Ranger | `sentry` | Defensive items, security |
| `smith` | Smith | `smith` | Metalworking, weapons |
| `medic` | Medic | `stitch_doctor` | Medical, healing |
| `tinker` | Tinker | `crafty` | General crafting, tools |

### Secondary Classes (Trait Acquirer Revamp)
| Class Code | Class Name | Primary Trait | Description |
|------------|------------|---------------|-------------|
| `hunter` | Hunter | `bowyer` | Archery, ranged weapons |
| `malefactor` | Malefactor | `improviser` | Alternative materials, creative solutions |
| `clockmaker` | Clockmaker | `tinkerer` | Advanced machinery, electronics |
| `blackguard` | Blackguard | `merciless` | Weapons, combat |
| `tailor` | Tailor | `clothier` | Textiles, clothing |

## Core Traits Analysis

### 1. **transmutation** (Alchemy)
- **Description**: Exclusively can produce sulfur, alchemical items
- **Classes**: `alchemyst` (All Classes)
- **Defined in**: `allclasses/config/traits.json`
- **Attributes**: None (crafting-only trait)
- **Usage**: 81 instances, 6 unique recipes
- **Economic Value**: Low - specialized alchemy items only

### 2. **artifice** (Artisan)
- **Description**: Decorative items, art, small carpets, paintings
- **Classes**: `artisan` (All Classes)
- **Defined in**: `allclasses/config/traits.json`
- **Attributes**: None (crafting-only trait)
- **Usage**: 115 instances, 20 unique recipes
- **Economic Value**: Moderate - decorative and artistic items

### 3. **culinary** (Cooking)
- **Description**: Cooking, food preparation, metal cooking pots, dried aged beef
- **Classes**: `chef` (All Classes)
- **Defined in**: `allclasses/config/traits.json`
- **Attributes**: None (crafting-only trait)
- **Usage**: 70 instances, 13 unique recipes
- **Economic Value**: Low - food preparation items

### 4. **pioneer** (Survival)
- **Description**: Basic crafting, survival, seeds extraction, fertile soil, universal fertilizer
- **Classes**: `homesteader` (All Classes)
- **Defined in**: `allclasses/config/traits.json`
- **Attributes**: None (crafting-only trait)
- **Usage**: 178 instances, 48 unique recipes
- **Economic Value**: High - agriculture and survival essentials

### 5. **carpenter** (Woodworking)
- **Description**: Woodworking, construction, sleek doors, wagon wheels, wallpapers, firewood, boards, lumberjack axe
- **Classes**: `lumberjack` (All Classes)
- **Defined in**: `allclasses/config/traits.json`
- **Attributes**: None (crafting-only trait)
- **Usage**: 157 instances, 39 unique recipes
- **Economic Value**: High - construction and woodworking

### 6. **mason** (Stonework)
- **Description**: Stonework, construction, mortar, plaster, fire-resistant material, raw bricks, stone blocks
- **Classes**: `mason` (All Classes)
- **Defined in**: `allclasses/config/traits.json`
- **Attributes**: None (crafting-only trait)
- **Usage**: 133 instances, 50 unique recipes
- **Economic Value**: High - stone construction and materials

### 7. **mercantile** (Trading)
- **Description**: Trading, commerce, pirate gold coins, rusty gears
- **Classes**: `merchant` (All Classes)
- **Defined in**: `allclasses/config/traits.json`
- **Attributes**: None (crafting-only trait)
- **Usage**: 70 instances, 22 unique recipes
- **Economic Value**: Moderate - trading and commerce items

### 8. **prospector** (Mining)
- **Description**: Mining, exploration tools, rock bombs, blasting powder, mine lamps
- **Classes**: `miner` (All Classes)
- **Defined in**: `allclasses/config/traits.json`
- **Attributes**: None (crafting-only trait)
- **Usage**: 90 instances, 32 unique recipes
- **Economic Value**: High - mining and exploration tools

### 9. **transcription** (Writing)
- **Description**: Writing, documentation, small carpets, parchment, butterflies
- **Classes**: `mystic` (All Classes)
- **Defined in**: `allclasses/config/traits.json`
- **Attributes**: None (crafting-only trait)
- **Usage**: 46 instances, 17 unique recipes
- **Economic Value**: Low - documentation and writing items

### 10. **sentry** (Defense)
- **Description**: Defensive items, security, bows, primitive arrows
- **Classes**: `ranger` (All Classes)
- **Defined in**: `allclasses/config/traits.json`
- **Attributes**: None (crafting-only trait)
- **Usage**: 49 instances, 23 unique recipes
- **Economic Value**: Moderate - defensive and ranged weapons

### 11. **smith** (Metalworking)
- **Description**: Metalworking, weapons, tool sets, metal pans, ore bombs, blasting powder
- **Classes**: `smith` (All Classes)
- **Defined in**: `allclasses/config/traits.json`
- **Attributes**: None (crafting-only trait)
- **Usage**: 289 instances, 46 unique recipes
- **Economic Value**: Very High - essential armor, weapons, and tools

### 12. **stitch_doctor** (Medical)
- **Description**: Medical, healing, sewing kit, tailored armor, grass and flower poultice
- **Classes**: `medic` (All Classes)
- **Defined in**: `allclasses/config/traits.json`
- **Attributes**: None (crafting-only trait)
- **Usage**: 22 instances, 4 unique recipes
- **Economic Value**: Low - medical items only

### 13. **crafty** (General Crafting)
- **Description**: General crafting, tools, metal parts, scrap weapon kit, chutes, mechanical parts
- **Classes**: `tinker` (All Classes)
- **Defined in**: `allclasses/config/traits.json`
- **Attributes**: None (crafting-only trait)
- **Usage**: 92 instances, 30 unique recipes
- **Economic Value**: High - general crafting and mechanical parts

### 14. **bowyer** (Archery)
- **Description**: Archery, ranged weapons
- **Classes**: `hunter` (Trait Acquirer Revamp)
- **Defined in**: Core trait system
- **Attributes**: None (crafting-only trait)
- **Usage**: 120 instances, 26 unique recipes
- **Economic Value**: Moderate - ranged weapons and archery

### 15. **improviser** (Alternative Materials)
- **Description**: Alternative materials, creative solutions
- **Classes**: `malefactor` (Trait Acquirer Revamp)
- **Defined in**: Core trait system
- **Attributes**: None (crafting-only trait)
- **Usage**: 66 instances, 22 unique recipes
- **Economic Value**: Moderate - alternative crafting solutions

### 16. **tinkerer** (Advanced Machinery)
- **Description**: Advanced machinery, electronics
- **Classes**: `clockmaker` (Trait Acquirer Revamp)
- **Defined in**: Core trait system
- **Attributes**: None (crafting-only trait)
- **Usage**: 204 instances, 52 unique recipes
- **Economic Value**: Very High - advanced mechanical devices

### 17. **merciless** (Combat)
- **Description**: Weapons, combat
- **Classes**: `blackguard` (Trait Acquirer Revamp)
- **Defined in**: Core trait system
- **Attributes**: None (crafting-only trait)
- **Usage**: 48 instances, 16 unique recipes
- **Economic Value**: Moderate - combat weapons

### 18. **clothier** (Textiles)
- **Description**: Textiles, clothing
- **Classes**: `tailor` (Trait Acquirer Revamp)
- **Defined in**: Core trait system
- **Attributes**: None (crafting-only trait)
- **Usage**: 667 instances, 339 unique recipes
- **Economic Value**: Extremely High - massive clothing and textile economy

## Additional Core Traits (All Classes Mod)

### Support Traits
- **thrifty**: Economic efficiency
- **greenthumb**: Agricultural expertise
- **mercenary**: Combat specialization
- **sharpeye**: Ranged combat bonuses (+100% ranged damage, +50% projectile acceleration, +25% faster ranged weapons, most accurate)
- **quick**: Speed bonuses (+25% ranged damage, +15% projectile acceleration, +100% faster ranged weapons, +25% accuracy)
- **focusedall**: Balanced ranged combat (+25% ranged damage, +25% projectile acceleration, +25% faster ranged weapons, +50% accuracy)
- **soldierall**: Combat bonuses (+50% melee damage, -25% armor durability loss, -25% armor speed penalty, +25% healing effectiveness)
- **defender**: Defensive bonuses (+10% melee damage, -20% armor durability loss, -20% armor speed penalty, -20% hunger rate)
- **menderall**: Armor maintenance (-25% armor durability loss)
- **resourcefulall**: Resource gathering (+50% animal loot, -75% animal harvesting speed)
- **butcher**: Animal processing (+25% animal loot, -50% animal harvesting speed, +50% wild crop drops, +25% forage drops)
- **scavenger**: Gathering bonuses (+20% wild crop drops, +30% forage drops)
- **foragerall**: Advanced gathering (+25% wild crop drops, +50% forage drops)
- **pilfererall**: Container looting (+35% vessel contents drops, +200% rusty gear drops, +25% whole vessel chance, -20% hunger rate)
- **gearhead**: Gear finding (+200% rusty gear drops, +200% temporal gear drops)
- **fleetfootedall**: Movement (+15% walking speed)
- **furtiveall**: Stealth (-25% animal detection range)
- **sneaky**: Advanced stealth (-60% animal detection range, +15% walking speed)
- **miner**: Mining expertise (+40% ore drops, +100% mining speed)
- **rockhound**: Stone expertise (+15% ore drops, +50% mining speed)
- **rugged**: Health bonus (+5 health points)
- **fasting**: Hunger management (-20% hunger rate)
- **technicalall**: Mechanical expertise (-1 temporal gear repair cost, +50% mechanical damage)
- **burner**: Charcoal production (+35% charcoal drops)
- **lumberjack**: Wood expertise (+10% wood drops, +100% fruit tree drops, +200% tree seed drops, +50% stick drops)
- **farmer**: Agriculture (+30% produce drops)
- **cultivator**: Advanced agriculture (+20% produce drops)
- **surgeon**: Medical expertise
- **stitch_doctor**: Medical crafting

### Negative Traits
- **exhausted**: Combat penalties (-35% ranged damage, -35% projectile acceleration, -20% ranged accuracy, -30% slower ranged weapons)
- **inaccurate**: Ranged penalties (-25% ranged damage, -20% ranged accuracy, -25% range, -15% slower ranged weapons)
- **farsightedall**: Melee penalty (-20% melee damage)
- **clumsy**: Armor penalty (+25% armor durability loss)
- **nervousall**: Combat anxiety (+50% armor durability loss, -20% melee damage)
- **squeamish**: Animal processing penalty (-25% animal loot, +10% animal harvesting speed)
- **heavyhandedall**: Gathering penalty (-20% vessel contents drops, -20% forage drops, -20% wild crop drops)
- **civilall**: Social penalty (-25% animal loot, +15% animal harvesting speed, -15% forage drops, -15% wild crop drops)
- **heavyfooted**: Detection penalty (+20% animal detection range)
- **sluggish**: Mining penalty (-25% mining speed)
- **careless**: Mining penalty (-20% ore drops)
- **petraphobia**: Stone phobia (-20% ore drops, -25% mining speed)
- **weakall**: Health penalty (-5 health points)
- **fragile**: Health penalty (-2.5 health points)
- **ravenousall**: Hunger penalty (+25% hunger rate)
- **hungry**: Hunger penalty (+10% hunger rate)
- **unwell**: Healing penalty (-25% healing effectiveness)

## Trait Usage Statistics (Core Only)

### Most Used Traits (by instance count)
1. **clothier**: 667 instances, 339 unique recipes
2. **smith**: 289 instances, 46 unique recipes
3. **tinkerer**: 204 instances, 52 unique recipes
4. **pioneer**: 178 instances, 48 unique recipes
5. **carpenter**: 157 instances, 39 unique recipes

### Most Valuable Traits (by unique recipes)
1. **clothier**: 339 unique recipes
2. **tinkerer**: 52 unique recipes
3. **mason**: 50 unique recipes
4. **pioneer**: 48 unique recipes
5. **smith**: 46 unique recipes

### Least Used Traits
1. **stitch_doctor**: 22 instances, 4 unique recipes
2. **transmutation**: 81 instances, 6 unique recipes
3. **culinary**: 70 instances, 13 unique recipes

## Economic Value Categories

### Extremely High Value
- **clothier**: 339 unique recipes (clothing, bags, textiles)

### Very High Value
- **smith**: 46 unique recipes (armor, weapons, tools)
- **tinkerer**: 52 unique recipes (advanced machinery)

### High Value
- **mason**: 50 unique recipes (stonework, construction)
- **pioneer**: 48 unique recipes (agriculture, survival)
- **carpenter**: 39 unique recipes (woodworking, construction)
- **prospector**: 32 unique recipes (mining, exploration)
- **crafty**: 30 unique recipes (general crafting)

### Moderate Value
- **artifice**: 20 unique recipes (decorative items)
- **bowyer**: 26 unique recipes (archery)
- **sentry**: 23 unique recipes (defense)
- **mercantile**: 22 unique recipes (trading)
- **improviser**: 22 unique recipes (alternative materials)
- **merciless**: 16 unique recipes (combat)

### Low Value
- **transcription**: 17 unique recipes (writing)
- **culinary**: 13 unique recipes (cooking)
- **transmutation**: 6 unique recipes (alchemy)
- **stitch_doctor**: 4 unique recipes (medical)

## File Locations

### Trait Definitions
- **All Classes**: `examples/modsToLockByTraits/allclasses2.0.6/assets/allclasses/config/traits.json`

### Class Definitions
- **All Classes**: `examples/modsToLockByTraits/allclasses2.0.6/assets/allclasses/config/characterclasses.json`

### Language Files
- **All Classes**: `examples/modsToLockByTraits/allclasses2.0.6/assets/allclasses/lang/en.json`

## Economic Analysis (Core Traits Only)

The core trait system creates a balanced economy where:
- **Clothier dominates** with 5x more unique recipes than other traits
- **Smith provides essential** armor and weapon crafting
- **Tinkerer unlocks advanced** mechanical technology
- **Mason and Carpenter** handle construction needs
- **Pioneer** enables food security and agriculture
- **Prospector** provides mining and exploration tools
- **Specialized traits** (Stitch Doctor, Transmutation) have limited but important roles

## Conclusion

The core trait system provides 18 primary crafting traits plus numerous support and negative traits, creating a diverse and balanced crafting economy where each trait has unique value and purpose. The system is well-designed with clear economic tiers and balanced progression paths.
