# Discussion X Sync Roadmap

Last updated: 2026-06-23

## Scope

Allow an authenticated StellaVia member to connect one X account and choose
whether a new top-level discussion post is also published to that X account.
Replies are out of scope for the first release.

## Architecture Decisions

- X OAuth uses Authorization Code with PKCE through the backend.
- The backend owns X access and refresh tokens. The Flutter app never receives
  or stores them.
- Each StellaVia member binds their own X account.
- Discussion publishing is the primary operation. X synchronization is an
  asynchronous secondary operation and must not roll back a successful
  discussion post.
- App-side X account code lives in `features/social_account`; discussion code
  consumes connection state and a publish-time `syncToX` option later.
- Reusable backend API clients and DTOs live in `company_api_runtime`.

## Current App Foundation

Implemented:

- Typed X account connection, binding-attempt, and binding-status DTOs.
- Backend API client and app Clean Architecture vertical slice.
- Settings entry and X account connection page.
- External-browser authorization launch.
- `stellavia://oauth/x/result` callback registration on Android and iOS.
- Cold-start and runtime callback capture through `app_links`.
- Callback matching by one-time `attemptId`; no X code or token enters the app.

## Provisional Backend Contract

The following paths are integration assumptions until backend Swagger or a
confirmed contract is available:

```text
POST   /member/social/x/auth/start
GET    /member/social/x/auth/status?attemptId=...
GET    /member/social/x/account
DELETE /member/social/x/account
```

`auth/start` accepts:

```json
{"callbackUri":"stellavia://oauth/x/result"}
```

It returns `attemptId`, `authorizationUrl`, and optional `expiresAt`. The
backend callback must redirect to the app callback with only `attemptId` and a
result value. It must never place an authorization code or token in that URI.

## Next Tickets

1. Confirm paths, methods, envelope success codes, callback redirect behavior,
   and account/status payloads with the backend.
2. Replace the custom scheme with verified Universal Links/App Links before
   production if the product web domains can host AASA and assetlinks files.
3. Change discussion send to return a typed result containing `commentId` and
   X sync job status.
4. Add `syncToX` to top-level post submission and expose a composer toggle only
   for connected accounts.
5. Add queued/succeeded/failed sync status, idempotency, retry UX, and focused
   tests.
