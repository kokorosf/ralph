# Ralph for Windows - Quick Start

## 📦 Files You Need

Download all these files:
1. ✅ `ralph-cursor.ps1` - Main PowerShell script
2. ✅ `ralph.bat` - Easy launcher (optional, but recommended)
3. ✅ `prompt.md` - Ralph instructions
4. ✅ `prd.json` - Product requirements
5. ✅ `progress.txt` - Progress tracking
6. ✅ `WINDOWS_SETUP.md` - Detailed guide

## 🚀 3-Step Setup

### Step 1: Create Project Folder
```
1. Create a folder: C:\Projects\autonomous-analytics
2. Put all 6 files in this folder
```

### Step 2: Enable PowerShell Scripts (First Time Only)
```
1. Open PowerShell as Administrator
2. Run: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
3. Type 'Y' and press Enter
```

### Step 3: Run Ralph
```
1. Open PowerShell (regular, not admin)
2. cd C:\Projects\autonomous-analytics
3. Run: .\ralph.bat 5
```

## 💡 What Happens Next

Ralph will:
1. Show you instructions for Cursor Composer
2. Wait for you to paste the prompt in Cursor
3. Wait for Claude to implement the story
4. Ask you to type "done" when ready
5. Move to the next story

## 🎯 Simple Commands

```powershell
# Start Ralph
.\ralph.bat 5         # Run 5 iterations

# Check progress
notepad progress.txt

# See what's left
type prd.json
```

## ⌨️ Keyboard Shortcuts

- **Ctrl+Shift+I** - Open Cursor Composer
- **Ctrl+C** - Copy
- **Ctrl+V** - Paste

## 🆘 Having Issues?

### "Scripts disabled" error
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Can't find files
Make sure you're in the right folder:
```powershell
cd C:\Projects\autonomous-analytics
dir  # Should show all 6 files
```

### Need detailed help?
Open `WINDOWS_SETUP.md` for full documentation

## 📊 What Gets Built

Ralph will build your autonomous analytics platform using Snowflake + n8n:
- Snowflake connection configuration and management
- n8n workflow automation for data orchestration
- AI insights generator querying Snowflake
- Auto-visualization engine from Snowflake data
- Client self-service portal with Snowflake backend
- Automated PDF/PowerPoint reports via n8n
- Text-to-SQL natural language queries
- Alerting workflows monitoring Snowflake metrics
- And 7+ more features!

---

That's it! Run `.\ralph.bat 5` to start! 🎉
