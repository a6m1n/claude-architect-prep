---
description: Run an adaptive teach-then-quiz tutoring session, interleaved and weighted toward weak and high-weight domains, driving readiness toward the 720 pass mark.
argument-hint: "[domain | scenario | due | teach-only]"
---
Use the `exam-tutor` skill to run an adaptive session on: $ARGUMENTS

Per concept: teach a cited principle → quiz one fresh MCQ (retrieval-first) → growth-framed feedback naming the trap → update progress via `progress-tracker`. Interleave so no two consecutive items share a domain. Close with the before→after readiness delta, the weakest high-weight domain, and what is due next.
