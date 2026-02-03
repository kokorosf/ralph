# How Ralph Works with Cursor

## Visual Flow

```
┌──────────────────┐
│  Your Terminal   │
│  (ralph-cursor)  │
└────────┬─────────┘
         │
         │ 1. Starts iteration
         │
         ▼
┌─────────────────────────────────┐
│  Generates prompt file:         │
│  .ralph-prompt-iter-1.md        │
│                                 │
│  Contains:                      │
│  - Ralph instructions           │
│  - Current PRD status           │
│  - Next user story to implement │
└─────────────────────────────────┘
         │
         │ 2. Script pauses
         │
         ▼
┌─────────────────────────────────┐
│  YOU manually:                  │
│  1. Open Cursor Composer        │
│  2. Paste the prompt            │
│  3. Wait for Claude             │
└─────────────────────────────────┘
         │
         │ 3. Claude implements
         │
         ▼
┌─────────────────────────────────┐
│  Cursor/Claude:                 │
│  - Reads prd.json               │
│  - Implements US-001            │
│  - Updates files                │
│  - Marks story complete         │
│  - Updates progress.txt         │
│  - Commits changes              │
└─────────────────────────────────┘
         │
         │ 4. You verify & confirm
         │
         ▼
┌─────────────────────────────────┐
│  Terminal:                      │
│  Type 'done' to continue        │
└─────────────────────────────────┘
         │
         │ 5. Next iteration starts
         │
         ▼
    [Repeat for each story]
```

## Example Session

### Terminal Output:
```bash
$ ./ralph-cursor.sh 3

╔════════════════════════════════════════════════════════╗
║  Ralph for Cursor - Autonomous Coding Agent           ║
╚════════════════════════════════════════════════════════╝

Max iterations: 3

═══════════════════════════════════════════════════════
  Iteration 1 of 3
═══════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────┐
│  CURSOR COMPOSER INSTRUCTIONS                       │
└─────────────────────────────────────────────────────┘

1. Open Cursor Composer (Cmd+Shift+I / Ctrl+Shift+I)
2. Copy and paste the prompt from:
   .ralph-prompt-iter-1-20260120-143022.md

3. Wait for Claude to complete the user story
4. Verify the changes
5. Type 'done' to continue

Status: done
✓ Iteration 1 marked as complete
Remaining stories: 14

═══════════════════════════════════════════════════════
  Iteration 2 of 3
═══════════════════════════════════════════════════════

[... repeats ...]
```

### What Claude Does in Cursor:

When you paste the prompt into Cursor Composer, Claude will:

1. **Read the PRD**
   ```
   "I can see prd.json has 15 user stories. 
   The highest priority incomplete story is US-001: 
   Snowflake Connection Configuration Interface..."
   ```

2. **Create project structure**
   ```
   "I'll set up a Next.js project with TypeScript and 
   Snowflake SDK integration..."
   ```

3. **Implement the story**
   ```
   "Creating components/SnowflakeConnectionForm.tsx..."
   [Creates files, writes code]
   ```

4. **Run tests**
   ```
   "Running npm test..."
   ```

5. **Update PRD**
   ```
   "Marking US-001 as complete in prd.json..."
   ```

6. **Log progress**
   ```
   "Adding entry to progress.txt..."
   ```

7. **Commit**
   ```
   "Committing: feat: US-001 - Data Source Configuration Interface"
   ```

### Files After Iteration 1:

```
autonomous-analytics/
├── prd.json                          # US-001 now has passes: true
├── progress.txt                      # New entry added
├── src/
│   ├── app/
│   │   └── page.tsx                 # Landing page
│   ├── components/
│   │   └── SnowflakeConnectionForm.tsx  # NEW: Snowflake config form
│   └── lib/
│       ├── snowflake.ts             # NEW: Snowflake connector
│       └── db.ts                    # App database utilities
├── package.json
└── .git/
    └── [new commit]
```

### progress.txt After Iteration 1:

```markdown
# Ralph Progress Log
Started: 2026-01-20

## Codebase Patterns
- Use Snowflake SDK for all data warehouse connections
- Store Snowflake credentials encrypted in PostgreSQL
- UI components use shadcn/ui
- n8n workflows will be configured in US-002

---

## 2026-01-20 14:30 - US-001
Thread: N/A (Cursor local)
- Implemented Snowflake connection configuration interface
- Created SnowflakeConnectionForm component with credential input
- Added secure credential storage with encryption
- Set up connection testing functionality
- **Learnings for future iterations:**
  - This project uses Next.js 14 with App Router
  - All forms should use react-hook-form for validation
  - Snowflake credentials stored encrypted in PostgreSQL
  - Test connection before saving using snowflake-sdk
---
```

## Advantages of This Approach

✅ **Local execution** - Runs on your machine, full control
✅ **Uses Cursor** - Leverage your existing Cursor setup
✅ **Manual oversight** - You verify each iteration
✅ **Git integration** - Each story is a commit
✅ **Incremental** - Work on stories one at a time
✅ **Resumable** - Can stop and continue later

## Next Steps

1. Download the files from Claude
2. Set up your project directory
3. Run `./ralph-cursor.sh 3` for first 3 stories
4. Review Claude's work
5. Continue with more iterations!
