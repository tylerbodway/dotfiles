---
name: context7-docs
description: Look up library/API documentation using Context7 MCP. Use when needing current documentation, code examples, setup guides, or API references for any programming library or framework.
---

# Context7 Documentation Lookup

Query up-to-date documentation for programming libraries via Context7 MCP.

## Constraints

- Max 3 calls to `context7_resolve-library-id` per question
- Max 3 calls to `context7_query-docs` per question
- No core HTML/CSS docs available - use MDN directly if needed

## Instructions

### For Known Libraries

Use `context7_query-docs` directly with library IDs from the table below:

```
context7_query-docs({
  libraryId: "/rails/rails",
  query: "how to set up authentication"
})
```

### For Unknown Libraries

1. Resolve the library ID first:

   ```
   context7_resolve-library-id({
     libraryName: "fastapi",
     query: "how to create API endpoints"
   })
   ```

2. Use the returned ID to query docs:
   ```
   context7_query-docs({
     libraryId: "/tiangolo/fastapi",
     query: "how to create API endpoints"
   })
   ```

## Common Library IDs

Use these directly with `context7_query-docs`:

| Technology | Library ID                                |
| ---------- | ----------------------------------------- |
| Rails      | `/rails/rails`                            |
| Ruby       | `/websites/ruby-lang_en_4_0`              |
| JavaScript | `/javascript-tutorial/en.javascript.info` |
| Node.js    | `/websites/nodejs_api`                    |
| TypeScript | `/websites/typescriptlang`                |
| React      | `/facebook/react`                         |

For unlisted libraries, use `context7_resolve-library-id` first.

## Query Tips

- Be specific: "how to set up JWT authentication" > "auth"
- Include context: "React useEffect cleanup function examples" > "hooks"
- Ask about specific versions if needed: the libraryId can include version like `/vercel/next.js/v14.3.0`
