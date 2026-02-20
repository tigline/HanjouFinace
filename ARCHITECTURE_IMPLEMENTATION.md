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
