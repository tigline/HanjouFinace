# FUNDEX

# API 相关报文数据

## 来源与范围（重要）

- 基金/会员相关（含登录、注册、用户资料）接口来源以 funding Swagger 为准：
  - Swagger UI: `https://sit-admin.gutingjun.com/api/swagger-ui.html#/`
  - OpenAPI JSON: `https://sit-admin.gutingjun.com/api/crowdfunding/v2/api-docs`
- 用户相关主要查看：
  - `user-rest`
  - `off-rest`
- 除酒店业务外，后续 API 实现不再以老工程 `http_conf.dart` 作为来源。
- 本文件的作用是补充“真实请求/响应样例报文”，用于 DTO/错误处理/兼容性测试；若与 Swagger 冲突，以 Swagger 为准，并在此文件更新样例。

- 1.登录与Token 获取
  - [HTTP] REQ POST:
  https://testoa.gutingjun.com/api/uaa/oauth/token 
  headers={content-type: application/x-www-form-urlencoded, Authorization: ***} query={} body={"password":"2508","username":"Aaron.hou@51fanxing.co.jp","grant_type":"password","auth_type":"email","scope":"app"}

  - Response:
  {"msg":"success","code":200,"data":
    {
      "access_token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiJBYXJvbi5ob3VANTFmYW54aW5nLmNvLmpwIiwibWVtYmVyTGV2ZWwiOjEwLCJzY29wZSI6WyJhcHAiXSwibW9iaWxlIjpudWxsLCJ1c2VuYW1lIjoiQWFyb24uaG91QDUxZmFueGluZy5jby5qcCIsImV4cCI6MTc3MTk2NDkyNCwidXNlcklkIjoxMjY1NzUsImF1dGhvcml0aWVzIjpbIm1lbWJlciIsInN1cGVyIiwiYWRtaW4iLCJlbXBsb3llZSJdLCJqdGkiOiJiYmMwYzc2Ni1jNzI0LTQ4YTMtOWQ3MS0yMGIwOGMzMmE4ZTIiLCJjbGllbnRfaWQiOiJ3ZWJBcHAiLCJpbnRsVGVsQ29kZSI6IiJ9.hDSOxrqI76lEAVIfoB1MzCT21Bt0Ik5ppir21S2e-mI",
      "token_type" : "bearer",
      "refresh_token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiJBYXJvbi5ob3VANTFmYW54aW5nLmNvLmpwIiwibWVtYmVyTGV2ZWwiOjEwLCJzY29wZSI6WyJhcHAiXSwiYXRpIjoiYmJjMGM3NjYtYzcyNC00OGEzLTlkNzEtMjBiMDhjMzJhOGUyIiwibW9iaWxlIjpudWxsLCJ1c2VuYW1lIjoiQWFyb24uaG91QDUxZmFueGluZy5jby5qcCIsImV4cCI6MTc3NDUxMzcyNCwidXNlcklkIjoxMjY1NzUsImF1dGhvcml0aWVzIjpbIm1lbWJlciIsInN1cGVyIiwiYWRtaW4iLCJlbXBsb3llZSJdLCJqdGkiOiJjNmY1YzhjNy0zYTkwLTQyMzQtYjJlYi1hNTg2MDFhMTQ1NzkiLCJjbGllbnRfaWQiOiJ3ZWJBcHAiLCJpbnRsVGVsQ29kZSI6IiJ9._5KHCNChlLhXL20PLmyi-IGfODZzVxE9rJgt7h8Bgb0",
      "expires_in" : 43199,
      "scope" : "app",
      "mobile" : null,
      "usename" : "Aaron.hou@51fanxing.co.jp",
      "userId" : 126575,
      "memberLevel" : 10,
      "intlTelCode" : "",
      "jti" : "bbc0c766-c724-48a3-9d71-20b08c32a8e2"
    }
  }

- 2.获取用户数据
  [HTTP] REQ GET https://testoa.gutingjun.com/api/crowdfunding/user/index
  authorization:
  bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiIwODAwMDAwMDAwMyIsIm1lbWJlckxld....
  
  - Response:
  {
    "msg": "success",
    "code": 200,
    "data": {
        "id": "438786029784006656",
        "memberId": 125530,
        "accountId": "0125530",
        "email": "dennis.diao@51fanxing.co.jp",
        "firstName": "张",
        "lastName": "冠李戴",
        "firstNameEn": "AAAAA",
        "lastNameEn": "DDDDD",
        "katakana": "カタカナd",
        "taxRadio": 0.2042,
        "expiredTime": "2026-03-05",
        "taxcountry": "日本",
        "nationality": "中国",
        "taxOffice": "",
        "sex": 1,
        "liveJp": 1,
        "intlTelCode": 81,
        "phone": "09085309521",
        "birthday": "1994-02-10",
        "zipCode": "5370011",
        "address": "東今里１－７－２４",
        "bank": null,
        "registerTime": "2023-01-16 11:25:44",
        "checkEmailTime": "2023-01-16 11:28:48",
        "baseinfoTime": "2024-05-16 13:09:27",
        "checkBaseinfoTime": "2024-05-16 13:16:21",
        "status": 4,
        "frontUrl": "https://s3-ap-northeast-1.amazonaws.com/gutingjun/ESTATE_SIT/crowdfunding/id/438786171462615040.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20260226T042621Z&X-Amz-SignedHeaders=host&X-Amz-Expires=38018&X-Amz-Credential=AKIAQCBDBFIFTQ7QHL5V%2F20260226%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Signature=4bedcaccdd8d51ca902140f1952bc9d04272105ec47b012b47bb9b9630fd3af9",
        "backUrl": "https://s3-ap-northeast-1.amazonaws.com/gutingjun/ESTATE_SIT/crowdfunding/id/438786171516616704.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20260226T042621Z&X-Amz-SignedHeaders=host&X-Amz-Expires=38018&X-Amz-Credential=AKIAQCBDBFIFTQ7QHL5V%2F20260226%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Signature=c52f63b8b9a99dba6f857c020ffb59e8d392516eba6b6ba52d7f18621c69e2f1",
        "taxpayerNumber": "",
        "taxpayerManageStatus": 1
    }
}

- 3.注册
  - 待补：请按 funding Swagger（`user-rest` / `off-rest`）实际接口定义与真实报文补充。

- 4.获取验证码
  - [HTTP] REQ GET https://testoa.gutingjun.com/api/member/user/emailLoginCode?email=Aaron.hou%4051fanxing.co.jp headers={content-type: application/json} query={email: Aaron.hou@51fanxing.co.jp} body=null

  - Response:
  {"msg":"success","code":200,"data":true}
