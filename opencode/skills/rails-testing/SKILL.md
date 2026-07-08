---
name: rails-testing
description: User preferences for writing backend Ruby on Rails tests. Use when writing, updating, or removing backend tests for models, controllers, jobs, etc.
---

- Prefer lambdas over string expressions for `assert_difference`, `assert_change`, and their permutations.
- Prefer inline variables in test cases over top-level helper methods when referencing fixtures or test objects.
