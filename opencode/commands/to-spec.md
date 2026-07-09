---
name: to-spec
description: Turn the current session into a spec and publish it to the project tracker — no interview, just synthesis of what you've already discussed.
---

This skill takes the current conversation context and codebase understanding and produces a spec (you may know this document as a PRD). Do NOT interview the user — just synthesize what you already know.

If the project tracker is unclear, ask the user where to store the spec.

$ARGUMENTS

## Process

1. Explore the repo to understand the current state of the codebase.

2. Sketch out the seams at which you're going to test the feature. Existing seams should be preferred to new ones. Use the highest seam possible. If new seams are needed, propose them at the highest point you can. The fewer seams across the codebase, the better - the ideal number is one.

Check with the user that these seams match their expectations.

3. Write the spec using the template below, then publish it to the project tracker.

<spec-template>

## Problem

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## Success Criteria

A structured list of measurable outcomes and quality standards that must be met to consider this spec "done" or "successful".

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The domain objects that will be built/modified
- The interfaces of those objects that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which paths will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this spec.

## Further Notes

Any further notes about the feature.

</spec-template>
