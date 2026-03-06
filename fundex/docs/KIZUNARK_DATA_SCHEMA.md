# KIZUNARK Data Schema Draft

## Core Tables

### `kizunark_threads`
- `id` (string, PK)
- `author_id` (string, FK -> users)
- `body` (text)
- `fund_reference_id` (string, nullable)
- `fund_reference_label` (string, nullable)
- `comment_count` (int)
- `created_at` (datetime)
- `updated_at` (datetime)
- `deleted_at` (datetime, nullable)

### `kizunark_replies`
- `id` (string, PK)
- `thread_id` (string, FK -> kizunark_threads)
- `author_id` (string, FK -> users)
- `body` (text)
- `quote_source_text` (string, nullable)
- `quote_body` (text, nullable)
- `created_at` (datetime)
- `updated_at` (datetime)
- `deleted_at` (datetime, nullable)

### `kizunark_users` (projection from member/account system)
- `id` (string, PK)
- `display_name_masked` (string)
- `account_handle_masked` (string)
- `avatar_text` (string)
- `avatar_gradient_start` (int color)
- `avatar_gradient_end` (int color)
- `badge_label` (string)
- `badge_bg_color` (int color)
- `badge_fg_color` (int color)

## Read/Write Flow (Current App)
1. Load feed request.
2. Read local cache (`discussion_board.threads.<user_scope>`).
3. If cache empty, load static seed (design draft data), save to local cache first, then read back.
4. Update UI from persisted local snapshot.
5. Post/Reply operation writes merged list to local cache first, then UI refreshes from saved snapshot.

## Current Local Mapping
- `DiscussionThread` -> thread row + embedded replies for current local stage.
- `DiscussionReply` -> reply row.
- `DiscussionAuthor` / `DiscussionAuthorBadge` -> user projection used by UI layer.

## Future API Sync Plan
- Pull remote diff by `updated_at`.
- Merge remote -> local (upsert thread/reply).
- Push optimistic local post/reply with temp ids; replace ids after server ack.
- Keep `comment_count` server-authoritative, local increment only as optimistic UI fallback.
