param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[0-9a-fA-F]{24}$')]
    [string]$ProjectId,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[0-9a-fA-F]{24}$')]
    [string]$SprintId,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath,

    [ValidateRange(1, 200)]
    [int]$PageSize = 50
)

$ErrorActionPreference = 'Stop'
$outputFile = [System.IO.Path]::GetFullPath($OutputPath)
if (Test-Path -LiteralPath $outputFile) {
    throw "Output file already exists: $outputFile. Choose another path."
}

$originalConsoleEncoding = [Console]::OutputEncoding
$utf8 = New-Object System.Text.UTF8Encoding($false)
$tokens = @{}
$ids = @{}
$tasks = [System.Collections.Generic.List[object]]::new()
$pageToken = ''
$pageCount = 0
$tql = "sprintId = '$SprintId' AND isArchived = false"

try {
    [Console]::OutputEncoding = $utf8
    $OutputEncoding = $utf8

    do {
        $pageCount++
        if ($pageCount -gt 200) { throw 'Stopped after 200 pages; pagination did not finish.' }

        $cliArgs = @('project', 'task-query', '--project-id', $ProjectId,
            '--tql', $tql, '--page-size', [string]$PageSize,
            '--enrich-fields', 'sfc,tfs', '--json')
        if ($pageToken) { $cliArgs += @('--page-token', $pageToken) }

        $raw = & teambition-cli @cliArgs
        if ($LASTEXITCODE -ne 0) { throw "Teambition query failed on page $pageCount." }
        try {
            $response = ($raw -join "`n") | ConvertFrom-Json -ErrorAction Stop
        } catch {
            throw "Invalid JSON on page $pageCount. Check the CLI output and PowerShell UTF-8 decoding: $($_.Exception.Message)"
        }
        if ($response.code -ne 200 -or $response.errorCode) {
            throw "Teambition returned code $($response.code), errorCode $($response.errorCode) on page $pageCount."
        }

        foreach ($task in $response.result) {
            if (-not $task.id -or $task.projectId -ne $ProjectId -or $task.sprintId -ne $SprintId) {
                throw "Unexpected task scope or missing ID on page $pageCount; no output was saved."
            }
            if ($ids.ContainsKey([string]$task.id)) { throw "Duplicate task ID $($task.id); no output was saved." }
            $ids[[string]$task.id] = $true
            $tasks.Add($task)
        }

        Write-Host "Page $pageCount complete; tasks collected: $($tasks.Count)"
        $pageToken = [string]$response.nextPageToken
        if ($pageToken) {
            if ($tokens.ContainsKey($pageToken)) { throw 'Repeated page token; pagination did not finish.' }
            $tokens[$pageToken] = $true
        }
    } while ($pageToken)

    $directory = [System.IO.Path]::GetDirectoryName($outputFile)
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
    [ordered]@{
        projectId = $ProjectId
        sprintId = $SprintId
        pageCount = $pageCount
        taskCount = $tasks.Count
        tasks = $tasks.ToArray()
    } | ConvertTo-Json -Depth 50 | Set-Content -LiteralPath $outputFile -Encoding utf8
    Write-Host "Complete. Saved $($tasks.Count) tasks to $outputFile"
} finally {
    [Console]::OutputEncoding = $originalConsoleEncoding
}
