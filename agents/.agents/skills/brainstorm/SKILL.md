---
name: brainstorm
description: "Use before creative work when requirements are unclear or trade-offs matter. Prefer brief clarification and a short execution plan by default."
---

# Brainstorm Ideas Into Designs

## Overview

Help turn ideas into implementable designs through concise collaborative dialogue.

Start by understanding only the necessary context. Ask up to three questions only if needed. Once the direction is clear, present a short plan (3-5 bullets max) unless the user asks for a detailed spec.

## The Process

**Understanding the idea:**

- Check only the minimum relevant project context first (files/docs directly related to the request)
- Ask questions only when the answer changes implementation choices
- Prefer at most 1-2 questions; use up to 3 only if necessary
- Prefer multiple choice questions when possible (listing choices with lowercase letters like a, b, c), but open-ended is fine too
- Focus on understanding: purpose, constraints, success criteria

**Exploring approaches:**

- Propose 1 recommended approach by default
- Mention alternatives only when there is a significant trade-off
- Present options conversationally with your recommendation
- Lead with your recommended option (always the 1st)
- Keep reasoning brief (1-3 sentences)

**Presenting the plan:**

- Present a short execution plan by default (3-5 bullets max)
- Include only what is needed to start implementation
- Cover architecture/components/data flow/error handling/testing only if they are materially impacted
- Expand into sections only when the user asks for more detail or the task is high risk
- Be ready to go back and clarify if something doesn't make sense

## After the Plan

**Implementation (if continuing):**

- If the user is asking for planning/validation: ask "Aprova esse plano?"
- If the user is asking for implementation directly: proceed after a brief plan summary

## Key Principles

- **Max of three questions (numbered) at a time** - Don't overwhelm with multiple questions
- **Multiple choice (using lowercase letters) preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Default to 1 approach; only add another when trade-offs are real and balanced
- **Default to brevity** - Short plan first; expand only on request
- **Execution over ceremony** - If the request is clear, move to implementation quickly
- **Be flexible** - Go back and clarify when something doesn't make sense
