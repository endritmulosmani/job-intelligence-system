$file = "workflows/job-intelligence-system-v1.0.template.json"

if (!(Test-Path $file)) {
    Write-Host "ERROR: File not found: $file"
    exit 1
}

$json = Get-Content -Raw -Encoding UTF8 $file | ConvertFrom-Json

# Remove top-level n8n-specific metadata
$json.PSObject.Properties.Remove("id")
$json.PSObject.Properties.Remove("versionId")
$json.PSObject.Properties.Remove("meta")

# Public templates should not be active by default
if ($json.PSObject.Properties.Name -contains "active") {
    $json.active = $false
}

# Clean node-level metadata
foreach ($node in $json.nodes) {
    if ($node.PSObject.Properties.Name -contains "webhookId") {
        $node.PSObject.Properties.Remove("webhookId")
    }

    if ($node.PSObject.Properties.Name -contains "credentials") {
        foreach ($credType in $node.credentials.PSObject.Properties.Name) {
            $node.credentials.$credType.id = "YOUR_CREDENTIAL_ID"
            $node.credentials.$credType.name = "YOUR_CREDENTIAL_NAME"
        }
    }
}

$json | ConvertTo-Json -Depth 100 | Set-Content -Encoding UTF8 $file

Write-Host "Cleaned n8n metadata in: $file"
