# Demo Walkthrough – Recipe Suggestion Helper

## 🎬 Full Demo Session (5–7 Minutes)

This walkthrough shows the complete user journey with dietary filtering, ingredient matching, recipe details, allergen warnings, nutrition info, substitution suggestions, and recipe confirmation flow.

### Full Transcript

```
Hi! I'm your Recipe Suggestion Helper.

Available dietary options: halal, kosher, pescatarian, vegan, vegetarian
Do you have any dietary preferences? (or press Enter to skip)
> vegan

Tell me what ingredients you have (comma-separated). Example: 'chicken, rice, broccoli'
What ingredients do you have?
> tofu broccoli garlic

Great! Here are some recipes you can make:
1. Tofu Stir-Fry (20 minutes) — vegan, vegetarian — matches 3 ingredient(s)
2. Quick Veggie Stir-Fry (15 minutes) — vegan, vegetarian, halal, kosher — matches 2 ingredient(s)

Which number would you like to know more about, or type a recipe name? (or 'no' to exit)
> 1

Tofu Stir-Fry (20 minutes)
Dietary tags: vegan, vegetarian

- Step 1: Press tofu and cut into cubes.
- Step 2: Pan-fry tofu until golden, set aside.
- Step 3: Stir-fry veggies and garlic, add tofu back with soy sauce, cook until done.

Allergens (best-effort): soy

Nutrition estimate (per recipe): 270 cal | 26g protein | 33g carbs | 6.2g fat
(Best-effort estimate. Do not use for medical/diet purposes.)

Anything else? Ask for substitutions, time, or 'want to make this' to confirm, or 'exit'
> i don't have soy sauce

I don't have a suggestion for that ingredient

Anything else? Ask for substitutions, time, or 'want to make this' to confirm, or 'exit'
> time

This recipe takes about 20 minutes

Anything else? Ask for substitutions, time, or 'want to make this' to confirm, or 'exit'
> want to make this

Great — preparing this recipe for you.
Shopping list:
 - tofu (have)
 - broccoli (have)
 - bell pepper (missing)
 - soy sauce (missing)
 - garlic (have)
 - oil (missing)

Estimated cost (rough): $10.5

Save this recipe to your saved list and create a recipe card? (y/n)
> n

Suggested timers: prep ~5 minutes, cook ~15 minutes (total 20 minutes)

Anything else? Ask for substitutions, time, or 'want to make this' to confirm, or 'exit'
> exit

Bye — happy cooking!
```

---

## 📋 Key Features Demonstrated

### 1. Dietary Preference Filter
- User selects "vegan" from available options
- Only recipes tagged as vegan/vegetarian are suggested
- Users can skip this to see all recipes

**Talking point:** "We support 5 dietary categories: halal, kosher, pescatarian, vegan, vegetarian. Filtering respects user preferences while maintaining diversity."

### 2. Flexible Ingredient Input
- Accepts both comma-separated (`tofu, broccoli, garlic`) and space-separated (`tofu broccoli garlic`)
- Performs substring matching (e.g., `soba` matches `soba noodles`)
- Normalizes ingredients for case-insensitive matching

**Talking point (Katie):** "We normalized ingredient names across the recipe database. Users can type naturally—we handle the parsing."

### 3. Recipe Matching & Ranking
- Matches recipes with ≥2 common ingredients
- Sorts by best matches first (most ingredient overlap)
- Shows dietary tags for quick reference

**Talking point:** "Our matching algorithm is simple but effective. We require 2+ ingredient matches to ensure relevance."

### 4. Allergen Warnings
- Displays detected allergens (best-effort keyword matching)
- Includes soy, milk, egg, wheat_gluten, fish, shellfish, tree_nuts, sesame, and more
- Includes a disclaimer (not a substitute for professional allergy info)

**Talking point (Morgan):** "Allergen detection is automated using ingredient keyword matching. It's best-effort and should be verified by users for safety-critical needs."

### 5. Nutrition Estimates
- Shows estimated calories, protein, carbs, fat per recipe
- Based on ingredient-level nutrition data (simplified)
- Includes disclaimers (not for medical/diet purposes)

**Talking point:** "We added basic nutrition estimates so users can make informed choices. The estimates are rough approximations—for detailed nutrition info, users should consult external databases."

### 6. Follow-Up Questions
- **Time:** "How long does it take?" → Returns recipe time
- **Substitution:** "I don't have X" → Suggests alternatives from a curated substitution map
- **Steps:** "Show me steps again" → Repeats recipe instructions
- **Free-form:** With `OPENAI_API_KEY` set, rich follow-ups are possible

**Talking point (David):** "Intent detection uses simple regex and keyword matching. For demos without an API key, we use built-in responders. OpenAI integration is optional and backwards-compatible."

### 7. Recipe Confirmation & Saving
- User can confirm "want to make this"
- Shows shopping list (have vs. missing ingredients)
- Rough cost estimate
- Option to save to `saved_recipes.json` and create a printable recipe card
- Suggested prep/cook timers based on recipe time

**Talking point (Desiree):** "When users commit to a recipe, we give them actionable info: what they need to buy, estimated cost, and timing. Recipe cards are saved as plain text for easy sharing."

---

## 🔍 Intent Classification Examples

### Intent 1: Set Dietary Preference
**User input:** "vegan" (or "vegetarian", "halal", etc.)
- **Recognition:** Matches available dietary options
- **Action:** Filter recipes by diet
- **Response:** Acknowledge and ask for ingredients

### Intent 2: Provide Ingredients
**User input:** "tofu broccoli garlic" or "tofu, broccoli, garlic"
- **Recognition:** Ingredient keywords detected
- **Action:** Parse and match against recipes
- **Response:** Show top 3 matching recipes with dietary tags

### Intent 3: Select Recipe
**User input:** "1" or "Tofu Stir-Fry"
- **Recognition:** Numeric index or recipe title
- **Action:** Look up recipe details
- **Response:** Full recipe with steps, allergens, nutrition

### Intent 4a: Ask About Time
**User input:** "How long?" / "time" / "How long does it take?"
- **Recognition:** Keywords: "time", "long", "how long"
- **Response:** Return recipe time

### Intent 4b: Ask About Substitution
**User input:** "I don't have soy sauce" / "Can I use oil instead?"
- **Recognition:** Keywords: "don't have", "substitute", "instead of"
- **Response:** Return suggestion from substitution map (or "I don't have a suggestion")

### Intent 4c: Ask About Steps
**User input:** "Show me steps" / "How do I make it?" / "Tell me the steps"
- **Recognition:** Keywords: "steps", "how do", "show"
- **Response:** Repeat full recipe with numbered steps

### Intent 5: Confirm Recipe
**User input:** "want to make this"
- **Recognition:** Exact match on "want to make this"
- **Action:** Show shopping list, cost estimate, save option
- **Response:** Shopping list (have/missing), timers, save prompt

### Intent 6: Exit
**User input:** "exit" / "quit" / "no" / "bye"
- **Recognition:** Exit keywords
- **Response:** Friendly goodbye message

---

## 🛡️ Error Handling Examples

### No Matching Recipes
```
Sorry, I couldn't find recipes matching at least 2 of your ingredients
with the 'vegan' dietary requirement.
Try adding more ingredients or removing dietary filters.
```

### Invalid Selection
```
Couldn't find that selection. Exiting.
```

### Empty Input
```
I didn't hear any ingredients. Exiting.
```

### Unrecognized Question (Without OpenAI)
```
Sorry — I can answer substitution and time questions. For richer answers, 
set OPENAI_API_KEY and run again.
```

### EOF / Ctrl+C
```
Input closed. Exiting.
```

---

## 📊 Sample Diet-Specific Conversations

### Halal Preference
```
> halal
> chicken, rice, oil
Great! Here are some recipes you can make:
1. Chicken & Rice Bowl (25 minutes) — halal, kosher — matches 2 ingredient(s)

> 1
Chicken & Rice Bowl (25 minutes)
Dietary tags: halal, kosher
[Recipe steps shown]
Allergens (best-effort): soy
Nutrition estimate (per recipe): 451 cal | 42g protein | 52g carbs | 7.3g fat
```

### Pescatarian Preference
```
> pescatarian
> fish, lemon, oil
Great! Here are some recipes you can make:
1. Grilled Fish with Lemon (20 minutes) — pescatarian, halal, kosher — matches 3 ingredient(s)

> 1
Grilled Fish with Lemon (20 minutes)
Dietary tags: pescatarian, halal, kosher
[Recipe steps shown]
Allergens (best-effort): fish
Nutrition estimate (per recipe): 380 cal | 30g protein | 15g carbs | 25g fat
```

### No Dietary Filter
```
> [skip]
> tofu, rice
Great! Here are some recipes you can make:
1. Fried Rice (15 minutes) — vegetarian — matches 1 ingredient(s)
2. Tofu Stir-Fry (20 minutes) — vegan, vegetarian — matches 2 ingredient(s)
3. Quick Veggie Stir-Fry (15 minutes) — vegan, vegetarian, halal, kosher — matches 2 ingredient(s)
```

---

## 💡 Design & Architecture Talking Points

### Modular Code Structure
- **`main.py`** (50 lines) – Conversation loop and UX
- **`src/recipe_helper.py`** (180 lines) – Recipe matching, parsing, substitutions
- **`src/openai_helper.py`** (40 lines) – Optional OpenAI integration
- **`recipes.json`** (313 recipes) – Declarative recipe database with allergens and nutrition

**Why modular?** Easy to test, extend, and maintain. Teams can work in parallel.

### Why JSON Over Database?
- No setup required (perfect for hackathons)
- Human-readable and version-controllable
- Easy to export to other formats (CSV, spreadsheet)
- Scales well for ~300 recipes

### Why Dietary Tags vs. ML Classifier?
- Explicit tags are accurate and transparent
- No false positives or false negatives for safety-critical uses
- Users understand exactly why a recipe was filtered

### Why Substring Matching?
- "soba" matches "soba noodles" (user-friendly)
- Reduces typos and variation in ingredient names
- Still precise enough to avoid false matches

### Why Best-Effort Allergen Detection?
- Automated tagging saves manual work
- Keyword-based (transparent, no black-box ML)
- Includes disclaimer (responsibility falls on user to verify)
- Can be manually corrected in recipes.json

### Why Optional OpenAI?
- Offline-first (privacy, no API key required)
- Backwards-compatible (doesn't break core functionality)
- Falls back gracefully if API key missing
- Future enhancement path (not essential to MVP)

---

## 🎤 Team Talking Points (60 sec each)

### Desiree (Project Lead & Architecture)
"The Recipe Suggestion Helper is a simple CLI chatbot that helps users discover recipes based on what they have at home. We focused on three things: usability (natural conversation flow), safety (allergen warnings, nutrition info), and responsibility (we document our design decisions and limitations). The code is modular—main.py handles interaction, recipe_helper.py has the logic, and recipes.json is the data. Everything is offline by default; OpenAI integration is optional."

### Katie (Recipes & Database)
"We assembled 313 recipes from scratch, including hand-curated originals and programmatically generated variations. Each recipe has ingredients, cooking time, steps, dietary tags (vegan, halal, kosher, etc.), allergens, and nutrition estimates. The ingredient matching is smarter than exact match—we handle typos and variations. For example, 'soba' matches 'soba noodles'. We also normalized ingredient names so users can type naturally."

### David (Conversation Flow & Intent Detection)
"Intent detection drives the conversation. We identified 5–6 intents users express: set diet, provide ingredients, select recipe, ask questions (time/substitution/steps), confirm recipe, and exit. For each intent, we have a simple regex-based recognizer and an action. Most intents have hardcoded responses, which is reliable. For richer follow-ups, we can plug in OpenAI—the integration is there, backwards-compatible, and tested."

### Morgan (Testing, Ethics & Responsibility)
"We tested the happy path (vegan diet, ingredient matching, recipe details) and edge cases (no matches, empty input, exit). We also built in allergen detection (best-effort), nutrition estimates (rough), and clear disclaimers. Most importantly, we documented our assumptions and limitations in ETHICS.md. We're transparent about what the bot can and can't do, and we took responsibility for the code we wrote—no black-box ML, just simple, understandable logic."

---

## ✅ Demo Day Checklist

- [ ] Test `python main.py` on demo machine
- [ ] Pre-load 2–3 ingredient sets (vegan tofu, halal chicken, pescatarian fish)
- [ ] Show full flow: diet → ingredients → recipe → follow-up → confirm
- [ ] Highlight allergen and nutrition displays
- [ ] Demonstrate substitution and time questions
- [ ] Show a saved recipe card (plain text file)
- [ ] Each team member has 1–2 talking points ready
- [ ] Have README.md and ETHICS.md visible for Q&A
- [ ] Optional: Show `--help` or code structure if asked
- [ ] Total demo time: 5–7 minutes

---

## 📞 Likely Questions & Answers

**Q: Why not use a real database?**
A: For a hackathon project, JSON is simpler and sufficient. No setup, easy to version control, easy to export.

**Q: How accurate are the nutrition estimates?**
A: Best-effort. We use per-ingredient approximations. For precise info, users should consult USDA or MyFitnessPal databases. We include a clear disclaimer.

**Q: What about food allergies?**
A: We detect common allergens by ingredient keyword matching. It's best-effort and transparent. Users must verify for safety. Severe allergies need professional guidance.

**Q: Can you expand to X cuisine?**
A: Yes! Add recipes to `recipes.json` and run `python3 scripts/add_allergen_flags.py` and `scripts/add_nutrition.py` to auto-tag new recipes.

**Q: How do you handle OpenAI costs?**
A: OpenAI integration is optional. If `OPENAI_API_KEY` is not set, the app works fully offline and costs nothing.

---

**Last Updated:** December 10, 2025
