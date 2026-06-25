# Discussion X Sync Roadmap

Last updated: 2026-06-25

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

- Typed X OAuth start and account connection DTOs matching member Swagger.
- Backend API client and app Clean Architecture vertical slice.
- Settings entry and X account connection page.
- KIZUNARK tab entry prompt for authenticated users whose X account is not
  connected. The prompt is shown once per tab visit and links to X settings.
- A per-post "sync to X" switch in the KIZUNARK composer. It defaults off,
  remains disabled until an X account is connected, and is not persisted in
  drafts or user preferences.
- External-browser authorization launch.
- App Universal Link callback registration for
  `https://stellavia.co.jp/app/social/x/callback`, with
  `stellavia://social/x/callback` kept as a fallback.
- When the authorization browser returns the App through the callback URL or
  foreground lifecycle, the App stays on the restored route and queries
  `/social/x/account` with a short bounded retry. `connected` is treated as
  the source of truth.

## Backend Contract

The member Swagger currently defines:

```text
POST   /member/social/x/oauth/start
GET    /member/social/x/oauth/callback?code=...&state=...
GET    /member/social/x/account
```

- `oauth/start` has no request body and returns `R<Map<String, String>>`. The
  App accepts the authorization URL under `authorizationUrl`, `authorizeUrl`,
  `authUrl`, or `url` until the map key is documented explicitly.
- `oauth/callback` is called by X and handled by the backend. The App never
  receives the X authorization code.
- After the backend finishes token exchange, the browser should be redirected
  to the App Universal Link callback URL
  `https://stellavia.co.jp/app/social/x/callback`.
- The App callback URL is registered on iOS through Associated Domains and on
  Android through an HTTPS App Link intent filter:
  - Scheme: `https`
  - Host: `stellavia.co.jp`
  - Path: `/app/social/x/callback`
  - Full URL: `https://stellavia.co.jp/app/social/x/callback`
- The Apple App Site Association file is maintained at
  `docs/apple-app-site-association` and must be deployed to
  `https://stellavia.co.jp/.well-known/apple-app-site-association`.
- `stellavia://social/x/callback` remains supported as a fallback custom
  scheme while backend/browser compatibility is being tested.
- The App treats the callback URL as a completion signal only. It does not use
  the callback to navigate to a specific App route. Final binding state is
  still confirmed through `GET /member/social/x/account`.
- `account` returns `R<SocialXAccountVO>` with `connected`, `username`,
  `displayName`, and `avatarUrl`.
- `DELETE /member/social/x/account` removes the current member's X binding and
  returns `R<Void>` or 204.
- Swagger does not currently define an authorization-status endpoint. The App
  uses `GET /member/social/x/account` as the source of truth.

## Next Tickets

1. Confirm the exact authorization URL key returned by `oauth/start`.
2. Confirm the backend redirect page opens
   `https://stellavia.co.jp/app/social/x/callback` after `oauth/callback`
   completes successfully.
3. Change discussion send to return a typed result containing `commentId` and
   X sync job status.
4. Send the composer `syncToX` selection through top-level post submission.
   The current UI keeps the selection on the in-memory send job but does not
   include it in the backend request yet.
5. Add queued/succeeded/failed sync status, idempotency, retry UX, and focused
   tests.
