$ErrorActionPreference = "Stop"

$RepoPath = "C:\Users\sunpu\Desktop\pycson\00_GITHUB_FOOTPRINTS\pycson-footprints"
$ExpectedRemote = "git@github.com:PYCSON/pycson-footprints.git"
$RequiredSshCommand = "ssh -i C:/Users/sunpu/.ssh/id_ed25519 -o IdentitiesOnly=yes -o UserKnownHostsFile=C:/Users/sunpu/.ssh/known_hosts -o StrictHostKeyChecking=accept-new"

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "== $Message =="
}

function Run-Git {
    param([string[]]$Args)
    & git @Args
    if ($LASTEXITCODE -ne 0) {
        throw "git command failed: git $($Args -join ' ')"
    }
}

Write-Host "PYCSON SAFE PUSH FINALIZE"
Write-Host "This helper only finalizes Git export for already committed safe footprint artifacts."
Write-Host "It does not run PYCSON stages, patch UI, fetch markets, calculate EV, or trade/order."

if (!(Test-Path -LiteralPath $RepoPath)) {
    throw "Footprint repo not found: $RepoPath"
}

Set-Location -LiteralPath $RepoPath

Write-Step "Confirm remote"
$remoteFetch = (& git remote get-url origin).Trim()
$remotePush = (& git remote get-url --push origin).Trim()
Write-Host "origin fetch: $remoteFetch"
Write-Host "origin push : $remotePush"
if ($remoteFetch -ne $ExpectedRemote -or $remotePush -ne $ExpectedRemote) {
    throw "Remote mismatch. Expected origin fetch/push to be $ExpectedRemote"
}

Write-Step "Confirm SSH command"
$currentSshCommand = (& git config --local --get core.sshCommand) -join ""
if ([string]::IsNullOrWhiteSpace($currentSshCommand)) {
    Write-Host "core.sshCommand missing; setting required command."
    Run-Git @("config", "--local", "core.sshCommand", $RequiredSshCommand)
    $currentSshCommand = (& git config --local --get core.sshCommand) -join ""
}
Write-Host "core.sshCommand: $currentSshCommand"
if ($currentSshCommand -ne $RequiredSshCommand) {
    throw "core.sshCommand mismatch. Refusing to push."
}

Write-Step "Confirm longpaths"
Run-Git @("config", "--local", "core.longpaths", "true")
$longpaths = (& git config --local --get core.longpaths).Trim()
Write-Host "core.longpaths: $longpaths"
if ($longpaths -ne "true") {
    throw "core.longpaths is not true."
}

Write-Step "Pre-push status"
$statusBefore = (& git -c core.longpaths=true status -sb) -join "`n"
Write-Host $statusBefore
$dirtyLines = (& git -c core.longpaths=true status --porcelain)
if ($dirtyLines.Count -gt 0) {
    throw "Worktree has uncommitted changes. Commit safe artifacts with Codex before running this helper."
}

Write-Step "Push"
Run-Git @("-c", "core.longpaths=true", "push", "origin", "main")

Write-Step "Fetch"
Run-Git @("-c", "core.longpaths=true", "fetch", "origin", "main")

Write-Step "Verify"
$head = (& git -c core.longpaths=true rev-parse HEAD).Trim()
$origin = (& git -c core.longpaths=true rev-parse origin/main).Trim()
$statusAfter = (& git -c core.longpaths=true status -sb) -join "`n"
Write-Host "HEAD       : $head"
Write-Host "origin/main: $origin"
Write-Host $statusAfter

if ($head -eq $origin -and $statusAfter -eq "## main...origin/main") {
    Write-Host ""
    Write-Host "PASS"
    Write-Host "NEXT_SAFE_STEP: Return to Codex and ask it to continue from the now-synced PYCSON anchor."
    exit 0
}

Write-Host ""
Write-Host "HOLD"
Write-Host "NEXT_SAFE_STEP: Return to Codex with this terminal output for git sync review."
exit 1
