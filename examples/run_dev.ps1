# Выполнить 1000 запросов
for ($n = 1; $n -le 1000; $n++) {
    # Путь к файлу с последним ID
    $idFile = "$PSScriptRoot\last_id.txt"

    # Читаем и инкрементируем ID, либо начинаем с 1
    if (Test-Path $idFile) {
        $id = [int](Get-Content $idFile) + 1
    } else {
        $id = 1
    }
    # Сохраняем новый ID
    Set-Content $idFile $id

    # Формируем тело запроса
    $body = @{
        id          = $id
        date        = "2024-06-15"
        # random in invoice, transaction
        table       = "bill"
        amount      = [math]::Round((Get-Random -Minimum 0 -Maximum 10000), 2)
        invoice_num = Get-Random -Minimum 10000 -Maximum 1000000
    } | ConvertTo-Json

    # Отправляем POST-запрос
    try {
        Invoke-RestMethod -Uri "http://localhost:4195/transactions" -Method Post -Body $body -ContentType "application/json"
        Write-Host "[$n] Request sent with id=$id"
    } catch {
        Write-Host "[$n] Error sending request with id=$id : $($_.Exception.Message)"
    }
}
