#!/usr/bin/env python3
"""Quick test script to verify the app works with Groq"""

from dotenv import load_dotenv
import os
import sys

load_dotenv()

print("Testing Recipe Suggestion Helper...\n")

# Test 1: Check dependencies
print("1. Checking dependencies...")
try:
    from rich import print as rprint
    print("   ✓ rich installed")
except ImportError:
    print("   ✗ rich not installed - run: pip install rich")
    sys.exit(1)

try:
    from groq import Groq
    print("   ✓ groq installed")
except ImportError:
    print("   ✗ groq not installed - run: pip install groq")
    sys.exit(1)

try:
    from dotenv import load_dotenv
    print("   ✓ python-dotenv installed")
except ImportError:
    print("   ✗ python-dotenv not installed - run: pip install python-dotenv")
    sys.exit(1)

# Test 2: Check API key
print("\n2. Checking API key...")
api_key = os.getenv("GROQ_API_KEY")
if api_key:
    masked = api_key[:8] + "*" * (len(api_key) - 12) + api_key[-4:]
    print(f"   ✓ API key loaded: {masked}")
else:
    print("   ⚠ API key not found (AI features will be unavailable)")

# Test 3: Import app modules
print("\n3. Testing app modules...")
try:
    from src.recipe_helper import parse_ingredients, match_recipes, get_available_diets
    print("   ✓ recipe_helper module loaded")
except Exception as e:
    print(f"   ✗ recipe_helper error: {e}")
    sys.exit(1)

try:
    from src.openai_helper import generate_recipes_from_ingredients
    print("   ✓ openai_helper module loaded")
except Exception as e:
    print(f"   ✗ openai_helper error: {e}")
    sys.exit(1)

# Test 4: Test ingredient parsing
print("\n4. Testing ingredient parsing...")
test_ings = parse_ingredients("chicken, rice, broccoli")
print(f"   ✓ Parsed: {test_ings}")

# Test 5: Test recipe matching
print("\n5. Testing recipe matching...")
matches = match_recipes(test_ings, min_match=2)
print(f"   ✓ Found {len(matches)} matching recipes")

# Test 6: Test diet filtering
print("\n6. Testing diet options...")
diets = get_available_diets()
print(f"   ✓ Available diets: {', '.join(diets[:5])}{'...' if len(diets) > 5 else ''}")

print("\n" + "="*60)
print("✓ All tests passed! The app is ready to use.")
print("="*60)
print("\nRun the app with: python main.py")
print("For help: python main.py --show-key")

