//
//  HttpCommunicateDefine.h
//  MumMum
//
//  Created by shlity on 16/6/16.
//  Copyright © 2016年 Moresing Inc. All rights reserved.
//

#ifndef GoddessClock_HttpCommunicateDefine_h
#define GoddessClock_HttpCommunicateDefine_h

typedef NS_ENUM (NSInteger , HttpResponseCode)
{
    HttpResponseOk = 0,
    HttpResponseError,
    HttpResponseLoginError,
    HttpResponseCnout
};

#define URL_BASE          @"http://test.baicaio.com/?g=api"
//#define URL_BASE         @"http://baicai.ccyou.cc/?g=api"//测试接口

#define UNSUCCESS_REQUEST(Dict) [[Dict[@"state"] stringValue] isEqualToString:@"10000"]
#define SUCCESS_REQUEST(Dict) [[Dict[@"state"] stringValue] isEqualToString:@"10001"]
#define SUCCESS_REQUEST2(Dict) [[Dict[@"state"] stringValue] isEqualToString:@"10002"]


//http后缀
typedef NS_ENUM(NSInteger,HTTP_COMMAND_LIST){
    //用户模块
    HTTP_USER_API,
    //优惠模块
    HTTP_SHOP_API,
    //原创模块
    HTTP_ORIGINAL_API,

    /*******************/
    HTTP_METHOD_RESERVE,
    HTTP_METHOD_COUNT
};

//#ifdef __ONLY_FOR_HTTP_COMMUNICATE__
//****************************************************************************/

static char cHttpMethod[HTTP_METHOD_COUNT][64] = {
    "&m=user&a=init",
    "&m=shop&a=init",
    "&m=article&a=init",
};

/*****************************************************************************/

typedef NS_ENUM(NSUInteger,ServiceStatusTypeDefine){
    
    ServiceStatusTypeWaitingDefine = 1,
    ServiceStatusTypeWorkingDefine,
    ServiceStatusTypeFinishedDefine,
    ServiceStatusTypeDefineCount,
};

#endif
