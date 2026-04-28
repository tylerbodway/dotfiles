# Diagnostic Patterns

Failure patterns that waste tokens and cause re-prompts. Read this when fixing a pasted prompt or diagnosing why one is underperforming. Fix silently — only flag when the fix changes user intent.

---

## Task Patterns

| #   | Pattern                 | Bad                                    | Fixed                                                                             |
| --- | ----------------------- | -------------------------------------- | --------------------------------------------------------------------------------- |
| 1   | Vague task verb         | "help me with my code"                 | "Refactor `getUserData()` to use async/await and handle null returns"             |
| 2   | Two tasks in one prompt | "explain AND rewrite this function"    | Split: explain first, rewrite second                                              |
| 3   | No success criteria     | "make it better"                       | "Done when it passes existing unit tests and handles null input without throwing" |
| 4   | Over-permissive agent   | "do whatever it takes"                 | Explicit allowed + forbidden actions list                                         |
| 5   | Emotional description   | "it's totally broken, fix it"          | "Throws uncaught TypeError on line 43 when `user` is null"                        |
| 6   | Build-the-whole-thing   | "build my entire app"                  | Break into Prompt 1 (scaffold), Prompt 2 (feature), Prompt 3 (polish)             |
| 7   | Implicit reference      | "now add the other thing we discussed" | Always restate the full task                                                      |

---

## Context Patterns

| #   | Pattern                      | Bad                                      | Fixed                                                                         |
| --- | ---------------------------- | ---------------------------------------- | ----------------------------------------------------------------------------- |
| 8   | Assumed prior knowledge      | "continue where we left off"             | Include Memory Block with prior decisions                                     |
| 9   | No project context           | "write a cover letter"                   | "PM role at B2B fintech, 2yr SWE experience, shipped 3 features as tech lead" |
| 10  | Forgotten stack              | New prompt contradicts prior tech choice | Always include Memory Block with established stack                            |
| 11  | Hallucination invite         | "what do experts say about X?"           | "Cite only sources you are certain of. If uncertain, say so."                 |
| 12  | Undefined audience           | "write something for users"              | "Non-technical B2B buyers, decision-maker level, no coding knowledge"         |
| 13  | No mention of prior failures | (blank)                                  | "I already tried X and it failed because Y. Do not suggest X."                |

---

## Format Patterns

| #   | Pattern               | Bad                         | Fixed                                                                      |
| --- | --------------------- | --------------------------- | -------------------------------------------------------------------------- |
| 14  | Missing output format | "explain this concept"      | "3 bullet points, each under 20 words, with a one-sentence summary at top" |
| 15  | Implicit length       | "write a summary"           | "Write a summary in exactly 3 sentences"                                   |
| 16  | No role assignment    | (blank)                     | "You are a senior backend engineer specializing in Node.js and PostgreSQL" |
| 17  | Vague aesthetic       | "make it look professional" | "Monochrome palette, 16px base, 24px line height, no decorative elements"  |

---

## Scope Patterns

| #   | Pattern                      | Bad                            | Fixed                                                                  |
| --- | ---------------------------- | ------------------------------ | ---------------------------------------------------------------------- |
| 18  | No scope boundary            | "fix my app"                   | "Fix only login form validation in `src/auth.js`. Touch nothing else." |
| 19  | No stack constraints         | "build a React component"      | "React 18, TypeScript strict, no external libraries, Tailwind only"    |
| 20  | No stop condition for agents | "build the whole feature"      | Explicit stop conditions + ✅ checkpoint output after each step        |
| 21  | No file path for IDE AI      | "update the login function"    | "Update `handleLogin()` in `src/pages/Login.tsx` only"                 |
| 22  | Wrong template for tool      | GPT-style prose used in Cursor | Adapt to File-Scope template                                           |
| 23  | Pasting entire codebase      | Full repo context every prompt | Scope to relevant function and file only                               |

---

## Reasoning Patterns

| #   | Pattern                             | Bad                                                         | Fixed                                                                                |
| --- | ----------------------------------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| 24  | No CoT for logic task on Tier 2     | "which approach is better?"                                 | "Think through both approaches step by step before recommending"                     |
| 25  | CoT added to reasoning-native model | "think step by step" sent to o3/R1/Claude extended thinking | Remove it — degrades output                                                          |
| 26  | Expecting cross-session memory      | "you already know my project"                               | Always re-provide the Memory Block                                                   |
| 27  | Contradicting prior work            | New prompt ignores earlier architecture                     | Memory Block with established decisions                                              |
| 28  | No grounding rule for factual tasks | "summarize what experts say about X"                        | "Use only information you are highly confident is accurate. Say [uncertain] if not." |

---

## Agentic Patterns

| #   | Pattern                             | Bad                                                  | Fixed                                                                                                  |
| --- | ----------------------------------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| 29  | No starting state                   | "build me a REST API"                                | "Empty Node.js project, Express installed, `src/app.js` exists"                                        |
| 30  | No target state                     | "add authentication"                                 | "`src/middleware/auth.js` with JWT verify. `POST /login` and `POST /register` in `src/routes/auth.js`" |
| 31  | Silent agent                        | No progress output                                   | "After each step output: ✅ [what was completed]"                                                      |
| 32  | Unlocked filesystem                 | No file restrictions                                 | "Only edit files in `src/`. Do not touch `package.json`, `.env`, or any config."                       |
| 33  | No human review trigger             | Agent decides everything                             | "Stop and ask before: deleting any file, adding any dependency, or changing the database schema"       |
| 34  | Vague first turn on a literal model | "fix the auth bug" with no scope, files, or criteria | Front-load intent, file scope, constraints, and acceptance criteria. Use Template H.                   |
| 35  | Context rot on long sessions        | Correcting in the same session for 60+ turns         | New task = new session. Use rewind/undo instead of correcting mid-flight. Compact context proactively. |
