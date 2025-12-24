# Release & Versioning Guide

## Understanding Version Numbers

Your app version is defined in `pubspec.yaml`:

```yaml
version: 1.1.0+2
```

| Part | Example | What it means |
|------|---------|---------------|
| **Version Name** | `1.1.0` | What users see in app stores |
| **Build Number** | `+2` | Internal counter (must always increase) |

### Semantic Versioning (MAJOR.MINOR.PATCH)

- **MAJOR** (1.x.x) - Breaking changes, major redesigns
- **MINOR** (x.1.x) - New features
- **PATCH** (x.x.1) - Bug fixes

### Examples

| Scenario | Before | After |
|----------|--------|-------|
| Bug fix | `1.1.0+2` | `1.1.1+3` |
| New feature | `1.1.1+3` | `1.2.0+4` |
| Major redesign | `1.2.0+4` | `2.0.0+5` |

---

## How to Update Version

```bash
# Bug fix (1.1.0 → 1.1.1)
./scripts/bump-version.sh patch

# New feature (1.1.0 → 1.2.0)
./scripts/bump-version.sh minor

# Major release (1.1.0 → 2.0.0)
./scripts/bump-version.sh major
```

---

## Branch Strategy

| Branch | Purpose | CI/CD Action |
|--------|---------|--------------|
| `test` | Testing builds | Build + Distribute to Firebase |
| `main` | Production releases | Build artifacts for App Stores |
| `dev` | Local development | No CI/CD |

---

## Release Checklist

### For Firebase App Distribution (Testing)

1. Bump version: `./scripts/bump-version.sh patch`
2. Commit: `git commit -am "chore: bump version"`
3. Push to test: `git push origin test`
4. CI/CD automatically builds and distributes to testers

### For App Stores (Production)

1. Bump version: `./scripts/bump-version.sh minor`
2. Commit and push to `main`
3. Download artifacts from GitHub Actions
4. Upload to App Store Connect / Google Play Console

---

## GitHub Secrets Setup

Add these in: GitHub repo → Settings → Secrets and variables → Actions

### Required Secrets

| Secret Name | Description |
|-------------|-------------|
| `ENV_FILE` | Contents of your `.env` file |
| `GOOGLE_SERVICES_JSON` | Firebase Android config |
| `GOOGLE_SERVICE_INFO_PLIST` | Firebase iOS config |
| `FIREBASE_SERVICE_ACCOUNT` | Firebase service account JSON |
| `FIREBASE_ANDROID_APP_ID` | e.g., `1:123456:android:abc123` |
| `FIREBASE_IOS_APP_ID` | e.g., `1:123456:ios:abc123` |
| `ANDROID_KEYSTORE_BASE64` | Base64 encoded keystore |
| `ANDROID_KEY_PROPERTIES` | Contents of `key.properties` |

---

## Creating Android Keystore

```bash
keytool -genkey -v \
  -keystore upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

Then encode it for GitHub secrets:

```bash
base64 -i upload-keystore.jks | pbcopy  # Copies to clipboard (macOS)
```

**IMPORTANT:** Backup your keystore securely - you cannot recover it!

---

## Troubleshooting

### "Version code already exists"
→ Run `./scripts/bump-version.sh patch` to increment build number

### "Bundle ID mismatch"
→ Ensure `com.lma.finovateApp` is used in Firebase, Xcode, and Android

### Build fails on CI but works locally
→ Check GitHub Actions logs, verify all secrets are set
