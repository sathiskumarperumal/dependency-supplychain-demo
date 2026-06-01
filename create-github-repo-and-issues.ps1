<#
.SYNOPSIS
    Creates the demo GitHub repo, pushes this project, and files one issue per
    detection category from ISSUES/issues.json.

.DESCRIPTION
    Idempotent: if the repo already exists it is reused; labels and issues are
    created only if missing (issues are matched by exact title).

.PARAMETER Token
    A GitHub PAT with 'repo' scope. If omitted, the GITHUB_TOKEN environment
    variable is used.

.PARAMETER RepoName
    Target repository name. Default: dependency-supplychain-demo

.PARAMETER Private
    Create the repo as private (default is public so reviewers can see issues).

.EXAMPLE
    .\create-github-repo-and-issues.ps1 -Token ghp_xxx
    .\create-github-repo-and-issues.ps1 -Token ghp_xxx -RepoName my-demo -Private
#>
[CmdletBinding()]
param(
    [string]$Token = $env:GITHUB_TOKEN,
    [string]$RepoName = "dependency-supplychain-demo",
    [switch]$Private
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if ([string]::IsNullOrWhiteSpace($Token)) {
    throw "No token. Pass -Token ghp_xxx or set `$env:GITHUB_TOKEN."
}

$headers = @{
    Authorization = "Bearer $Token"
    Accept        = "application/vnd.github+json"
    "User-Agent"  = "depscan-demo-setup"
}

function Invoke-GH {
    param([string]$Method, [string]$Url, $Body)
    $args = @{ Method = $Method; Uri = $Url; Headers = $headers }
    if ($null -ne $Body) { $args.Body = ($Body | ConvertTo-Json -Depth 10) }
    return Invoke-RestMethod @args
}

# 1. Identify the authenticated user --------------------------------------
$me = Invoke-GH GET "https://api.github.com/user"
$owner = $me.login
Write-Host "Authenticated as: $owner" -ForegroundColor Green

# 2. Create (or reuse) the repository -------------------------------------
$repoFull = "$owner/$RepoName"
try {
    $repo = Invoke-GH GET "https://api.github.com/repos/$repoFull"
    Write-Host "Repo already exists: $($repo.html_url)" -ForegroundColor Yellow
}
catch {
    Write-Host "Creating repo $RepoName ..." -ForegroundColor Cyan
    $repo = Invoke-GH POST "https://api.github.com/user/repos" @{
        name        = $RepoName
        description = "Deliberately-vulnerable Java/Maven demo target for the Dependency & Supply-Chain Hygiene plugin"
        private     = [bool]$Private
        auto_init   = $false
        has_issues  = $true
    }
    Write-Host "Created: $($repo.html_url)" -ForegroundColor Green
}

# 3. Push the project (preserve existing local history if present) --------
Push-Location $ScriptDir
try {
    if (-not (Test-Path (Join-Path $ScriptDir ".git"))) {
        git init -b main | Out-Null
    }
    git add -A
    # commit only if there is something staged
    git diff --cached --quiet; if ($LASTEXITCODE -ne 0) {
        git commit -m "Demo: deliberately-vulnerable Java/Maven supply-chain target" | Out-Null
    }
    $remoteUrl = "https://$Token@github.com/$repoFull.git"
    if (git remote | Select-String -SimpleMatch "origin") {
        git remote set-url origin $remoteUrl
    } else {
        git remote add origin $remoteUrl
    }
    git branch -M main
    git push -u origin main
}
finally {
    # scrub the token from the stored remote URL
    git remote set-url origin "https://github.com/$repoFull.git" 2>$null
    Pop-Location
}

# 4. Ensure labels exist --------------------------------------------------
$issues = Get-Content (Join-Path $ScriptDir "ISSUES\issues.json") -Raw | ConvertFrom-Json
$wantedLabels = $issues.labels | ForEach-Object { $_ } | Sort-Object -Unique
$existing = @{}
(Invoke-GH GET "https://api.github.com/repos/$repoFull/labels?per_page=100") |
    ForEach-Object { $existing[$_.name] = $true }
foreach ($lbl in $wantedLabels) {
    if (-not $existing.ContainsKey($lbl)) {
        try {
            Invoke-GH POST "https://api.github.com/repos/$repoFull/labels" @{ name = $lbl; color = "d73a4a" } | Out-Null
            Write-Host "  + label $lbl" -ForegroundColor DarkGray
        } catch { Write-Host "  ! label $lbl skipped" -ForegroundColor DarkYellow }
    }
}

# 5. Create issues (skip ones whose title already exists) -----------------
$open = Invoke-GH GET "https://api.github.com/repos/$repoFull/issues?state=all&per_page=100"
$haveTitles = @{}; $open | ForEach-Object { $haveTitles[$_.title] = $true }

foreach ($it in $issues) {
    if ($haveTitles.ContainsKey($it.title)) {
        Write-Host "= exists: $($it.title)" -ForegroundColor Yellow
        continue
    }
    $body = Get-Content (Join-Path $ScriptDir "ISSUES\$($it.bodyFile)") -Raw
    $created = Invoke-GH POST "https://api.github.com/repos/$repoFull/issues" @{
        title  = $it.title
        body   = $body
        labels = $it.labels
    }
    Write-Host "+ #$($created.number) $($it.title)" -ForegroundColor Green
}

Write-Host "`nDone. $($repo.html_url)/issues" -ForegroundColor Green
