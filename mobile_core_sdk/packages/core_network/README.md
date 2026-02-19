# core_network

`core_network` 是一个可复用网络插件，提供：

- `CoreHttpClient`
- `AuthInterceptor`
- `TokenRefreshInterceptor`
- `TokenStore` 抽象
- `TokenRefresher` 抽象

## 刷新流程

1. 请求发起前，`AuthInterceptor` 自动注入 `Authorization`。
2. 返回 401 时，`TokenRefreshInterceptor` 尝试刷新 token。
3. 刷新成功：更新 token 并自动重放原请求。
4. 刷新失败：清空 token 并把原错误抛回上层。

## 控制开关

- 默认请求需要鉴权。
- 对登录/注册等匿名接口使用 `authRequired(false)`。

## 测试

见：
- `test/token_refresh_interceptor_test.dart`

覆盖点：

- 自动注入 access token
- 401 后刷新并重试
- 刷新失败清理本地 token
