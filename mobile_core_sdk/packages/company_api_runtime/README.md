# company_api_runtime

Company-level API runtime helpers.

Current scope:
- legacy envelope parsing (`code/msg/data`)
- success-code profile support (`0` / `200` / mixed)
- common paged rows extraction (`data.rows`, `rows`)
- shared discussion-board API client and DTOs
- shared investment API client and DTOs
- shared `user_investment` API client and DTOs

Codegen baseline:
- `freezed_annotation` + `json_annotation` in `dependencies`
- `freezed` + `json_serializable` + `build_runner` in `dev_dependencies`
- example: `lib/src/discussion_board/discussion_comment_dto.dart` (generated files in same folder)
