# V2 架构实现说明

本文对应你的 3 个落地项：

1. 双仓目录骨架
2. `feature_auth` Clean + Riverpod 示例
3. `core_network` 鉴权/刷新 token 插件实现草案

## 1. 双仓目录骨架

```text
template_v2/
  member_app_template/
  mobile_core_sdk/
```

- `member_app_template`：公司业务模板 App 仓。
- `mobile_core_sdk`：独立 Git 管理的核心插件仓。

> 真正落地时建议拆成两个独立远端仓库：
> - `mobile-member-template-app`
> - `mobile-core-sdk`

## 2. 业务仓关键规则（Clean + Riverpod）

- 每个 feature 内部强制三层：`presentation/domain/data`
- `domain` 不依赖 Flutter/Dio
- `presentation` 仅通过 usecase 调用 domain
- `data` 实现 domain repository 接口
- 依赖方向：`presentation -> domain <- data`

## 3. core 插件仓关键规则

- `core_network`：网络协议、鉴权、刷新 token、错误规约
- `core_storage`：统一存储协议（secure + kv + cache）
- `core_ui_kit`：主题 token + 通用组件
- `core_foundation`：Result/Failure 等基础类型
- `core_testkit`：测试工具集

## 4. 迁移顺序（从旧 GetX 到新模板）

1. 先完成 app shell + auth feature + core_network
2. 再迁移 hotel（最复杂）
3. 再迁移 financial + notice_contract
4. 最后迁移 identity/tax/profile

## 5. 工具链约束

- Flutter 固定：`3.35.1`
- Dart 固定：`3.9.0`
- 全部命令使用 `fvm` 前缀（如 `fvm flutter test`、`fvm dart test`）

## 6. UI 基准（后续所有页面统一遵循）

- UI 风格：遵循 iOS 交互与视觉标准，面向日本及国际市场审美。
- 必须支持 Light / Dark 模式。
- 字体、颜色、间距、圆角统一沉淀在 `mobile_core_sdk/packages/core_ui_kit`。
- 通用控件（弹框、底部弹框等）统一由 `core_ui_kit` 提供，不在业务侧重复实现。
- 业务页面优先复用 SDK 组件，再做业务差异化皮肤。

## 7. API 来源与实现规范（Funding / Hotel 分离）

- 酒店业务接口与基金/会员业务接口分开治理，不混用来源。
- 基金/会员业务（含登录、注册、用户资料）接口来源以 funding Swagger 为准：
  - Swagger UI：`https://sit-admin.gutingjun.com/api/swagger-ui.html#/`
  - OpenAPI：`https://sit-admin.gutingjun.com/api/crowdfunding/v2/api-docs`
- 用户相关实现优先查阅 `user-rest` 与 `off-rest` 两个分组。
- 除酒店业务外，不再以老工程 `http_conf.dart` 作为新接口实现来源。
- 若 Swagger 暂缺某接口，允许短期使用真实抓包/线上样例报文作为补充，但必须：
  - 在 `member_app_template/README_API.md` 记录请求/响应样例
  - 在代码常量/数据源注释标记“临时来源”
  - 后续拿到 Swagger 定义后及时回收
- `api_paths.dart` 中的接口常量命名应体现业务来源（如 funding auth/user），避免继续使用 `legacy` 命名。



## 阶段一任务：

1. 先把 Core SDK 做到“可发布可复用”
    .完成 core_storage 真正实现（flutter_secure_storage + shared_preferences 适配器），替换内存 TokenStore。
    .补齐 core_network 错误模型与并发刷新测试（401 并发、多次重试、刷新失败统一登出）。
    .给 mobile_core_sdk 增加版本发布规范（melos + changelog + tag 流程）。
    .关键文件起点：token_refresh_interceptor.dart、storage_contract.dart。
2. 完成 App 基础设施（模板必须具备）
    .环境与 Flavor：dev/staging/prod 配置、baseUrl 注入。
    .路由守卫：未登录跳 /login，已登录跳 /home。
    .统一错误展示、日志埋点入口。
    .关键文件起点：bootstrap.dart、app_router.dart。
3. 把 feature_auth 做成第一个完整闭环（可上线质量）
    .接入真实接口（验证码发送、登录、refresh、登出）。
    .启动恢复登录态（冷启动自动判定路由）。
    .补 Widget/集成测试（不仅是 controller 单测）。
    .关键文件起点：auth_providers.dart。
4. 再迁移第一个业务纵切片（建议先“首页只读”）
    .推荐顺序：home(会议+待办数) -> hotel list/detail(只读) -> booking+payment。
    .理财和合同放在酒店下单链路后迁移，风险更低。
5. 立刻补 CI（防止模板失控）
