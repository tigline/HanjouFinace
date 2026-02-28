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

- 5.获取Fund 产品列表

Request URL
https://testoa.gutingjun.com/api/crowdfunding/offline/project/list
Request Method GET

Response
{
    "msg": "success",
    "code": 200,
    "data": [
        {
            "id": "453461223669231137",
            "projectName": "繁星優選Fund商品20241123",
            "expectedDistributionRatioMax": 0.02,
            "expectedDistributionRatioMin": 0.01,
            "expectedDistributionRatioTaxMax": null,
            "expectedDistributionRatioTaxMin": null,
            "investmentPeriod": "１４ヶ月",
            "scheduledStartDate": "2024-05-01",
            "scheduledEndDate": "2026-09-30",
            "distributionDate": null,
            "typeOfOffering": null,
            "offeringStartDatetime": "2024-03-15 12:00:00",
            "offeringEndDatetime": "2024-04-30 17:59:00",
            "offeringMethod": null,
            "investmentUnit": 100000,
            "maximumInvestmentPerPerson": 100,
            "createTime": "2024-12-03 19:12:04",
            "achievementRate": 1.01,
            "amountApplication": 10000000,
            "currentlySubscribed": 10100000,
            "daysRemaining": 0,
            "photos": [],
            "investorTypeList": [
                {
                    "id": "45045227042211224",
                    "projectId": "453461223669231137",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者A",
                    "earningsType": "FLOATING",
                    "earningsRadio": 0.0,
                    "interestRadio": 0.0,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 2,
                    "currentAmountApplication": 5000000
                },
                {
                    "id": "45045227042211125",
                    "projectId": "453461223669231137",
                    "investorType": "BORROWING",
                    "investorCode": "優先出資者B",
                    "earningsType": "FIXED",
                    "earningsRadio": 0.055,
                    "interestRadio": 0.055,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 3,
                    "currentAmountApplication": 3000000
                },
                {
                    "id": "45045227042211125",
                    "projectId": "453461223669231137",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者B",
                    "earningsType": "FIXED",
                    "earningsRadio": 0.055,
                    "interestRadio": 0.0,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 3,
                    "currentAmountApplication": 3000000
                },
                {
                    "id": "45045227042111126",
                    "projectId": "453461223669231137",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者C",
                    "earningsType": "FIXED",
                    "earningsRadio": 0.05,
                    "interestRadio": 0.0,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 2,
                    "currentAmountApplication": 2000000
                }
            ],
            "projectStatus": 4,
            "operatingCompany": "運営会社",
            "operatingCompanyAccount": 127005,
            "createUser": "刁文阳",
            "updateTime": "2024-12-12 15:16:36",
            "currentOpenInvestor": null,
            "updateUser": "刁文阳",
            "detail": "{}",
            "times": 10,
            "pdfs": [
                {
                    "projectId": "453461223669231137",
                    "type": 1,
                    "desc": "契約成立前書面",
                    "urls": null
                },
                {
                    "projectId": "453461223669231137",
                    "type": 2,
                    "desc": "電子取引に係る重要事項説明書",
                    "urls": null
                },
                {
                    "projectId": "453461223669231137",
                    "type": 3,
                    "desc": "契約成立時書面",
                    "urls": null
                }
            ],
            "liveJapanBank": {
                "id": null,
                "bankType": null,
                "relatedId": null,
                "bankAccountOwnerName": null,
                "bankAccountOwnerAddress": null,
                "bankAccountOwnerNationality": null,
                "bankAccountSwiftCode": null,
                "bankName": null,
                "branchBankName": null,
                "branchBankAddress": null,
                "bankCountry": null,
                "branchBankNumber": null,
                "bankNumber": null,
                "bankAccountType": null,
                "liveType": null
            },
            "notLiveJapanBank": {
                "id": null,
                "bankType": null,
                "relatedId": null,
                "bankAccountOwnerName": null,
                "bankAccountOwnerAddress": null,
                "bankAccountOwnerNationality": null,
                "bankAccountSwiftCode": null,
                "bankName": null,
                "branchBankName": null,
                "branchBankAddress": null,
                "bankCountry": null,
                "branchBankNumber": null,
                "bankNumber": null,
                "bankAccountType": null,
                "liveType": null
            },
            "accountId": "48978",
            "periodType": "SEASON"
        },
        
    ]
}

- 6.fund 项目详情

    - Request URL
    https://testoa.gutingjun.com/api/crowdfunding/offline/project/detail?id=453461223669231137
    Request Method
    GET
    - Response
    {
    "msg": "success",
    "code": 200,
    "data": {
        "id": "453461223669231137",
        "projectName": "繁星優選Fund商品20241123",
        "expectedDistributionRatioMax": 0.02,
        "expectedDistributionRatioMin": 0.01,
        "expectedDistributionRatioTaxMax": null,
        "expectedDistributionRatioTaxMin": null,
        "investmentPeriod": "１４ヶ月",
        "scheduledStartDate": "2024-05-01",
        "scheduledEndDate": "2026-09-30",
        "distributionDate": null,
        "typeOfOffering": null,
        "offeringStartDatetime": "2024-03-15 12:00:00",
        "offeringEndDatetime": "2024-04-30 17:59:00",
        "offeringMethod": null,
        "investmentUnit": 100000,
        "maximumInvestmentPerPerson": 100,
        "createTime": "2024-12-03 19:12:04",
        "achievementRate": 1.01,
        "amountApplication": 10000000,
        "currentlySubscribed": 10100000,
        "daysRemaining": 0,
        "photos": [],
        "investorTypeList": [
            {
                "id": "45045227042211224",
                "projectId": "453461223669231137",
                "investorType": "INVESTMENT",
                "investorCode": "優先出資者A",
                "earningsType": "FLOATING",
                "earningsRadio": 0.0,
                "interestRadio": 0.0,
                "remark": null,
                "isOpen": false,
                "isOpenType": 2,
                "currentAmountApplication": 5000000
            },
            {
                "id": "45045227042211125",
                "projectId": "453461223669231137",
                "investorType": "BORROWING",
                "investorCode": "優先出資者B",
                "earningsType": "FIXED",
                "earningsRadio": 0.055,
                "interestRadio": 0.055,
                "remark": null,
                "isOpen": false,
                "isOpenType": 3,
                "currentAmountApplication": 3000000
            },
            {
                "id": "45045227042211125",
                "projectId": "453461223669231137",
                "investorType": "INVESTMENT",
                "investorCode": "優先出資者B",
                "earningsType": "FIXED",
                "earningsRadio": 0.055,
                "interestRadio": 0.0,
                "remark": null,
                "isOpen": false,
                "isOpenType": 3,
                "currentAmountApplication": 3000000
            },
            {
                "id": "45045227042111126",
                "projectId": "453461223669231137",
                "investorType": "INVESTMENT",
                "investorCode": "優先出資者C",
                "earningsType": "FIXED",
                "earningsRadio": 0.05,
                "interestRadio": 0.0,
                "remark": null,
                "isOpen": false,
                "isOpenType": 2,
                "currentAmountApplication": 2000000
            }
        ],
        "projectStatus": 4,
        "operatingCompany": "運営会社",
        "operatingCompanyAccount": 127005,
        "createUser": "刁文阳",
        "updateTime": "2024-12-12 15:16:36",
        "currentOpenInvestor": null,
        "updateUser": "刁文阳",
        "detail": "{}",
        "times": 10,
        "pdfs": [
            {
                "projectId": "453461223669231137",
                "type": 1,
                "desc": "契約成立前書面",
                "urls": null
            },
            {
                "projectId": "453461223669231137",
                "type": 2,
                "desc": "電子取引に係る重要事項説明書",
                "urls": null
            },
            {
                "projectId": "453461223669231137",
                "type": 3,
                "desc": "契約成立時書面",
                "urls": null
            }
        ],
        "liveJapanBank": {
            "id": null,
            "bankType": null,
            "relatedId": null,
            "bankAccountOwnerName": null,
            "bankAccountOwnerAddress": null,
            "bankAccountOwnerNationality": null,
            "bankAccountSwiftCode": null,
            "bankName": null,
            "branchBankName": null,
            "branchBankAddress": null,
            "bankCountry": null,
            "branchBankNumber": null,
            "bankNumber": null,
            "bankAccountType": null,
            "liveType": null
        },
        "notLiveJapanBank": {
            "id": null,
            "bankType": null,
            "relatedId": null,
            "bankAccountOwnerName": null,
            "bankAccountOwnerAddress": null,
            "bankAccountOwnerNationality": null,
            "bankAccountSwiftCode": null,
            "bankName": null,
            "branchBankName": null,
            "branchBankAddress": null,
            "bankCountry": null,
            "branchBankNumber": null,
            "bankNumber": null,
            "bankAccountType": null,
            "liveType": null
        },
        "accountId": "48978",
        "periodType": "SEASON",
        "apply": null
    }
}


