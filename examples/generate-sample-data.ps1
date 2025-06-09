param(
    [int]$Count = 300
)

$OutputDir = "gen_data"
if (-Not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

$tableOptions = @("credit_memo", "bill", "bill_payment", "invoice", "payment")
$recordsPerFile = 100
$totalFiles = [Math]::Ceiling($Count / $recordsPerFile)

for ($fileIndex = 0; $fileIndex -lt $totalFiles; $fileIndex++) {
    $records = @()

    for ($i = 1; $i -le $recordsPerFile; $i++) {
        $globalIndex = $fileIndex * $recordsPerFile + $i
        if ($globalIndex -gt $Count) { break }

        $record = @{
            value = @{
                id = $globalIndex
                table = Get-Random -InputObject $tableOptions
                invoice_num = Get-Random -Minimum 1 -Maximum 999
                date = (Get-Date -Year 2024 -Month (Get-Random -Minimum 1 -Maximum 13) -Day (Get-Random -Minimum 1 -Maximum 29)).ToString("yyyy-MM-dd")
                amount = [Math]::Round((Get-Random -Minimum 100 -Maximum 1000) + (Get-Random), 2)
            }
        }

        $records += $record
    }

    $result = @{ records = $records }
    $fileName = Join-Path $OutputDir "output_$($fileIndex + 1).json"
    $result | ConvertTo-Json -Depth 3 | Set-Content -Path $fileName -Encoding UTF8

    Write-Host "Created $fileName with $($records.Count) records"
}
