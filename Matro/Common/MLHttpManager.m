//
//  MLHttpManager.m
//  Matro
//
//  Created by MR.Huang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLHttpManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "HFSUtility.h"
#import "HFSConstants.h"
#import "NSDatezlModel.h"
#import "NSString+URLZL.h"
#import "CommonHeader.h"
#import "AppDelegate.h"
#import "MLLoginViewController.h"
@implementation MLHttpManager

+ (void)post:(NSString *)url params:(id)params m:(NSString *)m s:(NSString *)s success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:YES];
    mgr.securityPolicy = securityPolicy;
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERID];
    NSString *accessToken = nil;
    if (userID && ![userID isEqualToString:@""]) {
        accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    }
    else{
        accessToken = @"ChnUN7ynJnoJ6K2Z39LtOBtlXkT91r";
    }
    NSString *device_id = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_ID_JIGUANG_LU];
    NSString *device_version = [[NSUserDefaults standardUserDefaults] objectForKey:@"systemVer"];
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"result"];
    NSString *network = [[NSUserDefaults standardUserDefaults] objectForKey:@"status"];
    NSString *device_model = [[NSUserDefaults standardUserDefaults] objectForKey:@"devicemodel"];
    NSString *screen = [[NSUserDefaults standardUserDefaults] objectForKey:@"bounds"];

    NSString * accessTokenStrEncode = [accessToken URLEncodedString];
    NSString *accessTokenStr =[accessTokenStrEncode substringToIndex:12];
    NSString *bbc_token = [[NSUserDefaults standardUserDefaults]objectForKey:KUSERDEFAULT_BBC_ACCESSTOKEN_LIJIA];
    NSTimeInterval timestamp = [[NSDatezlModel sharedInstance] currentTimeDate];
    NSString *signStr =[NSString stringWithFormat:@"%@%@%.f%@",accessTokenStr,m,timestamp,s];
    NSString *sign = [self md5:signStr];

    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *newUrl;
    if ([del.appFlag isEqualToString:@"1"]) {
        newUrl = [NSString stringWithFormat:@"%@&bbc_token=%@&sign=%@&timestamp=%.f&client_type=ios&app_version=%@&device_id=%@&device_version=%@&uuid=%@&device_network=%d&app_audit_flag=1",url,bbc_token,sign,timestamp,vCFBundleShortVersionStr,device_id,device_version,uuid,network.intValue];
    }else{
        newUrl = [NSString stringWithFormat:@"%@&bbc_token=%@&sign=%@&timestamp=%.f&client_type=ios&app_version=%@&device_id=%@&device_version=%@&uuid=%@&device_network=%d",url,bbc_token,sign,timestamp,vCFBundleShortVersionStr,device_id,device_version,uuid,network.intValue];
    }
    NSLog(@"newUrl---->%@",newUrl);
    
    // 2.发送请求
    [mgr POST:newUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"OK === %@",dataDic);
//        NSString *htmlString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",htmlString);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (success) {
            success(dataDic);
//            MLLoginViewController *searchViewController = [[MLLoginViewController alloc]init];
//            searchViewController.hidesBottomBarWhenPushed = YES;
//            searchViewController.isLogin = YES;
//     
//            MLNavigationController *searchNavigationViewController = [[MLNavigationController alloc]initWithRootViewController:searchViewController];
            
//            UIViewController *rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
//            [rootViewController addChildViewController:searchViewController];
//            [rootViewController.view addSubview:searchViewController.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (failure) {
            failure(error);
        }
    }];
}
//上传图片
+ (void)post:(NSString *)url params:(id)params  m:(NSString *)m  s:(NSString *)s sconstructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))block  success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:YES];
    mgr.securityPolicy = securityPolicy;
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERID];
    NSString *accessToken = nil;
    if (userID && ![userID isEqualToString:@""]) {
        accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    }
    else{
        accessToken = @"ChnUN7ynJnoJ6K2Z39LtOBtlXkT91r";
    }
    
    NSString *device_id = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_ID_JIGUANG_LU];
    NSString *device_version = [[NSUserDefaults standardUserDefaults] objectForKey:@"systemVer"];
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"result"];
    NSString *network = [[NSUserDefaults standardUserDefaults] objectForKey:@"status"];
    NSString *device_model = [[NSUserDefaults standardUserDefaults] objectForKey:@"devicemodel"];
    NSString *screen = [[NSUserDefaults standardUserDefaults] objectForKey:@"bounds"];
    
    NSString * accessTokenStrEncode = [accessToken URLEncodedString];
    NSString *accessTokenStr =[accessTokenStrEncode substringToIndex:12];
    NSString *bbc_token = [[NSUserDefaults standardUserDefaults]objectForKey:KUSERDEFAULT_BBC_ACCESSTOKEN_LIJIA];
    NSTimeInterval timestamp = [[NSDatezlModel sharedInstance] currentTimeDate];

    NSString *signStr =[NSString stringWithFormat:@"%@%@%.f%@",accessTokenStr,m,timestamp,s];
    NSString *sign = [self md5:signStr];

    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *newUrl;
    if ([del.appFlag isEqualToString:@"1"]) {
        newUrl = [NSString stringWithFormat:@"%@&bbc_token=%@&sign=%@&timestamp=%.f&client_type=ios&app_version=%@&device_id=%@&device_version=%@&uuid=%@&device_network=%d&app_audit_flag=1",url,bbc_token,sign,timestamp,vCFBundleShortVersionStr,device_id,device_version,uuid,network.intValue];
    }else{
         newUrl = [NSString stringWithFormat:@"%@&bbc_token=%@&sign=%@&timestamp=%.f&client_type=ios&app_version=%@&device_id=%@&device_version=%@&uuid=%@&device_network=%d",url,bbc_token,sign,timestamp,vCFBundleShortVersionStr,device_id,device_version,uuid,network.intValue];
    }
 
    
    [mgr POST:newUrl parameters:params constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"OK === %@",dataDic);
//        NSString *htmlString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",htmlString);
        if (success) {
            success(dataDic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)get:(NSString *)url params:(id)params m:(NSString *)m s:(NSString *)s success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:YES];
    mgr.securityPolicy = securityPolicy;
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUSERDEFAULT_USERID];
    NSString *accessToken = nil;
    if (userID && ![userID isEqualToString:@""]) {
        accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
    }
    else{
        accessToken = @"ChnUN7ynJnoJ6K2Z39LtOBtlXkT91r";
    }

    NSString *device_id = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_ID_JIGUANG_LU];
    NSString *device_version = [[NSUserDefaults standardUserDefaults] objectForKey:@"systemVer"];
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"result"];
    NSString *network = [[NSUserDefaults standardUserDefaults] objectForKey:@"status"];
    NSString *device_model = [[NSUserDefaults standardUserDefaults] objectForKey:@"devicemodel"];
    NSString *screen = [[NSUserDefaults standardUserDefaults] objectForKey:@"bounds"];
    
    NSString * accessTokenStrEncode = [accessToken URLEncodedString];
    NSString *accessTokenStr =[accessTokenStrEncode substringToIndex:12];
    NSString *bbc_token = [[NSUserDefaults standardUserDefaults]objectForKey:KUSERDEFAULT_BBC_ACCESSTOKEN_LIJIA];
    NSTimeInterval timestamp = [[NSDatezlModel sharedInstance] currentTimeDate];
//    NSString *timestamp1 = [[NSUserDefaults standardUserDefaults]objectForKey:KUSERDEFAULT_TIMEINTERVAR_LIJIA];
    NSString *signStr =[NSString stringWithFormat:@"%@%@%.f%@",accessTokenStr,m,timestamp,s];
    NSString *sign = [self md5:signStr];

    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *newUrl;
    if ([del.appFlag isEqualToString:@"1"]) {
        newUrl = [NSString stringWithFormat:@"%@&bbc_token=%@&sign=%@&timestamp=%.f&client_type=ios&app_version=%@&device_id=%@&device_version=%@&uuid=%@&device_network=%d&app_audit_flag=1",url,bbc_token,sign,timestamp,vCFBundleShortVersionStr,device_id,device_version,uuid,network.intValue];
    }else{
        newUrl = [NSString stringWithFormat:@"%@&bbc_token=%@&sign=%@&timestamp=%.f&client_type=ios&app_version=%@&device_id=%@&device_version=%@&uuid=%@&device_network=%d",url,bbc_token,sign,timestamp,vCFBundleShortVersionStr,device_id,device_version,uuid,network.intValue];
    }
    
    // 2.发送请求
    [mgr GET:newUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"OK === %@",dataDic);
//        NSString *htmlString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",htmlString);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (success) {
            success(dataDic);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (failure) {
            failure(error);
        }
    }];
}


+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}



@end
