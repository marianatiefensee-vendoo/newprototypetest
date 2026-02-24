# Crosslisting app import workspace

I could not access the source archive referenced in the IDE context (`/Users/marianatiefensee/Downloads/Crosslisting app prototype (Copy).zip`) from this container, so I prepared this repository to make import + Vercel setup straightforward.

## Import the project archive

```bash
./scripts/import-project.sh "/path/to/Crosslisting app prototype (Copy).zip"
```

This script will:
- Unzip the archive into this repo root.
- Preserve `.git` and helper files already in this repository.
- Generate a minimal `vercel.json` (if none exists) using Vercel's default build detection.

## Deploy to Vercel

```bash
vercel
```

For production deploy:

```bash
vercel --prod
```
