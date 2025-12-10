import json
import pytest

import src.recipe_helper as rh


def test_fallback_without_openai(monkeypatch):
    # Ensure ask_openai is None (simulate not available)
    monkeypatch.setattr(rh, "ask_openai", None)
    monkeypatch.setattr(rh, "USE_OPENAI", False)

    out = rh.suggest_substitute("soy sauce")
    assert isinstance(out, str)
    assert "I don't have a suggestion" in out or out == rh.SUBSTITUTIONS.get("soy sauce", out)


def test_openai_returns_structured_json(monkeypatch):
    # Simulate OpenAI returning clean JSON
    sample = json.dumps({
        "suggestions": [
            {"name": "tamari", "note": "gluten-free soy sauce alternative"},
            {"name": "coconut aminos", "note": "lower-sodium substitute"},
        ]
    })

    def fake_ask(q, recipe, system_prompt=None, model=None):
        return sample

    monkeypatch.setattr(rh, "ask_openai", fake_ask)
    monkeypatch.setattr(rh, "USE_OPENAI", True)

    out = rh.suggest_substitute("soy sauce")
    assert "tamari" in out
    assert "coconut aminos" in out
    assert "gluten-free soy sauce alternative" in out


def test_openai_returns_fenced_json(monkeypatch):
    # Simulate OpenAI returning JSON wrapped in ```json fences
    sample = "```json\n" + json.dumps({
        "suggestions": [
            {"name": "tamari", "note": "gluten-free soy sauce alternative"}
        ]
    }) + "\n```"

    def fake_ask(q, recipe, system_prompt=None, model=None):
        return sample

    monkeypatch.setattr(rh, "ask_openai", fake_ask)
    monkeypatch.setattr(rh, "USE_OPENAI", True)

    out = rh.suggest_substitute("soy sauce")
    assert "tamari" in out
    assert "gluten-free soy sauce alternative" in out


def test_openai_returns_invalid_json(monkeypatch):
    # Simulate OpenAI returning non-JSON text
    sample = "Sure — try tamari or coconut aminos (both work well)"

    def fake_ask(q, recipe, system_prompt=None, model=None):
        return sample

    monkeypatch.setattr(rh, "ask_openai", fake_ask)
    monkeypatch.setattr(rh, "USE_OPENAI", True)

    out = rh.suggest_substitute("soy sauce")
    # If parsing fails, function returns raw text
    assert "tamari" in out or "coconut aminos" in out


def test_openai_json_flag_returns_schema_even_on_invalid(monkeypatch):
    # Simulate OpenAI returning non-JSON text but request JSON output
    sample = "Sure — try tamari or coconut aminos (both work well)"

    def fake_ask(q, recipe, system_prompt=None, model=None):
        return sample

    monkeypatch.setattr(rh, "ask_openai", fake_ask)
    monkeypatch.setattr(rh, "USE_OPENAI", True)
    monkeypatch.setattr(rh, "OPENAI_JSON", True)

    out = rh.suggest_substitute("soy sauce")
    # Should be valid JSON with suggestions key
    data = json.loads(out)
    assert isinstance(data, dict)
    assert "suggestions" in data
    assert isinstance(data["suggestions"], list)
    assert len(data["suggestions"]) >= 1
