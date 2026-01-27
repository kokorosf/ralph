$ErrorActionPreference = "Stop"

param(
  [int]$MaxIterations = 10
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$prdFile = Join-Path $scriptDir "prd.json"
$progressFile = Join-Path $scriptDir "progress.txt"
$archiveDir = Join-Path $scriptDir "archive"
$lastBranchFile = Join-Path $scriptDir ".last-branch"
$promptFile = Join-Path $scriptDir "prompt.md"
$codexBin = if ($env:CODEX_BIN) { $env:CODEX_BIN } else { "codex" }

function Resolve-CodexBin {
  param(
    [string]$BinName
  )

  $command = Get-Command $BinName -ErrorAction SilentlyContinue
  if ($command) {
    return $command.Source
  }

  if (-not $BinName.EndsWith(".exe")) {
    $exeCommand = Get-Command "$BinName.exe" -ErrorAction SilentlyContinue
    if ($exeCommand) {
      return $exeCommand.Source
    }
  }

  throw "codex CLI not found. Ensure codex.exe is installed and on PATH, or set CODEX_BIN."
}

$codexBin = Resolve-CodexBin -BinName $codexBin

function Get-BranchName {
  param(
    [string]$Path
  )

  if (-not (Test-Path $Path)) {
    return $null
  }

  $raw = Get-Content $Path -Raw
  if (-not $raw) {
    return $null
  }

  try {
    $json = $raw | ConvertFrom-Json
  } catch {
    return $null
  }

  return $json.branchName
}

# Archive previous run if branch changed
if ((Test-Path $prdFile) -and (Test-Path $lastBranchFile)) {
  $currentBranch = Get-BranchName -Path $prdFile
  $lastBranch = Get-Content $lastBranchFile -ErrorAction SilentlyContinue

  if ($currentBranch -and $lastBranch -and ($currentBranch -ne $lastBranch)) {
    $dateStamp = Get-Date -Format "yyyy-MM-dd"
    $folderName = $lastBranch -replace "^ralph/", ""
    $archiveFolder = Join-Path $archiveDir "$dateStamp-$folderName"

    Write-Host "Archiving previous run: $lastBranch"
    New-Item -ItemType Directory -Force -Path $archiveFolder | Out-Null
    if (Test-Path $prdFile) { Copy-Item $prdFile $archiveFolder }
    if (Test-Path $progressFile) { Copy-Item $progressFile $archiveFolder }
    Write-Host "   Archived to: $archiveFolder"

    "# Ralph Progress Log" | Set-Content $progressFile
    "Started: $(Get-Date)" | Add-Content $progressFile
    "---" | Add-Content $progressFile
  }
}

# Track current branch
if (Test-Path $prdFile) {
  $currentBranch = Get-BranchName -Path $prdFile
  if ($currentBranch) {
    $currentBranch | Set-Content $lastBranchFile
  }
}

# Initialize progress file if it doesn't exist
if (-not (Test-Path $progressFile)) {
  "# Ralph Progress Log" | Set-Content $progressFile
  "Started: $(Get-Date)" | Add-Content $progressFile
  "---" | Add-Content $progressFile
}

Write-Host "Starting Ralph - Max iterations: $MaxIterations"

for ($i = 1; $i -le $MaxIterations; $i++) {
  Write-Host ""
  Write-Host "═══════════════════════════════════════════════════════"
  Write-Host "  Ralph Iteration $i of $MaxIterations"
  Write-Host "═══════════════════════════════════════════════════════"

  $outputLines = Get-Content $promptFile -Raw | & $codexBin --dangerously-allow-all 2>&1 | Tee-Object -Variable captured
  $outputText = $outputLines -join "`n"

  if ($outputText -match "<promise>COMPLETE</promise>") {
    Write-Host ""
    Write-Host "Ralph completed all tasks!"
    Write-Host "Completed at iteration $i of $MaxIterations"
    exit 0
  }

  Write-Host "Iteration $i complete. Continuing..."
  Start-Sleep -Seconds 2
}

Write-Host ""
Write-Host "Ralph reached max iterations ($MaxIterations) without completing all tasks."
Write-Host "Check $progressFile for status."
exit 1
