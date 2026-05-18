$file = "workflows/job-intelligence-system-v1.0.template.json"

if (!(Test-Path $file)) {
    Write-Host "ERROR: File not found: $file"
    exit 1
}

$json = Get-Content -Raw -Encoding UTF8 $file | ConvertFrom-Json

# Keep only the clean public demo branch
$keepNodes = @(
    "Schedule Trigger",
    "Emails 1",
    "HTML",
    "Merge",
    "Aggregate",
    "Code in JavaScript",
    "E1",
    "Mark a message as read"
)

$json.nodes = @($json.nodes | Where-Object { $keepNodes -contains $_.name })

# Rebuild connections cleanly for one Gmail branch
$json.connections = [ordered]@{
    "Schedule Trigger" = @{
        "main" = @(
            @(
                @{
                    "node" = "Emails 1"
                    "type" = "main"
                    "index" = 0
                }
            )
        )
    }

    "Emails 1" = @{
        "main" = @(
            @(
                @{
                    "node" = "HTML"
                    "type" = "main"
                    "index" = 0
                },
                @{
                    "node" = "Merge"
                    "type" = "main"
                    "index" = 1
                },
                @{
                    "node" = "Mark a message as read"
                    "type" = "main"
                    "index" = 0
                }
            )
        )
    }

    "HTML" = @{
        "main" = @(
            @(
                @{
                    "node" = "Merge"
                    "type" = "main"
                    "index" = 0
                }
            )
        )
    }

    "Merge" = @{
        "main" = @(
            @(
                @{
                    "node" = "Aggregate"
                    "type" = "main"
                    "index" = 0
                }
            )
        )
    }

    "Aggregate" = @{
        "main" = @(
            @(
                @{
                    "node" = "Code in JavaScript"
                    "type" = "main"
                    "index" = 0
                }
            )
        )
    }

    "Code in JavaScript" = @{
        "main" = @(
            @(
                @{
                    "node" = "E1"
                    "type" = "main"
                    "index" = 0
                }
            )
        )
    }

    "E1" = @{
        "main" = @(
            @()
        )
    }

    "Mark a message as read" = @{
        "main" = @(
            @()
        )
    }
}

# Keep public template inactive
if ($json.PSObject.Properties.Name -contains "active") {
    $json.active = $false
}

# Remove top-level instance metadata if present
$json.PSObject.Properties.Remove("id")
$json.PSObject.Properties.Remove("versionId")
$json.PSObject.Properties.Remove("meta")

# Remove node webhook IDs and ensure credential placeholders
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

Write-Host "Simplified workflow template to one clean Gmail branch."
