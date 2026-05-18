# Job Intelligence System

Automated recruiting intelligence workflow built with n8n for monitoring engineering job opportunities and sending structured Telegram notifications.

## Purpose

This project helps track relevant engineering opportunities from Gmail job alerts and converts them into clean Telegram notifications containing job titles and direct application links.

The workflow is focused on roles related to:

- Embedded Systems
- Electronics
- Automation
- Application Engineering
- Hardware Testing
- Software / Python / C++
- Working Student and Internship positions

## Features

- Reads job-alert emails from Gmail
- Extracts job titles and application links from email HTML
- Filters irrelevant links such as privacy pages, unsubscribe links, profile links, and social media links
- Removes duplicate job postings
- Splits long Telegram messages safely without breaking job/link blocks
- Marks processed emails as read to prevent repeated notifications
- Uses a sanitized public workflow template without private credentials

## Tech Stack

- n8n
- JavaScript
- Gmail API
- Telegram Bot API
- HTML extraction
- Git / GitHub

## Workflow Architecture

```text
Schedule Trigger
→ Gmail
→ HTML Extraction
→ Merge
→ Aggregate
→ JavaScript Filtering
→ Telegram Notification
→ Mark Email as Read
```

Repository Structure
```
job-intelligence-system/
│
├── workflows/
│   └── job-intelligence-system-v1.0.template.json
│
├── scripts/
│   └── sanitize_workflow.ps1
│
├── docs/
├── screenshots/
├── notes/
├── .gitignore
├── LICENSE
└── README.md
```
Security

The public workflow file is sanitized. Private values such as Gmail addresses, Telegram chat IDs, OAuth secrets, and bot tokens are not included.

The .private.json workflow export is ignored through .gitignore.

Status

Version 1.0 is operational locally and supports automated job-alert monitoring through Gmail and Telegram.
