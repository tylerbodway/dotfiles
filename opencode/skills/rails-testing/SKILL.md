---
name: rails-minitest
description: User preferences for writing backend Ruby on Rails minitest tests. Use when writing, updating, or removing tests for models, controllers, jobs, etc. Do not use for repos using rspec.
---

### Lambdas over string expressions

Prefer lambdas over string expressions for `assert_difference`, `assert_change`, and their permutations.

```ruby
# Good
assert_difference -> { Person.count }, 2 do
end

# Bad
assert_difference "Person.count" do
end
```

### Inline variables over memoized setup helpers

Class-level memoized test setup helpers make individual tests difficult to reason. With inline variables, each value is transparent and easily referenced.

```ruby
# Good
test "name" do
  person = people(:john)
  assert_equal "John Smith", person.name
end

# Bad
def person
  @person ||= people(:john)
end

test "name" do
  assert_equal "John Smith", person.name
end
```
