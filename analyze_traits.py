#!/usr/bin/env python3
"""
Trait Usage Analyzer for neobitVintageServer
Analyzes all JSON files to find trait requirements and suggests pricing.
"""

import os
import json
import re
from collections import defaultdict
from pathlib import Path

def find_trait_requirements_in_json(file_path):
    """Find trait requirements in a JSON file."""
    traits_found = []
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Parse JSON
        try:
            data = json.loads(content)
        except json.JSONDecodeError:
            # If JSON parsing fails, try to find patterns in raw text
            return find_trait_patterns_in_text(content)
        
        # Recursively search for trait requirements
        traits_found.extend(find_traits_recursive(data))
        
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
    
    return traits_found

def find_trait_patterns_in_text(content):
    """Find trait patterns in raw text when JSON parsing fails."""
    traits_found = []
    
    # Pattern for "requiresTrait": "traitname"
    pattern = r'"requiresTrait"\s*:\s*"([^"]+)"'
    matches = re.findall(pattern, content)
    traits_found.extend(matches)
    
    # Pattern for patches that add requiresTrait
    patch_pattern = r'"value"\s*:\s*"([^"]+)"[^}]*"path".*requiresTrait'
    patch_matches = re.findall(patch_pattern, content)
    traits_found.extend(patch_matches)
    
    return traits_found

def find_traits_recursive(obj, path=""):
    """Recursively find trait requirements in JSON structure."""
    traits_found = []
    
    if isinstance(obj, dict):
        # Check for direct requiresTrait
        if "requiresTrait" in obj and isinstance(obj["requiresTrait"], str):
            traits_found.append(obj["requiresTrait"])
        
        # Check for patch operations that add requiresTrait
        if (obj.get("op") == "addmerge" and 
            "requiresTrait" in obj.get("path", "") and 
            isinstance(obj.get("value"), str)):
            traits_found.append(obj["value"])
        
        # Recursively check nested objects
        for key, value in obj.items():
            traits_found.extend(find_traits_recursive(value, f"{path}.{key}"))
    
    elif isinstance(obj, list):
        for i, item in enumerate(obj):
            traits_found.extend(find_traits_recursive(item, f"{path}[{i}]"))
    
    return traits_found

def scan_directory(directory):
    """Scan a directory for JSON files and analyze trait usage."""
    trait_counts = defaultdict(int)
    file_traits = defaultdict(list)
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.json'):
                file_path = os.path.join(root, file)
                relative_path = os.path.relpath(file_path, directory)
                
                traits = find_trait_requirements_in_json(file_path)
                if traits:
                    for trait in traits:
                        trait_counts[trait] += 1
                        file_traits[relative_path].extend(traits)
    
    return trait_counts, file_traits

def calculate_pricing(trait_counts):
    """Calculate suggested prices for traits."""
    if not trait_counts:
        return {}
    
    # Calculate base prices (just the count)
    prices = {}
    for trait, count in trait_counts.items():
        prices[trait] = count
    
    # Find most and least used traits
    most_used_trait = max(trait_counts, key=trait_counts.get)
    least_used_trait = min(trait_counts, key=trait_counts.get)
    
    # Apply modifiers
    for trait in prices:
        if trait == most_used_trait:
            prices[trait] = int(prices[trait] * 1.1)  # +10% for most used
        elif trait == least_used_trait:
            prices[trait] = int(prices[trait] * 0.9)  # -10% for least used
    
    return prices, most_used_trait, least_used_trait

def update_manual_prices(prices):
    """Update manual prices based on calculated trait prices."""
    manual_file = "neobitvintage/assets/neobitvintage/patches/trait-revamp-treasure-hunter-manuals.json"
    
    if not os.path.exists(manual_file):
        print(f"Manual file not found: {manual_file}")
        return
    
    # Mapping from trait names to manual book codes
    trait_to_manual = {
        'hunter': 'traitacquirerrevamp:trait-manual-book-hunter',
        'improviser': 'traitacquirerrevamp:trait-manual-book-malefactor',
        'tinkerer': 'traitacquirerrevamp:trait-manual-book-clockmaker',
        'merciless': 'traitacquirerrevamp:trait-manual-book-blackguard',
        'clothier': 'traitacquirerrevamp:trait-manual-book-tailor',
        'transmutation': 'traitacquirerrevamp:trait-manual-book-alchemyst',
        'artifice': 'traitacquirerrevamp:trait-manual-book-artisan',
        'culinary': 'traitacquirerrevamp:trait-manual-book-chef',
        'pioneer': 'traitacquirerrevamp:trait-manual-book-homesteader',
        'carpenter': 'traitacquirerrevamp:trait-manual-book-lumberjack',
        'mason': 'traitacquirerrevamp:trait-manual-book-mason',
        'mercantile': 'traitacquirerrevamp:trait-manual-book-merchant',
        'prospector': 'traitacquirerrevamp:trait-manual-book-miner',
        'transcription': 'traitacquirerrevamp:trait-manual-book-mystic',
        'sentry': 'traitacquirerrevamp:trait-manual-book-ranger',
        'smith': 'traitacquirerrevamp:trait-manual-book-smith',
        'stitch_doctor': 'traitacquirerrevamp:trait-manual-book-medic',
        'crafty': 'traitacquirerrevamp:trait-manual-book-tinker'
    }
    
    try:
        with open(manual_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Update prices in the manual file
        updated = False
        if data and len(data) > 0 and "value" in data[0]:
            manual_list = data[0]["value"]
            for item in manual_list:
                if "code" in item and "price" in item:
                    # Find matching trait
                    for trait, manual_code in trait_to_manual.items():
                        if item["code"] == manual_code and trait in prices:
                            old_price = item["price"]["avg"]
                            new_price = int(prices[trait] * 0.75)  # instances * 0.75
                            new_var = int(new_price * 0.1)  # 10% variance
                            item["price"]["avg"] = new_price
                            item["price"]["var"] = new_var
                            print(f"Updated {trait} ({manual_code}): {old_price} -> {new_price} (var: {new_var})")
                            updated = True
                            break
        
        if updated:
            with open(manual_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            print(f"Updated manual prices in {manual_file}")
        else:
            print("No manual prices to update")
            
    except Exception as e:
        print(f"Error updating manual prices: {e}")

def main():
    """Main function to analyze traits and suggest pricing."""
    print("🔍 Analyzing specific trait usage in neobitVintageServer...")
    print("=" * 60)
    
    # Focus on specific traits from README
    target_traits = {
        "transmutation", "artifice", "culinary", "pioneer", "carpenter", 
        "mason", "mercantile", "prospector", "transcription", "sentry", 
        "smith", "stitch_doctor", "crafty", "bowyer", "improviser", 
        "tinkerer", "merciless", "clothier"
    }
    
    # Scan both mod and examples directories
    mod_dir = "neobitvintage"
    examples_dir = "examples"
    
    all_trait_counts = defaultdict(int)
    all_file_traits = {}
    
    # Scan mod directory
    if os.path.exists(mod_dir):
        print(f"📁 Scanning {mod_dir}/...")
        mod_counts, mod_files = scan_directory(mod_dir)
        # Filter to only target traits
        for trait, count in mod_counts.items():
            if trait in target_traits:
                all_trait_counts[trait] += count
        all_file_traits.update(mod_files)
    
    # Scan examples directory
    if os.path.exists(examples_dir):
        print(f"📁 Scanning {examples_dir}/...")
        examples_counts, examples_files = scan_directory(examples_dir)
        # Filter to only target traits
        for trait, count in examples_counts.items():
            if trait in target_traits:
                all_trait_counts[trait] += count
        all_file_traits.update(examples_files)
    
    if not all_trait_counts:
        print("❌ No trait requirements found!")
        return
    
    # Calculate pricing
    prices, most_used, least_used = calculate_pricing(all_trait_counts)
    
    # Display results
    print(f"\n📊 Trait Usage Analysis Results:")
    print("=" * 60)
    
    # Sort traits by usage count
    sorted_traits = sorted(all_trait_counts.items(), key=lambda x: x[1], reverse=True)
    
    print(f"{'Trait':<20} {'Count':<8} {'Suggested Price':<15} {'Status'}")
    print("-" * 60)
    
    for trait, count in sorted_traits:
        price = prices[trait]
        status = ""
        if trait == most_used:
            status = "🔥 Most Used (+10%)"
        elif trait == least_used:
            status = "❄️  Least Used (-10%)"
        
        print(f"{trait:<20} {count:<8} {price:<15} {status}")
    
    print(f"\n📈 Summary:")
    print(f"   Total traits found: {len(all_trait_counts)}")
    print(f"   Total instances: {sum(all_trait_counts.values())}")
    print(f"   Most used: {most_used} ({all_trait_counts[most_used]} instances)")
    print(f"   Least used: {least_used} ({all_trait_counts[least_used]} instances)")
    
    # Show files with most trait usage
    print(f"\n📄 Files with most trait requirements:")
    file_counts = [(file, len(traits)) for file, traits in all_file_traits.items()]
    file_counts.sort(key=lambda x: x[1], reverse=True)
    
    for file, count in file_counts[:10]:  # Top 10 files
        print(f"   {file}: {count} traits")
    
    # Update manual prices
    print(f"\n💰 Updating manual prices (10% of trait prices)...")
    update_manual_prices(prices)
    
    print(f"\n✅ Analysis complete!")

if __name__ == "__main__":
    main()
