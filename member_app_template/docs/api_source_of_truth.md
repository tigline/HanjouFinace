# API Source Of Truth（Funding / Hotel）

## 1. 范围划分

- `hotel` 业务接口：按酒店业务独立来源治理（不在本文展开）。
- `funding`（基金/会员/认证/用户资料）业务接口：统一以 funding Swagger 为准。

## 2. Funding Swagger（SIT）

- Swagger UI: `https://sit-admin.gutingjun.com/api/swagger-ui.html#/`
- OpenAPI JSON: `https://sit-admin.gutingjun.com/api/crowdfunding/v2/api-docs`

用户相关实现重点查看：

- `user-rest`
- `off-rest`

## 3. 实现规则（必须遵循）

- 除酒店业务外，不再以老工程 `http_conf.dart` 作为 API 来源。
- 新增/修改 funding 接口时，先确认 Swagger 定义，再写 `api_paths.dart` 常量与 DTO。
- 若 Swagger 与真实返回报文不一致：
  - 以 Swagger 作为主定义推进实现；
  - 在 `README_API.md` 补充真实报文样例；
  - 在 DTO / datasource 中增加兼容解析与防崩处理；
  - 在测试中覆盖该兼容场景。
- 若 Swagger 暂无接口定义，临时实现必须在代码注释中标注来源，并在后续替换。

## 4. 当前 auth 维护说明

- 当前 `feature_auth` 的部分路径与响应兼容逻辑是历史迁移阶段产物。
- 后续 auth/register/user profile 的接口收敛，应优先按 funding Swagger 的 `user-rest` / `off-rest` 重新核对和迭代。
