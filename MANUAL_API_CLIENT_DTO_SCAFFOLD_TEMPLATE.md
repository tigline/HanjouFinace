# 手写 API Client / DTO 实施规范模板

适用范围：

- 当前上游 Swagger 不稳定或字段质量不一致阶段。
- 继续采用手写 `client + DTO`，保证业务可控与可迭代。
- 目标产物放在 `mobile_core_sdk/packages/company_api_runtime`，App 侧只做薄适配。

---

## 1. 输入（给实现者 / 未来 Skill）

每次新增接口前，先补齐以下输入：

```yaml
task_id: user_investment_apply_list
cluster: oa | member | hotel
swagger_url: https://sit-admin.gutingjun.com/api/crowdfunding/v2/api-docs
swagger_tag: user-rest
operation_ids:
  - applyListUsingPOST1
path: /crowdfunding/user/apply/list
method: POST
auth_required: true
request_schema:
  startPage: int
  limit: int
response_schema:
  code: int|string
  msg: string
  data:
    rows: list<object>
success_codes: ["200"] # member 常见为 ["0","200"]
pagination: data.rows
fallback_message: Failed to load member apply list.
```

必填最小集：

- `cluster`
- `path + method`
- `request_schema`
- `response_schema`
- `success_codes`
- `fallback_message`

---

## 2. 产物清单（标准落盘）

以 `foo` 领域为例：

- `mobile_core_sdk/packages/company_api_runtime/lib/src/foo/foo_api_client.dart`
- `mobile_core_sdk/packages/company_api_runtime/lib/src/foo/foo_dtos.dart`
- `mobile_core_sdk/packages/company_api_runtime/test/foo_api_client_test.dart`
- `fundex/lib/features/<feature>/data/datasources/<feature>_remote_data_source.dart`（仅薄适配）

说明：

- `paths` 常量、请求方法、envelope 解析在 `*_api_client.dart`。
- DTO 与容错字段映射在 `*_dtos.dart`。
- App 业务层不重复写 envelope 解析，不重复拼 path。

---

## 3. API Client 模板（可复制）

```dart
import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'foo_dtos.dart';

typedef DioForPath = Dio Function(String path);

class FooApiPaths {
  const FooApiPaths._();

  static const String list = '/crowdfunding/foo/list';
}

class FooApiClient {
  FooApiClient({
    required DioForPath dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
    LegacyPageProfile? pageProfile,
    this.listPath = FooApiPaths.list,
  }) : _dioForPath = dioForPath,
       _envelopeCodec = envelopeCodec ?? const LegacyEnvelopeCodec(),
       _pageProfile = pageProfile ?? const LegacyPageProfile();

  final DioForPath _dioForPath;
  final LegacyEnvelopeCodec _envelopeCodec;
  final LegacyPageProfile _pageProfile;

  final String listPath;

  Future<List<FooItemDto>> fetchList({
    int startPage = 1,
    int limit = 20,
  }) async {
    final response = await _dioForPath(listPath).post<Map<String, dynamic>>(
      listPath,
      data: <String, dynamic>{'startPage': startPage, 'limit': limit},
      options: authRequired(true),
    );

    final rows = _envelopeCodec.extractPagedRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to load foo list.',
      pageProfile: _pageProfile,
    );
    return rows
        .map((Map<String, dynamic> row) => FooItemDto.fromJson(row))
        .toList(growable: false);
  }
}
```

---

## 4. DTO 模板（当前推荐：容错手写）

```dart
class FooItemDto {
  const FooItemDto({
    required this.id,
    required this.name,
    this.amount,
    this.status,
  });

  factory FooItemDto.fromJson(Map<String, dynamic> json) {
    return FooItemDto(
      id: _stringOrEmpty(json['id']),
      name: _stringOrEmpty(json['name']),
      amount: _numOrNull(json['amount']),
      status: _intOrNull(json['status']),
    );
  }

  final String id;
  final String name;
  final num? amount;
  final int? status;
}

String _stringOrEmpty(dynamic value) => value?.toString().trim() ?? '';
int? _intOrNull(dynamic value) => int.tryParse(value?.toString() ?? '');
num? _numOrNull(dynamic value) => num.tryParse(value?.toString() ?? '');
```

说明：

- 上游字段漂移期，优先容错解析（字符串数字混用、空值、别名字段）。
- 等字段稳定后，再迁移为 `freezed + json_serializable`。

---

## 5. App 侧 Provider 薄适配模板

```dart
final fooApiClientProvider = Provider<FooApiClient>((ref) {
  final router = ref.watch(apiClusterRouterProvider);
  return FooApiClient(
    dioForPath: router.dioForPath,
    envelopeCodec: const LegacyEnvelopeCodec(
      profile: CompanyApiResponseProfiles.oa,
    ),
  );
});
```

规则：

- App 侧只注入 `dioForPath` 和 profile，不复制 API 逻辑。
- feature datasource 直接委托 `FooApiClient`。

---

## 6. 验收清单（Definition of Done）

- 请求路径、方法、参数与 Swagger 一致。
- `authRequired(true/false)` 与接口鉴权要求一致。
- envelope 解析策略与集群成功码一致（`0` / `200` / 混合）。
- DTO 对关键字段具备容错（类型漂移不崩溃）。
- 至少 1 个成功用例测试 + 1 个失败用例测试。
- App 薄适配层无重复解析逻辑。

---

## 7. 未来 Skill 流程（Swagger 指派 -> 自动生成骨架）

目标：输入 Swagger 分组和接口，自动产出“可编辑骨架”，由开发者补充细节。

### 7.1 Skill 输入参数

```yaml
cluster: oa|member|hotel
swagger_url: https://.../v2/api-docs
swagger_tag: user-rest
operations:
  - applyListUsingPOST1
module_name: user_investment
target_package: mobile_core_sdk/packages/company_api_runtime
```

### 7.2 Skill 执行步骤

1. 读取 Swagger JSON，筛选 tag + operation。
2. 生成接口清单（path/method/request/response/success code/pagination）。
3. 按本规范落地：
   - `<module>_api_client.dart`
   - `<module>_dtos.dart`
   - `<module>_api_client_test.dart`
4. 使用 `LegacyEnvelopeCodec` 与 `dioForPath` 模式组装代码。
5. 输出变更摘要与待人工确认项（字段歧义、缺失定义、兼容分支）。

### 7.3 Skill 输出质量门槛

- 代码可编译。
- 不引入 UI 改动。
- 不改动业务路由逻辑。
- 所有 API 路径常量集中在 `ApiPaths`。
- 失败信息有明确 `fallbackMessage`。

---

## 8. 迁移原则（手写 -> OpenAPI 生成）

后续 Swagger 稳定时，按模块迁移到 `company_api_*_gen`：

- 先替换纯 DTO + path 稳定模块。
- 再替换复杂流程模块。
- `core_network`、`LegacyEnvelopeCodec`、`ApiClusterRouter` 继续保留作为运行时基座。
