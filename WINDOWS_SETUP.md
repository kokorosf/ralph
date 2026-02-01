# Ralph + Cursor Setup Guide (Windows)

This guide shows you how to run Ralph (autonomous coding agent) on Windows using Cursor.

## Quick Start

### 1. Prerequisites

**No additional software needed!** PowerShell comes with Windows.

Optional (for JSON manipulation if needed):
```powershell
# Install jq via Chocolatey (optional)
choco install jq
```

### 2. Set Up Your Project

```powershell
# Create project directory
mkdir autonomous-analytics
cd autonomous-analytics

# Download these files from Claude and place them here:
# - prd.json
# - progress.txt
# - ralph-cursor.ps1
# - prompt.md

# No need to set permissions - PowerShell scripts work automatically
```

**Important**: If you get "script execution disabled" error, run this once:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 3. Initialize Git (Optional but Recommended)

```powershell
git init
git checkout -b ralph/autonomous-analytics
```

### 4. Run Ralph

```powershell
.\ralph-cursor.ps1 5  # Run 5 iterations
```

### 5. For Each Iteration

The script will pause and show:

```
┌─────────────────────────────────────────────────────┐
│  CURSOR COMPOSER INSTRUCTIONS                       │
└─────────────────────────────────────────────────────┘

1. Open Cursor Composer (Ctrl+Shift+I)
2. Copy prompt from: .ralph-prompt-iter-1-xxxxx.md
3. Paste into Composer
4. Wait for Claude to complete
5. Type 'done' to continue
```

**Do this:**
- Open Cursor Composer (`Ctrl+Shift+I`)
- Copy the prompt from the file shown
- Paste into Composer and press Enter
- Wait for Claude to implement the story
- Verify the changes
- Return to PowerShell and type `done`

## Commands Reference

```powershell
# Run Ralph
.\ralph-cursor.ps1 5              # 5 iterations
.\ralph-cursor.ps1 15             # 15 iterations

# Check progress
Get-Content progress.txt          # View progress log

# View PRD
Get-Content prd.json | ConvertFrom-Json | ConvertTo-Json -Depth 10

# Count incomplete stories
$prd = Get-Content prd.json | ConvertFrom-Json
($prd.userStories | Where-Object { $_.passes -eq $false }).Count

# Mark a story as complete (manual fix if needed)
$prd = Get-Content prd.json | ConvertFrom-Json
($prd.userStories | Where-Object { $_.id -eq "US-001" }).passes = $true
$prd | ConvertTo-Json -Depth 10 | Set-Content prd.json
```

## Project Structure

```
autonomous-analytics\
├── prd.json                          # Product requirements
├── progress.txt                      # Progress log
├── prompt.md                         # Ralph instructions
├── ralph-cursor.ps1                  # Ralph script (PowerShell)
├── .ralph-iterations.log             # Iteration history
├── .last-branch                      # Branch tracking
└── src\                              # Your code (created by Ralph)
    ├── components\
    ├── app\
    └── ...
```

## What Ralph Will Build

Your autonomous analytics platform with Snowflake + n8n:
1. ✅ Snowflake connection configuration UI
2. ✅ n8n workflow automation setup
3. ✅ AI-powered insights from Snowflake data
4. ✅ Automated visualizations querying Snowflake
5. ✅ Interactive dashboards with Snowflake backend
6. ✅ Automated report generation via n8n (PDF/PPTX)
7. ✅ Client self-service portal with Snowflake access
8. ✅ Smart alerting via n8n workflows
9. ✅ Natural language to SQL queries for Snowflake
10. ✅ Plus 5 more features... (15 total)

## Troubleshooting

### "Scripts are disabled on this system"

Run PowerShell as Administrator and execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Then answer "Y" to confirm.

### "Cannot find path"

Make sure you're in the correct directory:
```powershell
cd path\to\autonomous-analytics
```

### View prompt file easily

```powershell
# Open in Notepad
notepad .ralph-prompt-iter-1-20260120-143022.md

# Or display in console
Get-Content .ralph-prompt-iter-1-20260120-143022.md
```

### Copy prompt to clipboard

```powershell
Get-Content .ralph-prompt-iter-1-20260120-143022.md | Set-Clipboard
# Now just Ctrl+V in Cursor Composer
```

### Story keeps failing

1. Check `progress.txt` for errors
2. Manually fix the issue
3. Mark story complete:
   ```powershell
   $prd = Get-Content prd.json | ConvertFrom-Json
   ($prd.userStories | Where-Object { $_.id -eq "US-001" }).passes = $true
   $prd | ConvertTo-Json -Depth 10 | Set-Content prd.json
   ```
4. Continue Ralph: `.\ralph-cursor.ps1 10`

### Reset all stories to incomplete

```powershell
$prd = Get-Content prd.json | ConvertFrom-Json
foreach ($story in $prd.userStories) {
    $story.passes = $false
}
$prd | ConvertTo-Json -Depth 10 | Set-Content prd.json

# Clear progress log
@"
# Ralph Progress Log
Started: $(Get-Date)
---
"@ | Set-Content progress.txt
```

## Tips for Success

1. **Start small**: Run 3-5 iterations first to see how it works
2. **Review changes**: Always check what Claude did before continuing
3. **Commit often**: Use git to track Ralph's progress
4. **Use Windows Terminal**: Better than cmd.exe for colored output
5. **Monitor quality**: Check that tests pass and code is clean

## PowerShell Tips

### Use clipboard for easy copy-paste
```powershell
# Copy prompt to clipboard
Get-Content .ralph-prompt-iter-1-*.md | Set-Clipboard

# Now just paste in Cursor with Ctrl+V
```

### Open files in VS Code
```powershell
code progress.txt
code prd.json
```

### Quick status check
```powershell
# Create a helper function (add to your PowerShell profile)
function Get-RalphStatus {
    $prd = Get-Content prd.json | ConvertFrom-Json
    $total = $prd.userStories.Count
    $complete = ($prd.userStories | Where-Object { $_.passes -eq $true }).Count
    $incomplete = $total - $complete
    
    Write-Host "Progress: $complete / $total stories complete"
    Write-Host "Remaining: $incomplete stories"
    Write-Host ""
    Write-Host "Incomplete stories:"
    $prd.userStories | Where-Object { $_.passes -eq $false } | 
        ForEach-Object { Write-Host "  - $($_.id): $($_.title)" }
}

# Usage
Get-RalphStatus
```

## Next Steps

After setup:
```powershell
.\ralph-cursor.ps1 5
```

Happy autonomous coding! 🚀
