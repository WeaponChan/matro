//
//  AppDelegate.m
//  Matro
//
//  Created by NN on 16/3/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "AppDelegate.h"
#import "MLClassViewController.h"
#import "MLPersonViewController.h"
#import "MLPersonController.h"
#import "ZLHomezlViewController.h"

#import "HFSConstants.h"
#import "UIColor+HeinQi.h"
#import "ZipArchive.h"
#import "JPUSHService.h"

#import "WXApi.h"
#import <MagicalRecord/MagicalRecord.h>
#import "MMMaterialDesignSpinner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HFSUtility.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

#import "IQKeyboardManager.h"
#import "HFSUtility.h"
#import "NSString+URLZL.h"
#import "MLPushMessageModel.h"
#import "MJExtension.h"

#import "MLActiveWebViewController.h"
#import "OffLlineShopCart.h"
#import "CompanyInfo.h"
#import "MLShopBagViewController.h"

#import "UMMobClick/MobClick.h"
#import "CoreNewFeatureVC.h"
#import <Bugly/Bugly.h>

#import "sys/utsname.h"
#import <AdSupport/AdSupport.h>
#import "Reachability.h"
#import "MLHttpManager.h"
#import "MLLoginViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()<UITabBarControllerDelegate,WXApiDelegate,UIAlertViewDelegate,JPUSHRegisterDelegate>
{
     NSInteger cart_num;
     NSString *version;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    
    //获取设备信息
    [self deviceInfo];
    [self getVersion];
    
    UMConfigInstance.appKey = @"578c85b0e0f55a304d000028";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [self initializeHomePageData];
    MMMaterialDesignSpinner *_loadingSpinner = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-80)/2, ([UIScreen mainScreen].bounds.size.height-80)/2, 80, 80)];
    _loadingSpinner.tintColor = [HFSUtility hexStringToColor:@"#ae8e5d"];
    _loadingSpinner.lineWidth = 5;
    
    [_loadingSpinner startAnimating];

    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIWindow *mainWindow = delegate.window;
    [mainWindow addSubview:_loadingSpinner];
    
    [UIView animateWithDuration:0.6f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _loadingSpinner.alpha = 0.0f;
        _loadingSpinner.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5f, 1.5f, 1.0f);
    } completion:^(BOOL finished) {
        [_loadingSpinner removeFromSuperview];
    }];
    

    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Model.sqlite"];

    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//    } else {
//        //categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                          UIRemoteNotificationTypeSound |
//                                                          UIRemoteNotificationTypeAlert)
//                                              categories:nil];
//    }
    
    //3.0.1版本
      if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        #ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        #endif
      } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
          //可以添加自定义categories
          [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                            UIUserNotificationTypeSound |
                                                            UIUserNotificationTypeAlert)
                                                categories:nil];
      } else {
          //categories 必须为nil
          [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                            UIRemoteNotificationTypeSound |
                                                            UIRemoteNotificationTypeAlert)
                                                categories:nil];
      }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];

    
    
    
    [WXApi registerApp:@"wx5aced428a6ce270e"];
    
    
    [UMSocialData setAppKey:@"572b140d67e58e4b9e001422"];
    
    
    [UMSocialQQHandler setQQWithAppId:@"1105292896" appKey:@"PDZl84sGb8GzJSwo" url:@"http://www.matrojp.com/"];
    //设置微信AppId、appSecret，分享url
    
    [UMSocialWechatHandler setWXAppId:@"wx5aced428a6ce270e" appSecret:@"54e1071ad99428a88330eee8489fb37c" url:@"http://www.matrojp.com/"];
    
    //开始认证
    [self autoLogin];

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    if ([launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey]) {
        self.pushMessage = [MLPushMessageModel mj_objectWithKeyValues:[launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey]];
        
    }
    
    //网络请求缓存
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectSecondVC:) name:SelectSecondVC_NOTIFICATION object:nil];
    
    
    //判断是否需要显示：（内部已经考虑版本及本地版本缓存）
    BOOL canShow = [CoreNewFeatureVC canShowNewFeature];
    
    if(canShow){
        
        NewFeatureModel *m1 = [NewFeatureModel model:[UIImage imageNamed:@"yindao01.jpg"]];
        
        NewFeatureModel *m2 = [NewFeatureModel model:[UIImage imageNamed:@"yindao02.jpg"]];
        
        NewFeatureModel *m3 = [NewFeatureModel model:[UIImage imageNamed:@"yindao03.jpg"]];
        
        NewFeatureModel *m4 = [NewFeatureModel model:[UIImage imageNamed:@"yindao04.jpg"]];
        self.window.rootViewController = [CoreNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3,m4] enterBlock:^{
            
            NSLog(@"进入主页面");
            //创建TabBarController
            [self buildTabBarController];
            self.window.rootViewController = _tabBarController;
            [self autoLogin];
            
        }];
    }else{
//        [self autoLogin];

        MLAnimationViewController * vcs = [[MLAnimationViewController alloc]init];
        vcs.reView.hidden = YES;
        self.window.rootViewController = vcs;
        [vcs animationBlockAction:^(BOOL success) {
            
            if (self.isFinished == YES) {
                    vcs.reView.hidden = YES;
                    //创建TabBarController
                    [self buildTabBarController];
                    self.window.rootViewController = _tabBarController;
                
            }else{
                vcs.reView.hidden = NO;
//                self.window.rootViewController = _tabBarController;
                self.window.rootViewController = vcs;

            }
            
        }];
        
        __weak typeof(vcs) weakvcs = vcs;
        vcs.reblock = ^{
            NSLog(@"点击了重新加载");
            
            [self autoLogin];
            weakvcs.reView.hidden = YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"延时了4.5秒");
                if (self.isFinished == YES) {
                    //创建TabBarController
                    [self buildTabBarController];
                    [self performSelector:@selector(loginTabBar) withObject:nil afterDelay:1.0];
                    
                }else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        weakvcs.reView.hidden = NO;
                    });
              
                    self.window.rootViewController = weakvcs;
                }
                
            });
            
        };
    }

    [Bugly startWithAppId:@"fef22c2596"];
    
    return YES;
}

-(void)loginTabBar{
    
    self.window.rootViewController = _tabBarController;
}

+(AppDelegate *)sharedAppDelegate{

    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


- (void)selectSecondVC:(id)sender{
    
    [self.tabBarController setSelectedIndex:1];
    
}

- (void)autoLogin{
    NSLog(@"userid---->%@accesstoken---->%@",[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID],[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN]);
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID] &&[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN] ) {
        [self renZhengLiJiaWithPhone:[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID] withAccessToken:[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN]];
       
    }
    else{
     [self renZhengLiJiaWithPhone:@"99999999999" withAccessToken:@"ChnUN7ynJnoJ6K2Z39LtOBtlXkT91r"];
        
    }
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"Device Token----->%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}



- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//调用 李佳重新认证接口
- (void)renZhengLiJiaWithPhone:(NSString *)phoneString withAccessToken:(NSString *) accessTokenStr{
    //GCD异步实现
    //获取设备ID
    NSString *identifierForVendor = [JPUSHService registrationID];
    
    if (!identifierForVendor || identifierForVendor == nil || [identifierForVendor isEqualToString:@""]) {
        identifierForVendor = @"123456789";
    }
    NSLog(@"设备ID为：%@",identifierForVendor);
    [[NSUserDefaults standardUserDefaults] setObject:identifierForVendor forKey:DEVICE_ID_JIGUANG_LU];
    NSString *device_version = [[NSUserDefaults standardUserDefaults] objectForKey:@"systemVer"];
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"result"];
    NSString *network = [[NSUserDefaults standardUserDefaults] objectForKey:@"status"];
    NSString *device_model = [[NSUserDefaults standardUserDefaults] objectForKey:@"devicemodel"];
    NSString *screen = [[NSUserDefaults standardUserDefaults] objectForKey:@"bounds"];
    
    
    NSString * accessTokenEncodeStr = [accessTokenStr URLEncodedString];
    NSString * urlPinJie = [NSString stringWithFormat:@"%@/api.php?m=member&s=check_token&phone=%@&accessToken=%@&client_type=ios&device_id=%@&device_source=ios&device_version=%@&uuid=%@&device_network=%d&device_model=%@&device_screen=%@",ZHOULU_ML_BASE_URLString,phoneString,accessTokenEncodeStr,identifierForVendor,device_version,uuid,network.intValue,device_model,screen];

    NSString * urlStr = urlPinJie;
    NSLog(@"李佳的认证接口：%@",urlStr);
    NSURL * URL = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"get"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSString *resultString  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"李佳认证:%@,错误信息：%@",resultString,error);
                                      
                                      //请求没有错误
                                      if (!error) {
                                          if (data && data.length > 0) {
                                              NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                              
                                              if (result && [result isKindOfClass:[NSDictionary class]]) {
                                                  if ([result[@"code"] isEqual:@0]) {
                                                                 NSDictionary *data = result[@"data"];
                                                      
                                                      NSString *bbc_token = [data objectForKey:@"bbc_token"];
                                                      NSString *timestamp = data[@"timestamp"];
                                                      NSLog(@"李佳认证返回的时间戳+++++：%@",timestamp);
                                                      if (timestamp != nil) {

                                                          self.isFinished = YES;
                                                          NSDatezlModel * model1 = [NSDatezlModel sharedInstance];
                                                          model1.timeInterval =[timestamp integerValue];
                                                          model1.firstDate = [NSDate date];
                                                          [[NSUserDefaults standardUserDefaults]setObject:bbc_token forKey:KUSERDEFAULT_BBC_ACCESSTOKEN_LIJIA];
                                                          if ([[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID] &&[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN] ) {
                                                              
                                                              NSString * UID  = data[@"uid"];
                                                              [[NSUserDefaults standardUserDefaults]setObject:UID forKey:DIANPU_MAIJIA_UID];
                                                              [self loadVersion:[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN]];
                                                               [self getCartNum:[[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_ACCCESSTOKEN]];
                                                          }
                                                        
                                                          //认证成功后发送通知
                                                          [[NSNotificationCenter defaultCenter]postNotificationName:RENZHENG_LIJIA_Notification object:nil];
                                                          [[NSNotificationCenter defaultCenter]postNotificationName:RENZHENG_LIJIA_HOME_Notification object:nil];

                                                      }else{
                                                      
                                                          self.isFinished = NO;
                                                      }
                                                      
                                                  }
                                                  else if([result[@"code"] isEqual:@1002]){
                                                      self.isShiXiao = YES;
                                                      self.shixiaoMsg = result[@"msg"];
                                           [self renZhengLiJiaWithPhone:@"99999999999" withAccessToken:@"ChnUN7ynJnoJ6K2Z39LtOBtlXkT91r"];
                                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSERDEFAULT_USERCARDNO];
                                                      [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUSERDEFAULT_USERAVATOR];
                                                      [[NSUserDefaults standardUserDefaults]removeObjectForKey:kUSERDEFAULT_USERID];
                                                      
                                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSERDEFAULT_USERPHONE];
                                                      
                                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSERDEFAULT_USERNAME];
                                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUSERDEFAULT_ISHAVE_DEFAULTCARD_BOOL];
                                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUSERDEFAULT_ACCCESSTOKEN];
                                                      
                                                  }
                                              }
                                          }
                                      }else{
   
                                        }
                                  }];
    [task resume];
}



-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSLog(@"银联支付回调：%@",url.host);
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
   else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    else if ([url.host isEqualToString:@"pay"])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.host isEqualToString:@"oauth"]) {
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    else if([url.host isEqualToString:@"uppayresult"]){
        NSLog(@"银联支付返回URL：%@",url);
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                
                //数据从NSDictionary转换为NSString
                
                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                   options:0
                                                                     error:nil];
                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                
                //判断签名数据是否存在
                if(data == nil){
                    //如果没有签名数据，建议商户app后台查询交易结果
                    return;
                }
                /*
                 //验签证书同后台验签证书
                 //此处的verify，商户需送去商户后台做验签
                 if([self verify:sign]) {
                 //支付成功且验签成功，展示支付成功提示
                 }
                 else {
                 //验签失败，交易结果数据被篡改，商户app后台查询交易结果
                 }
                 */
                    [[NSNotificationCenter defaultCenter]postNotificationName:YinLianPay_NOTICIFICATION_SUCCESS object:nil userInfo:nil];
                
            }
            else if([code isEqualToString:@"fail"]) {
                //交易失败
                    [[NSNotificationCenter defaultCenter]postNotificationName:YinLianPay_NOTICIFICATION_FAIL object:nil userInfo:nil];
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
                    [[NSNotificationCenter defaultCenter]postNotificationName:YinLianPay_NOTICIFICATION_CANCEL object:nil userInfo:nil];
            }
        }];
    
    }
    else {
        return [UMSocialSnsService handleOpenURL:url];
    }


    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"pay"])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
    
}


//支付结果
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNOTIFICATIONWXPAY object:resp];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                
                break;
        }
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    NSLog(@"applicationWillEnterForeground");

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
    [[NSNotificationCenter defaultCenter]postNotificationName:APPLICATION_BECOME_ACTIVE_NOTIFICATION object:nil];
    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"NotificationUserInfo--111-->%@",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    MLPushMessageModel *pushMessage = [MLPushMessageModel mj_objectWithKeyValues:userInfo];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHMESSAGE" object:pushMessage];

}

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
     NSLog(@"NotificationUserInfo--222-->%@",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    MLPushMessageModel *pushMessage = [MLPushMessageModel mj_objectWithKeyValues:userInfo];
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHMESSAGE" object:pushMessage];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHMESSAGEActive" object:pushMessage];

}
- (void)application:(UIApplication *)application
  didReceiveLocalNotification:(UILocalNotification *)notification {
     NSLog(@"NotificationUserInfo--333-->%@",notification.mj_JSONObject);
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
//        MLPushMessageModel *pushMessage = [MLPushMessageModel mj_objectWithKeyValues:userInfo];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHMESSAGE" object:pushMessage];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        MLPushMessageModel *pushMessage = [MLPushMessageModel mj_objectWithKeyValues:userInfo];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PUSHMESSAGE" object:pushMessage];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)initializeHomePageData
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *homeHtmlDirectory = [DOCUMENT_FOLDER_PATH stringByAppendingPathComponent:ZIP_FILE_NAME];
    BOOL isDirectory = NO;
    BOOL directoryExists = [fileManager fileExistsAtPath:homeHtmlDirectory isDirectory:&isDirectory];
    
    if (directoryExists) {
        [fileManager removeItemAtPath:homeHtmlDirectory error:nil];
    }
    //                        if (!directoryExists) {
    NSString *zipFilePath = [[NSBundle mainBundle]pathForResource:ZIP_FILE_NAME ofType:@"zip"];
    
    ZipArchive *zipArchive = [[ZipArchive alloc]init];
    if ([zipArchive UnzipOpenFile:zipFilePath]) {
        [zipArchive UnzipFileTo:homeHtmlDirectory overWrite:YES];
        [zipArchive UnzipCloseFile];
    }
}


- (void)getCartNum:(NSString*)accessToken{
   
    NSString * accessTokenEncodeStr = [accessToken URLEncodedString];
    NSString * url = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=cart_num&accessToken=%@",ZHOULU_ML_BASE_URLString,accessTokenEncodeStr];
    [MLHttpManager get:url params:nil m:@"product" s:@"cart" success:^(id responseObject) {
        NSLog(@"cart_num---->%@",responseObject);
        if ([responseObject[@"code"] isEqual:@0]) {
            if (responseObject[@"data"]) {
                if (responseObject[@"data"][@"cart_num"] && [responseObject[@"data"][@"cart_num"] isKindOfClass:[NSString class]]) {
                    cart_num = 0;
                    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"cartNum"];
                }else{
                    NSNumber *cart = responseObject[@"data"][@"cart_num"];
                    cart_num = [cart integerValue];
                    NSString *cartNum = [NSString stringWithFormat:@"%ld",cart_num];
                    [[NSUserDefaults standardUserDefaults]setObject:cartNum forKey:@"cartNum"];
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
         
    
}
-(void)loadVersion:(NSString*)accessToken{
    NSString * accessTokenEncodeStr = [accessToken URLEncodedString];
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=upgrade&s=index&action=sel_upgrade&accessToken=%@",ZHOULU_ML_BASE_URLString,accessTokenEncodeStr];
    NSDictionary *params = @{@"appverison":version,@"apptype":@"ios"};
    [MLHttpManager post:urlStr params:params m:@"upgrade" s:@"index" success:^(id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSString *code = result[@"code"];
        NSLog(@"版本result----->%@",result);
        if ([code isEqual:@0]) {
            if (result[@"data"][@"app_audit_flag"]) {
                
                NSString *app_audit_flag = result[@"data"][@"app_audit_flag"];
                self.appFlag = [NSString stringWithFormat:@"%@",app_audit_flag];
//                NSString *app_audit_flag1 = [NSString stringWithFormat:@"%@",app_audit_flag];
//                [[NSUserDefaults standardUserDefaults]setObject:app_audit_flag forKey:@"app_audit_flag"];
            }else{
               self.appFlag = @"";
//               [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"app_audit_flag"];
            }
            
        }
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败 error===%@",error);
        
    }];
    
}

- (NSString*)getVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"version===%@",version);
    return version;
}


#pragma mark- 初始化TabBar

- (UITabBarController*)buildTabBarController
{

    ZLHomezlViewController *homeViewController = [[ZLHomezlViewController alloc]init];
    homeViewController.title = @"首页";
    MLNavigationController *homeNavigationController = [[MLNavigationController alloc]initWithRootViewController:homeViewController];
    homeNavigationController.tabBarItem.image = [UIImage imageNamed:@"home3"];
    homeNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"home3s"];
    homeNavigationController.tabBarItem.title = @"首页";
    
    MLClassViewController *classViewController = [[MLClassViewController alloc]init];
    classViewController.title = @"分类";
    MLNavigationController *classNavigationController = [[MLNavigationController alloc]initWithRootViewController:classViewController];
    classNavigationController.tabBarItem.image = [UIImage imageNamed:@"list3"];
    classNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"list3s"];
    classNavigationController.tabBarItem.title = @"分类";
    
    MLShopBagViewController *bagViewController = [[MLShopBagViewController alloc]init];
    bagViewController.title = @"购物袋";
    MLNavigationController *bagNavigationController = [[MLNavigationController alloc]initWithRootViewController:bagViewController];
    bagNavigationController.tabBarItem.image = [UIImage imageNamed:@"shopcar3"];
    bagNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"shopcar-15-15"];
    bagNavigationController.tabBarItem.title = @"购物袋";

    if (cart_num == 0) {
        bagNavigationController.tabBarItem.badgeValue = nil;
    }
    else{
        NSString *cartNum = [NSString stringWithFormat:@"%ld",cart_num];
        bagNavigationController.tabBarItem.badgeValue = cartNum;
    }
    
    
    MLPersonController *personViewController = [[MLPersonController alloc]init];
    personViewController.title = @"我";
    MLNavigationController *personalNavigationController = [[MLNavigationController alloc]initWithRootViewController:personViewController];
    personalNavigationController.tabBarItem.image = [UIImage imageNamed:@"me3"];
    personalNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"me3s"];
    personalNavigationController.tabBarItem.title = @"我";
    
    _tabBarController = [[UITabBarController alloc]init];
    [_tabBarController setViewControllers:@[homeNavigationController,classNavigationController, bagNavigationController, personalNavigationController]];
    
    self.tabBarController.delegate = self;
    self.tabBarController.tabBar.tintColor = [UIColor colorWithHexString:@"#625046"];
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBarController.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBarController.tabBar insertSubview:bgView atIndex:0];
    self.tabBarController.tabBar.opaque = YES;
    return self.tabBarController;
}

- (void)deviceInfo{
    //  设备系统的版本
    NSString *systemVer = [[UIDevice currentDevice] systemVersion];
    [[NSUserDefaults standardUserDefaults]setObject:systemVer forKey:@"systemVer"];
    //设备的分辨率
    NSString *bounds = [NSString stringWithFormat:@"%.f-%.f",2*[[UIScreen mainScreen] bounds].size.width,2*[[UIScreen mainScreen] bounds].size.height];
    [[NSUserDefaults standardUserDefaults]setObject:bounds forKey:@"bounds"];
    //uuid  IDFA同一设备上所有的APP获取到的值是相同的，用于追踪用户而设的，用于可以通过设置->隐私->广告->广告追踪进行设置，可能取不到，苹果设备默认是开的。
    NSString *resultString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    //IDFV 用于Vender表示标识用户用的，Vender是指应用提供商，每个设备在所属同一个Vender的应用里，都有相同的值。通过BundleID的反转的前两部分进行匹配，如果相同就是同一个Vender。(例如com.370969280.app1 和 com.370969280.app2 就是同一个Vender,IDFV值就相同)。
    //PS：1、只要APP1与APP2不全部删除，此值就不会发生改变；全部删除后，再安装APP，此值将会发生改变。
    //例如：先安装APP1，再安装APP2，两个APP的IDFV值相同；删除APP2保留APP1，然后重装APP2，此时APP2获取的IDFV值依旧与APP1相同。
    //2、此值一定可以获取到。
    //NSString *resultString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"resultString===%@",resultString);
    
    
    [[NSUserDefaults standardUserDefaults]setObject:resultString forKey:@"result"];
    //设备型号
    NSString *devicemodel = [self deviceVersion];
    [[NSUserDefaults standardUserDefaults]setObject:devicemodel forKey:@"devicemodel"];
    //当前设备的网络类型
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    NSString *status;
    if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        if ([conn currentReachabilityStatus] == ReachableViaWiFi) {
            status = @"1";
            NSLog(@"使用WIFI网络进行上网===%@",status);
   
        }
        if ([conn currentReachabilityStatus] == ReachableViaWWAN) {
            status = @"0";
            NSLog(@"使用手机自带网络进行上网===%@",status);
        }
    }else { // 没有网络
        status = @"0";
    }
   [[NSUserDefaults standardUserDefaults]setObject:status forKey:@"status"];
}

- (NSString*)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"VerizoniPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone6Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone6sPlus";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone7Plus";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPodTouch1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPodTouch2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPodTouch3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPodTouch4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPodTouch5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad2(WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad2(GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad2(CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad2(32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPadmini(WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPadmini(GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPadmini(CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad4(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad4(4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad4(CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPadAir";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPadAir";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPadAir";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPadAir2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPadAir2";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPadPro";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPadmini2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPadmini3";
    
    return deviceString;
}

@end
