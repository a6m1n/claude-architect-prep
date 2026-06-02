---
description: Generate and administer fresh exam-style multiple-choice questions one at a time (retrieval-first), then grade each with elaborated, doc-cited feedback. Use to drill or test a domain, scenario, concept, or due/weak items.
argument-hint: "[domain | scenario | concept | due | weak] [count]"
---
Use the `quiz-me` skill to quiz the user on: $ARGUMENTS

One question at a time. Present the stem + four options and reveal nothing until the user answers. Then grade: name the chosen distractor's archetype and why it fails here, why the key wins, and cite an official doc. Record each attempt via `progress-tracker`. Default to 5 questions if no count is given.
