$src = "workflows/job-intelligence-system-v1.0.private.json"
$dst = "workflows/job-intelligence-system-v1.0.template.json"

if (!(Test-Path $src)) {
    Write-Host "ERROR: Private workflow file not found: $src"
    exit 1
}

$text = Get-Content -Raw -Encoding UTF8 $src

# Replace email addresses
$text = [regex]::Replace(
    $text,
    '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}',
    'YOUR_EMAIL_ACCOUNT'
)

# Replace Telegram bot tokens
$text = [regex]::Replace(
    $text,
    '\b\d{6,14}:[A-Za-z0-9_-]{25,}\b',
    'YOUR_TELEGRAM_BOT_TOKEN'
)

# Replace Google OAuth Client IDs
$text = [regex]::Replace(
    $text,
    '\b[0-9]+-[A-Za-z0-9_-]+\.apps\.googleusercontent\.com\b',
    'YOUR_GOOGLE_CLIENT_ID'
)

# Replace Google OAuth Client Secrets
$text = [regex]::Replace(
    $text,
    '\bGOCSPX-[A-Za-z0-9_-]+\b',
    'YOUR_GOOGLE_CLIENT_SECRET'
)

# Replace Telegram chatId fields
$text = [regex]::Replace(
    $text,
    '(?i)("chatId"\s*:\s*)-?\d+',
    '$1"YOUR_TELEGRAM_CHAT_ID"'
)

$text = [regex]::Replace(
    $text,
    '(?i)("chatId"\s*:\s*")[^"]*(")',
    '$1YOUR_TELEGRAM_CHAT_ID$2'
)

$text = [regex]::Replace(
    $text,
    '(?i)("chat_id"\s*:\s*)-?\d+',
    '$1"YOUR_TELEGRAM_CHAT_ID"'
)

$text = [regex]::Replace(
    $text,
    '(?i)("chat_id"\s*:\s*")[^"]*(")',
    '$1YOUR_TELEGRAM_CHAT_ID$2'
)

# Replace hardcoded account variable in Code nodes
$text = [regex]::Replace(
    $text,
    "const account = '.*?';",
    "const account = 'YOUR_EMAIL_ACCOUNT';"
)

[System.IO.File]::WriteAllText(
    [System.IO.Path]::GetFullPath($dst),
    $text,
    [System.Text.UTF8Encoding]::new($false)
)

Write-Host "Sanitized template created: $dst"
