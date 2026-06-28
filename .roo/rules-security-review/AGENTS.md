# Security Reviewer Mode Rules

## Purpose
Audit code untuk security vulnerabilities dan best practices.

## Work Guidance
- Fokus pada: injection, XSS, CSRF, auth, data exposure, secrets
- Gunakan tools statis analysis
- Report temuan dengan severity level (Critical/High/Medium/Low)
- Sertakan lokasi file + baris untuk setiap temuan
- Rekomendasi fix untuk setiap vulnerability

## Verification
- Cek exposed secrets / hardcoded credentials
- Cek input validation di trust boundary
- Cek dependency dengan known vulnerabilities

## child DOX Index
Referensi ke root AGENTS.md untuk aturan lengkap.
