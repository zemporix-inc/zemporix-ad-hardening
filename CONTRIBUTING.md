# Contributing

Every new rule needs a stable control ID, rationale, read-only discovery
function, expected value and Pester coverage. Remediation must be idempotent
and must support `-WhatIf`. Changes affecting trust relationships, privileged
groups or authentication protocols need a rollback note.
