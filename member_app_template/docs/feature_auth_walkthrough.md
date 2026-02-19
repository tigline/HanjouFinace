# feature_auth 示例说明

## 模块职责

- `domain/entities/auth_session.dart`：登录态实体
- `domain/repositories/auth_repository.dart`：认证仓库接口
- `domain/usecases/*`：发送验证码、验证码登录
- `data/datasources/auth_remote_data_source.dart`：HTTP 调用
- `data/repositories/auth_repository_impl.dart`：仓库实现 + token 落库
- `presentation/controllers/auth_controller.dart`：状态机
- `presentation/state/auth_state.dart`：页面状态
- `presentation/pages/login_page.dart`：UI + 交互

## 可测试性

- Domain: usecase 可用 fake repository 单测。
- Presentation: controller 可用 fake repository 状态流转单测。
- Data: 可在后续补 DTO/数据源 contract test。

## 关键约束

- UI 不直接依赖 Dio。
- 控制器不写导航字符串，导航由 app router 承接。
- 所有登录态写入 `TokenStore`，不直接耦合本地存储实现。
