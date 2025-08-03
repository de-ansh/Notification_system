# Docker Fix Summary: Standalone Output Issue

## 🚨 Issue Fixed

**Error**: `⚠ "next start" does not work with "output: standalone" configuration. Use "node .next/standalone/server.js" instead.`

## ✅ Root Cause

The `frontend/Dockerfile.simple` was using `npm start` (which runs `next start`), but with `output: 'standalone'` in `next.config.js`, Next.js creates a standalone server that should be started with `node .next/standalone/server.js`.

## 🔧 Changes Made

### Updated `frontend/Dockerfile.simple`:

**Before:**
```dockerfile
CMD ["npm", "start"]
```

**After:**
```dockerfile
CMD ["node", ".next/standalone/server.js"]
```

### Added Build Verification:
```dockerfile
# Ensure standalone build is working
RUN ls -la .next/standalone
```

## 📋 Files That Were Already Correct

- ✅ `frontend/Dockerfile` - Already using `node server.js`
- ✅ `frontend/Dockerfile.dev` - Uses `npm run dev` (correct for development)
- ✅ `frontend/next.config.js` - Has `output: 'standalone'`

## 🚀 Next Steps

1. **Redeploy your application** in Coolify
2. **The standalone server error should be resolved**
3. **Frontend should start properly** with the correct server command

## 🔍 Why This Happens

When you set `output: 'standalone'` in Next.js config:
- Next.js creates a minimal standalone server in `.next/standalone/`
- This server doesn't require the full Next.js installation
- You must use `node .next/standalone/server.js` instead of `next start`
- This is more efficient for Docker deployments

## ✅ Verification

After deployment, you should see:
- No more standalone output warnings
- Frontend service starts successfully
- Health checks pass
- Application accessible at your Coolify URL 