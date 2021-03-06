
//
//  MLGoodsDetailsViewController.m
//  Matro
//
//  Created by NN on 16/3/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLGoodsDetailsViewController.h"
#import "RecommendCollectionViewCell.h"
#import "CPPhotoInfoViewController.h"
#import "MLGoodsDetailsTableViewCell.h"
#import "YAScrollSegmentControl.h"
#import "AppDelegate.h"
#import "HFSConstants.h"
#import "CPStepper.h"
#import "UIColor+HeinQi.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import "HFSUtility.h"
#import "HFSServiceClient.h"
#import "HFSConstants.h"
#import "MLLoginViewController.h"
#import "MLSureViewController.h"
#import "MLShopBagViewController.h"

#import "YMNavigationController.h"
#import "MLHelpCenterDetailController.h"
#import "NSString+GONMarkup.h"
#import "Masonry.h"
#import "MLKuajingCell.h"
#import "MLShareGoodsViewController.h"
#import "MLGoodsSharePhotoViewController.h"
#import "MBProgressHUD+Add.h"
#import <DWTagList/DWTagList.h>
#import "SearchHistory.h"
#import <MagicalRecord/MagicalRecord.h>
#import "MLpingjiaViewController.h"
#import "MLHttpManager.h"
#import "MLShopInfoViewController.h"
#import "MLHelpCenterDetailController.h"
#import "OffLlineShopCart.h"
#import "MBProgressHUD+Add.h"
#import "CompanyInfo.h"
#import "IMJIETagView.h"
#import "IMJIETagFrame.h"
#import "CommonHeader.h"
#import "MLBuyKnowViewController.h"
#import "MLPingjiaListViewController.h"
#import "MLHttpManager.h"
#import "LhkhButton.h"
#import "JSBadgeView.h"
#import "MBProgressHUD+Add.h"
#import "MLOffLineShopCart.h"

#import "MLYSShopInfoViewController.h"

@interface UIImage (SKTagView)

+ (UIImage *)imageWithColor: (UIColor *)color;
@end

@interface MLGoodsDetailsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIAlertViewDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,YAScrollSegmentControlDelegate,DWTagListDelegate,IMJIETagViewDelegate,UIGestureRecognizerDelegate>{
    
    NSDictionary *pDic;//商品详情信息
    NSDictionary *dPDic;//店铺详情信息
    
    NSMutableArray *_imageArray;//轮播图数组
    
    NSMutableArray *_recommendArray;
    NSArray *_titleArray;//随机出现的商品属性选择的标题数组
    NSArray *tempArr;
    
    YAScrollSegmentControl *titleView;//标题上选择查看商品还是详情按钮
    NSString *userid;
    NSString *spid;
    NSString *weburl;
    BOOL isglobal;
    NSMutableArray *imgUrlArray;
    
    UIView *overView;
    
    //NSMutableDictionary *guigeDic;//总的规格字典
    NSMutableArray *porpertyArray;//规格数组
    NSMutableArray *huoyuanArray;//规格1
    NSMutableArray *huoyuanIDArray;//规格1 id
    NSInteger huoyunaIndex;//规格1 被选中的下标
    NSMutableArray *jieduanArray;//规格2
    NSMutableArray *jieduanIDArray;//规格2 id
    NSInteger jieduanIndex;//规格2 被选中的下标
//    DWTagList *huoyuanList;
//    DWTagList *jieduanList;
    
    NSMutableArray *promotionArray;//优惠券
    
    NSDictionary *Searchdic;//根据选的规格遍历出来的商品信息
    
    NSString *phoneNum;
    
    NSString *DPuid;
    BOOL isSelectguige;
    NSInteger CartNum;
    
    
}
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;//最底层的SV
@property (strong, nonatomic) IBOutlet UIPageControl *pagecontrol;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pingmuW;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pingmuH;

@property (strong, nonatomic) IBOutlet UIScrollView *pingmu1rootScrollView;//第一页的SV商品页
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;

@property (strong, nonatomic) IBOutlet UILabel *biaotiLabel;//标题
@property (strong, nonatomic) IBOutlet UILabel *texingLabel;//特性
@property (strong, nonatomic) IBOutlet UILabel *jiageLabel;//价格
@property (strong, nonatomic) IBOutlet UILabel *yuanjiaLabel;//原价
@property (strong, nonatomic) IBOutlet UIButton *shoucangButton;//收藏按钮
@property (strong, nonatomic) IBOutlet UILabel *yuanchandiLabel;//原产地

@property (strong, nonatomic) IBOutlet UIView *kujingBgView;//跨境商品显示选项的主视图，是跨境商品的时候显示且zengpinTH = 120 不是的时候隐藏且 zengpinTH = 0
@property (strong, nonatomic) IBOutlet UILabel *shuilvLabel;//跨境商品有的税率
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *zengpinTH;//跨境 = 120，正常 = 0

@property (strong, nonatomic) IBOutlet UILabel *huodongLabel;//活动
@property (strong, nonatomic) IBOutlet UIImageView *zengpImageView;//赠品图片
@property (strong, nonatomic) IBOutlet UILabel *zengpinnameLabel;//赠品文字
@property (strong, nonatomic) IBOutlet UILabel *cuxiaoxinxiLabel;//促销信息
@property (weak, nonatomic) IBOutlet UILabel *cuxiaonameLabel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;//选择商品类型，应该是类似于大小颜色之类的，cell应是随机标题+随机的选项按钮（未完成）
@property (strong, nonatomic) IBOutlet UILabel *kuncuntisLabel;//库存
@property (strong, nonatomic) IBOutlet CPStepper *shuliangStepper;
@property (strong, nonatomic) IBOutlet UIView *pingjiaView;//遍历这个View,来修改星星图片 tag 101~105
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *likeH;//猜你喜欢的collectionView的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tisH;

@property (strong, nonatomic) IBOutlet UIWebView *webView;//图文详情，加在第二页

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kuajingHeight;

@property (nonatomic,strong)MLKuajingCell *xiaoshuiView;
@property (nonatomic,strong)MLKuajingCell *zengzhiView;
@property (weak, nonatomic) IBOutlet UIView *tedianView;
@property (weak, nonatomic) IBOutlet UIView *zengpinView;
@property (weak, nonatomic) IBOutlet UIView *huoYuanView;
@property (weak, nonatomic) IBOutlet UIView *jieDuanView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cuxiaoH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cuxiaoxinxiH;
@property (weak, nonatomic) IBOutlet UIView *biaotiView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guigeH;

@property (weak, nonatomic) IBOutlet UIImageView *dianpuimage;
@property (weak, nonatomic) IBOutlet UILabel *dianpuname;
@property (weak, nonatomic) IBOutlet UILabel *dianputexing;
@property (weak, nonatomic) IBOutlet UILabel *miaoshuNum;
@property (weak, nonatomic) IBOutlet UILabel *fuwuNum;
@property (weak, nonatomic) IBOutlet UILabel *wuliuNum;
@property (weak, nonatomic) IBOutlet UILabel *guanzhuNum;
@property (weak, nonatomic) IBOutlet UILabel *shangpinNum;
@property (weak, nonatomic) IBOutlet UILabel *dongtaiNum;
@property (weak, nonatomic) IBOutlet UIView *lianxikefuView;
@property (weak, nonatomic) IBOutlet UIView *jinrudianpuView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yonghucaozuoH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dianpuH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yuanchandiH;
@property (weak, nonatomic) IBOutlet UIView *yuanchandiView;
@property (weak, nonatomic) IBOutlet UIView *blankview;
@property (weak, nonatomic) IBOutlet UIButton *jiarugouwucheBtn;
@property (weak, nonatomic) IBOutlet UILabel *xiangouLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xiangouW;
@property (weak, nonatomic) IBOutlet UIView *frashView;
@property (weak, nonatomic) IBOutlet UIView *ActivityView;
@property (weak, nonatomic) IBOutlet UIButton *GuanzhuDianpu;
@property (weak, nonatomic) IBOutlet LhkhButton *DianpuBtn;
@property (weak, nonatomic) IBOutlet LhkhButton *GuanzhuBtn;
@property (weak, nonatomic) IBOutlet LhkhButton *ShopCarBtn;
@property (nonatomic,strong)NSMutableArray *offlineCart;



@end

@implementation MLGoodsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    titleView = [[YAScrollSegmentControl alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH - 20, 40)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.tintColor = [UIColor clearColor];
    titleView.buttons = @[@"商品",@"图文详情"];
    
    [titleView setTitleColor:[UIColor colorWithHexString:@"AE8E5D"] forState:UIControlStateSelected];
    [titleView setTitleColor:[UIColor colorWithHexString:@"A9A9A9"] forState:UIControlStateNormal];
//    [titleView setBackgroundImage:[UIImage imageNamed:@"sel_type_g"] forState:UIControlStateSelected];
//    [titleView setBackgroundImage:[UIImage imageNamed:@"TM.jpg"] forState:UIControlStateNormal];
    titleView.delegate = self;
    //self.navigationItem.titleView = titleView;
    self.navigationItem.title = @"商品详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"260E00"]}];
    
    pDic = [[NSDictionary alloc] init];
    _recommendArray = [[NSMutableArray alloc] init];
    _titleArray = [[NSArray alloc] init];
    huoyuanArray = [[NSMutableArray alloc]init];
    huoyuanIDArray = [NSMutableArray array];
    jieduanArray = [[NSMutableArray alloc] init];
    jieduanIDArray = [NSMutableArray array];
    promotionArray = [[NSMutableArray alloc] init];
    porpertyArray = [[NSMutableArray alloc] init];
    Searchdic = [[NSDictionary alloc] init];
    
    imgUrlArray = [NSMutableArray array];
    // 一期隐藏
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share1"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonAction)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    _imageScrollView.delegate = self;
    _imageArray = [[NSMutableArray alloc] init];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightbackButtonAction)];
    
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftbackButtonAction)];
    
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:leftRecognizer];
    
    
    //设置SV1 上拉加载
    
    MJRefreshBackStateFooter * footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        //上拉，执行对应的操作---改变底层滚动视图的滚动到对应位置
        //设置动画效果
       self.navigationItem.title = @"图文详情";
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.mainScrollView.contentOffset = CGPointMake(0, MAIN_SCREEN_HEIGHT - 64);
            titleView.selectedIndex = 1;
        } completion:^(BOOL finished) {
            //结束加载
            [_pingmu1rootScrollView.footer endRefreshing];
        }];
    }];
    
    [footer setTitle:@"继续拖动，查看图文详情" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"加载失败" forState:MJRefreshStateNoMoreData];
    _pingmu1rootScrollView.footer = footer;
    
    
    //设置SV2 有下拉操作
    
    MJRefreshStateHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.navigationItem.title = @"商品详情";
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            //下拉执行对应的操作
            self.mainScrollView.contentOffset = CGPointMake(0, 0);
            titleView.selectedIndex = 0;
        } completion:^(BOOL finished) {
            //结束加载
            [_webView.scrollView.header endRefreshing];
        }];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"点击或继续拖动返回" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即返回" forState:MJRefreshStatePulling];
    [header setTitle:@"加载失败" forState:MJRefreshStateNoMoreData];
    
    
    [self.shoucangButton addTarget:self action:@selector(addFavorite) forControlEvents:UIControlEventTouchUpInside];
    
    _webView.scrollView.header = header;
    

    UIView *cover = [[UIView alloc]initWithFrame:self.view.bounds];
    cover.backgroundColor = [UIColor whiteColor];
    overView = cover;
    [self.view addSubview:cover];
    
    self.lianxikefuView.layer.borderWidth = 1.f;
    self.lianxikefuView.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
    self.lianxikefuView.layer.cornerRadius = 4.f;
    self.lianxikefuView.layer.masksToBounds = YES;
    self.jinrudianpuView.layer.borderWidth = 1.f;
    self.jinrudianpuView.layer.borderColor = RGBA(193, 193, 193, 1).CGColor;
    self.jinrudianpuView.layer.cornerRadius = 4.f;
    self.jinrudianpuView.layer.masksToBounds = YES;
    
    NSString *cartNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"cartNum"];
    
//    JSBadgeView *shopCarBadge = [[JSBadgeView alloc]initWithParentView:self.ShopCarBtn alignment:JSBadgeViewAlignmentTopRight];
//    shopCarBadge.badgeBackgroundColor = RGBA(239, 103, 67, 1);
//    if ([cartNum isEqualToString:@"0"]) {
//        shopCarBadge.hidden = YES;
//    }else{
//        shopCarBadge.badgeText = [NSString stringWithFormat:@"%@",cartNum];
//    }
    
    
    [self showLoadingView];
//    [self getCartNum];
//    [self loadDateProDetail];
    [self guessYLike];

}
-(void)addFavorite
{
    
}

- (void)rightbackButtonAction{
    [self didSelectItemAtIndex:0];
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
    [self.pingmu1rootScrollView setContentOffset:CGPointMake(0, 0)];
    
    titleView.selectedIndex = 0;
    
}

- (void)leftbackButtonAction{
    
    [self didSelectItemAtIndex:1];
    self.mainScrollView.contentOffset = CGPointMake(0, MAIN_SCREEN_HEIGHT - 64);
    titleView.selectedIndex = 1;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
    _pingmuH.constant = MAIN_SCREEN_HEIGHT - 64 - 45;
    _pingmuW.constant = MAIN_SCREEN_WIDTH;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userid = [userDefaults valueForKey:kUSERDEFAULT_USERID];
    DPuid = [userDefaults valueForKey:DIANPU_MAIJIA_UID];
    [self showLoadingView];
    
    [self getCartNum];
    [self loadDateProDetail];
    
    if (userid) {
        
    }else{
       
    }
    
    
}

- (IBAction)actPingjia:(id)sender {
 
    MLpingjiaViewController *vc = [[MLpingjiaViewController alloc] init];
    vc.paramDic = @{@"id":_paramDic[@"id"]?:@""};
    NSLog(@"pingjia===%@222%@",self.paramDic,vc.paramDic);
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
    
}

#pragma mark 获取商品详情数据
- (void)loadDateProDetail {
 
    NSLog(@"===%@",_paramDic);

  NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=detail&id=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,_paramDic[@"id"],vCFBundleShortVersionStr];
     //测试链接
//       NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=detail&id=12343&client_type=ios&app_version=%@",MATROJP_BASE_URL,vCFBundleShortVersionStr];
   
        [ MLHttpManager get:urlStr params:nil m:@"product" s:@"detail" success:^ (id responseObject) {
            NSLog(@"responseObject===%@",responseObject);
            [self closeLoadingView];
            if ([responseObject[@"code"]isEqual:@0]) {
                NSDictionary *dic = responseObject[@"data"];
                pDic = responseObject[@"data"];
                
                //是否有参加的活动
                if (dic[@"activity_pic"]) {
                    NSArray *activity_picArr = dic[@"activity_pic"];
                    CGFloat width = 0.f;
                    if (activity_picArr && activity_picArr.count>0) {
                        for (int i = 0; i<activity_picArr.count; i++) {
                            NSString *url = activity_picArr[i][@"pic_app"];
                            CGSize size =[self getImageSizeWithURL:url];
                            
                            if (i>=1) {
                                NSString *preurl = activity_picArr[i-1][@"pic_app"];
                                CGSize presize =[self getImageSizeWithURL:preurl];
                                width = width + presize.width/2;
                            }
                            
                            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width  +i*10), 0, size.width/2, size.height/2)];
                            if ([url hasSuffix:@"webp"]) {
                                [imageView setZLWebPImageWithURLStr:url withPlaceHolderImage:PLACEHOLDER_IMAGE];
                            } else {
                                [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon_default"]];
                            }
                            [self.ActivityView addSubview:imageView];
                        }
                    }else{
                        self.ActivityView.hidden = YES;
                    }
                }else{
                    self.ActivityView.hidden = YES;
                }
    
                //判断是否是店铺主
                if (dic[@"pinfo"][@"userid"]) {
                    if ([dic[@"pinfo"][@"userid"] isKindOfClass:[NSString class]]) {
                        if ([DPuid isEqualToString:dic[@"pinfo"][@"userid"]]) {
                            [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                            self.jiarugouwucheBtn.enabled = NO;
                        }else{
                            
                            [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                            self.jiarugouwucheBtn.enabled = YES;
                        }
                    }
                    
                }
                [self loaddataDianpu];//请求店铺数据
                
                NSString *is_collect = dic[@"pinfo"][@"is_collect"];//是否收藏
                
                if ([is_collect isEqual:@0]) {
                    
                    self.shoucangButton.selected = NO;
                    self.GuanzhuBtn.selected = NO;
                    [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big2"] forState:UIControlStateNormal];
                    [self.shoucangButton setTitleColor:RGBA(38, 14, 0, 1) forState:UIControlStateNormal];
                    
                }else{
                    
                    self.shoucangButton.selected = YES;
                    self.GuanzhuBtn.selected = YES;
                    [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big1"] forState:UIControlStateNormal];
                    [self.shoucangButton setTitle:@"已收藏" forState:UIControlStateNormal];
                    [self.shoucangButton setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
                }
                
                NSString *is_shop_collect = dic[@"pinfo"][@"is_shop_collect"];//店铺是否收藏
                if ([is_shop_collect isEqual:@0]) {
                    
                    self.GuanzhuDianpu.selected = NO;
//                    self.GuanzhuBtn.selected = NO;
//                    [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big2"] forState:UIControlStateNormal];
//                    [self.shoucangButton setTitleColor:RGBA(38, 14, 0, 1) forState:UIControlStateNormal];
                    
                }else{
                    
                    self.GuanzhuDianpu.selected = YES;
//                    self.GuanzhuBtn.selected = YES;
//                    [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big1"] forState:UIControlStateNormal];
//                    [self.shoucangButton setTitle:@"已收藏" forState:UIControlStateNormal];
//                    [self.shoucangButton setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
                }
                [porpertyArray removeAllObjects];
                [huoyuanArray removeAllObjects];
                [jieduanArray  removeAllObjects];
                [huoyuanIDArray removeAllObjects];
                [jieduanIDArray removeAllObjects];
                _titleArray = dic[@"pinfo"][@"porperty_name"];//规格名
                
                if (_titleArray && _titleArray.count >0) {
                    
                    NSArray *porpertyArr = dic[@"pinfo"][@"porperty"];
                    [porpertyArray addObjectsFromArray:porpertyArr];
                    
                    if (porpertyArr.count >0) {
                        
                        isSelectguige = NO;
                        
                        NSDictionary *guigeDic = porpertyArr[0];//默认选择第一组
                        
                        NSString *is_promotion = dic[@"pinfo"][@"is_promotion"];
                        NSString *promition_start_time = dic[@"pinfo"][@"promition_start_time"];
                        NSString *promition_end_time = dic[@"pinfo"][@"promition_end_time"];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
                        NSString *nowdate= [dateFormatter stringFromDate:[NSDate date]];
                        NSDate *date=[dateFormatter dateFromString:nowdate];
                        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
                        NSLog(@"timeSp:%@",timeSp);
                        
                        if ([promition_start_time isEqual:@0] || [promition_end_time isEqual:@0] ) {
                            
                            float pricef = [guigeDic[@"price"] floatValue];
                            self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                            self.yuanjiaLabel.hidden = YES;
                            
                            
                        }else if(![promition_start_time isEqual:@0] && ![promition_end_time isEqual:@0] ){
                            
                            if ([is_promotion isEqualToString:@"1"]  && promition_start_time.doubleValue < timeSp.doubleValue && promition_end_time.doubleValue > timeSp.doubleValue) {
                                
                                float pricef = [guigeDic[@"promotion_price"] floatValue];
                                self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                                float  originprice= [guigeDic[@"price"] floatValue];
                                
                                NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                                
                                NSAttributedString *attrStr =
                                [[NSAttributedString alloc]initWithString:pricestr
                                                               attributes:
                                 @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                                   NSForegroundColorAttributeName:[UIColor grayColor],
                                   NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                   NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                                self.yuanjiaLabel.attributedText=attrStr;
                                
                            }else{
                                
                                float pricef = [guigeDic[@"price"] floatValue];
                                self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                                
                            }
                        }
                        
                        [self.shuliangStepper setTextValue:1];
                        UIButton *leftbtn = (UIButton*)self.shuliangStepper.leftView;
                        UIButton *rightbtn = (UIButton*)self.shuliangStepper.rightView;
                        
                        NSString *amount = guigeDic[@"stock"];
                        NSString *safe_amount = guigeDic[@"safe_stock"];
                        NSString *limit_quantity = dic[@"pinfo"][@"limit_quantity"];
                        NSString *limit_num = dic[@"pinfo"][@"limit_num"];
                        
                        if (limit_quantity && [limit_quantity isEqualToString:@"0"]) {
                            self.xiangouW.constant = 0;
                            self.shuliangStepper.maxValue = amount.intValue;
                            if ( amount.floatValue >5) {
                                
                                self.kuncuntisLabel.text = @"库存充足";
                                self.shuliangStepper.minValue = 1;
                                [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                                self.jiarugouwucheBtn.enabled = YES;
                            }else if(amount.floatValue >0 && amount.floatValue <=5){
                                
                                self.kuncuntisLabel.text = @"库存紧张";
                                self.shuliangStepper.minValue = 1;
                                [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                                self.jiarugouwucheBtn.enabled = YES;
                            }
                            
                            if (amount.floatValue <= 0) {
                                [self.shuliangStepper setTextValue:0];
                                leftbtn.enabled=NO;
                                rightbtn.enabled = NO;
                                self.kuncuntisLabel.text = @"售罄";
                                [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                            }
                        }else{
                            
                            if (MAIN_SCREEN_WIDTH == 320.f) {
                                
                                [self.xiangouLab setFont:[UIFont systemFontOfSize:11]];
                                [self.kuncuntisLabel setFont:[UIFont systemFontOfSize:11]];
                                
                                self.xiangouW.constant = 60;
                                self.xiangouLab.text = [NSString stringWithFormat:@"(限购%@-%@件)",limit_num,limit_quantity];
                                self.shuliangStepper.maxValue = limit_quantity.intValue;
                                if (amount.floatValue >5) {
                                    self.kuncuntisLabel.text = @"库存充足";
                                    self.shuliangStepper.minValue = 1;
                                }else if(amount.floatValue >0 && amount.floatValue <=5){
                                    
                                    self.kuncuntisLabel.text = @"库存紧张";
                                    self.shuliangStepper.minValue = 1;
                                }
                                
                                if (amount.floatValue  <= 0) {
                                    [self.shuliangStepper setTextValue:0];
                                    leftbtn.enabled=NO;
                                    rightbtn.enabled = NO;
                                    self.kuncuntisLabel.text = @"售罄";
                                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                                }
                                
                            }else{
                                
                                [self.xiangouLab setFont:[UIFont systemFontOfSize:13]];
                                [self.kuncuntisLabel setFont:[UIFont systemFontOfSize:13]];
                                self.xiangouW.constant = 90;
                                self.xiangouLab.text = [NSString stringWithFormat:@"(限购%@-%@件)",limit_num,limit_quantity];
                                self.shuliangStepper.maxValue = limit_quantity.intValue;
                                if (amount.floatValue >5) {
                                    self.kuncuntisLabel.text = @"库存充足";
                                    self.shuliangStepper.minValue = 1;
                                }else if(amount.floatValue >0 && amount.floatValue <=5){
                                    
                                    self.kuncuntisLabel.text = @"库存紧张";
                                    self.shuliangStepper.minValue = 1;
                                }
                                
                                if (amount.floatValue  <= 0) {
                                    [self.shuliangStepper setTextValue:0];
                                    leftbtn.enabled=NO;
                                    rightbtn.enabled = NO;
                                    self.kuncuntisLabel.text = @"售罄";
                                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                                }
                            }
                            
                            
                            
                        }
                        
                    }
                    
                    int i = 0;
                    
                    for (NSDictionary *tempdic in porpertyArr) {
                        
                        NSArray *setmealArr = tempdic[@"setmeal"];
                        
                        if (setmealArr.count == 1) {
                            self.guigeH.constant = 40;
                            jieduanIndex = 0;
                            NSDictionary *guigeDic1 = setmealArr[0];
                            NSString *guigestr1 = guigeDic1[@"name"];
                            NSString *guigeidstr1 = guigeDic1[@"property_value_id"];
                            if (i == 0) {
                                [huoyuanArray addObject:guigestr1];
                                [huoyuanIDArray addObject:guigeidstr1];
                            }else{
                                
                                
                                if ([huoyuanArray containsObject:guigestr1] ) {
                                    
                                }else{
                                    
                                    [huoyuanArray addObject:guigestr1];
                                    [huoyuanIDArray addObject:guigeidstr1];
                                }
                                
                            }
                            
                            i++;
                            
                        }else{
                            
                            NSDictionary *guigeDic1 = setmealArr[0];
                            NSDictionary *guigeDic2 = setmealArr[1];
                            NSString *guigestr1 = guigeDic1[@"name"];
                            NSString *guigeidstr1 = guigeDic1[@"property_value_id"];
                            NSString *guigestr2 = guigeDic2[@"name"];
                            NSString *guigeidstr2 = guigeDic2[@"property_value_id"];
                            jieduanIndex = 0;
                            if (i == 0) {
                                
                                [huoyuanArray addObject:guigestr1];
                                [huoyuanIDArray addObject:guigeidstr1];
                                
                            }else{
                                
                                if ([huoyuanArray containsObject:guigestr1]) {
                                    
                                }else{
                                    
                                    [huoyuanArray addObject:guigestr1];
                                    [huoyuanIDArray addObject:guigeidstr1];
                                    
                                }
                                
                            }
                            i++;
                            
                            NSString *tempidstr = huoyuanIDArray[0];
                            if ([tempidstr isEqual:guigeidstr1]) {
                                
                                if ([jieduanArray containsObject:guigestr2]) {
                                    
                                }else{
                                    
                                    [jieduanArray addObject:guigestr2];
                                    [jieduanIDArray addObject:guigeidstr2];
                                    
                                }
                            }
                            
                        }
                        
                    }
                    
                    [_tableView reloadData];
                }
                else{
                    
                    isSelectguige = NO;
                    self.guigeH.constant = 0;
                    
                    NSString *promition_start_time = dic[@"pinfo"][@"promition_start_time"];
                    NSString *promition_end_time = dic[@"pinfo"][@"promition_end_time"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
                    NSString *nowdate= [dateFormatter stringFromDate:[NSDate date]];
                    NSDate *date=[dateFormatter dateFromString:nowdate];
                    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
                    NSLog(@"timeSp:%@",timeSp);
                    
                    if ([promition_start_time isEqual:@0] || [promition_end_time isEqual:@0] ) {
                        
                        float pricef = [dic[@"pinfo"][@"price"] floatValue];
                        self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                        
                    }else if (![promition_start_time isEqual:@0] && ![promition_end_time isEqual:@0] ){
                        
                        NSString *is_promotion = dic[@"pinfo"][@"is_promotion"];
                        
                        if ([is_promotion isKindOfClass:[NSString class]]) {
                            if ([is_promotion isEqualToString:@"1"] && promition_start_time.doubleValue < timeSp.doubleValue && promition_end_time.doubleValue > timeSp.doubleValue) {
                                
                                float pricef = [dic[@"pinfo"][@"promotion_price"]floatValue] ;
                                self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                                float  originprice= [dic[@"pinfo"][@"price"] floatValue];
                                if (originprice == 0.0) {
                                    self.yuanjiaLabel.hidden = YES;
                                }
                                
                                NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                                
                                NSAttributedString *attrStr =
                                [[NSAttributedString alloc]initWithString:pricestr
                                                               attributes:
                                 @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                                   NSForegroundColorAttributeName:[UIColor grayColor],
                                   NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                   NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                                self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                                
                            }else{
                                
                                float pricef = [dic[@"pinfo"][@"price"] floatValue];
                                self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                                
                            }
                        }
                        
                    }
                    
                    self.shuliangStepper.paramDic = dic;
                    
                    [self.shuliangStepper setTextValue:1];
                    UIButton *leftbtn = (UIButton*)self.shuliangStepper.leftView;
                    UIButton *rightbtn = (UIButton*)self.shuliangStepper.rightView;
                    
                    NSString *amount = dic[@"pinfo"][@"amount"];
                    NSString *safe_amount = dic[@"pinfo"][@"safe_amount"];
                    NSString *sell_amount = dic[@"pinfo"][@"sell_amount"];
                    NSString *limit_quantity = dic[@"pinfo"][@"limit_quantity"];
                    NSString *limit_num = dic[@"pinfo"][@"limit_num"];
                    
                    if (limit_quantity && [limit_quantity isEqualToString:@"0"]) {
                        self.xiangouW.constant = 0;
                        self.shuliangStepper.maxValue = amount.intValue;
                        if (amount.floatValue >5) {
                            self.kuncuntisLabel.text = @"库存充足";
                            
                            self.shuliangStepper.minValue = 1;
                        }else if(amount.floatValue >0 && amount.floatValue <=5){
                            
                            self.kuncuntisLabel.text = @"库存紧张";
                            self.shuliangStepper.minValue = 1;
                        }
                        
                        if (amount.floatValue  <= 0) {
                            [self.shuliangStepper setTextValue:0];
                            leftbtn.enabled=NO;
                            rightbtn.enabled = NO;
                            self.kuncuntisLabel.text = @"售罄";
                            [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                        }
                    }else{
                        
                        if (MAIN_SCREEN_WIDTH == 320.f) {
                            
                            [self.xiangouLab setFont:[UIFont systemFontOfSize:11]];
                            [self.kuncuntisLabel setFont:[UIFont systemFontOfSize:11]];
                            
                            self.xiangouW.constant = 60;
                            self.xiangouLab.text = [NSString stringWithFormat:@"(限购%@-%@件)",limit_num,limit_quantity];
                            self.shuliangStepper.maxValue = limit_quantity.intValue;
                            if (amount.floatValue >5) {
                                self.kuncuntisLabel.text = @"库存充足";
                                self.shuliangStepper.minValue = 1;
                            }else if(amount.floatValue >0 && amount.floatValue <=5){
                                
                                self.kuncuntisLabel.text = @"库存紧张";
                                self.shuliangStepper.minValue = 1;
                            }
                            
                            if (amount.floatValue <= 0) {
                                [self.shuliangStepper setTextValue:0];
                                leftbtn.enabled=NO;
                                rightbtn.enabled = NO;
                                self.kuncuntisLabel.text = @"售罄";
                                [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                            }
                            
                        }else{
                            
                            [self.xiangouLab setFont:[UIFont systemFontOfSize:13]];
                            [self.kuncuntisLabel setFont:[UIFont systemFontOfSize:13]];
                            self.xiangouW.constant = 90;
                            self.xiangouLab.text = [NSString stringWithFormat:@"(限购%@-%@件)",limit_num,limit_quantity];
                            self.shuliangStepper.maxValue = limit_quantity.intValue;
                            if (amount.floatValue >5) {
                                self.kuncuntisLabel.text = @"库存充足";
                                self.shuliangStepper.minValue = 1;
                            }else if(amount.floatValue >0 && amount.floatValue <=5){
                                
                                self.kuncuntisLabel.text = @"库存紧张";
                                self.shuliangStepper.minValue = 1;
                            }
                            
                            if (amount.floatValue <= 0) {
                                [self.shuliangStepper setTextValue:0];
                                leftbtn.enabled=NO;
                                rightbtn.enabled = NO;
                                self.kuncuntisLabel.text = @"售罄";
                                [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                            }
                        }
                        
                        
                    }
                    
                }
                
                NSArray *promotionArr = dic[@"promotion"];
                [promotionArray removeAllObjects];
                for (NSDictionary *promotionDic in promotionArr) {
                    
                    NSString *nameStr = promotionDic[@"name"];
                    [promotionArray addObject:nameStr];
                }
                
                //①②③④⑤⑥⑦⑧⑨⑩
                if (promotionArray.count == 0) {
                    self.cuxiaoxinxiLabel.text = @"";
                    self.cuxiaoH.constant = 0;
                    self.cuxiaonameLabel.hidden = YES;
                    
                }else if (promotionArray.count == 1){
                    self.cuxiaonameLabel.hidden = NO;
                    self.cuxiaoH .constant  = 40;
                    self.cuxiaoxinxiH.constant  = 18;
                    self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@",promotionArray[0]];
                }
                else if (promotionArray.count == 2){
                    self.cuxiaonameLabel.hidden = NO;
                    self.cuxiaoH.constant  = 58;
                    self.cuxiaoxinxiH.constant  = 36;
                    self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@",promotionArray[0],promotionArray[1]];
                }else if (promotionArray.count == 3){
                    self.cuxiaonameLabel.hidden = NO;
                    self.cuxiaoH.constant  = 76;
                    self.cuxiaoxinxiH.constant  = 54;
                    self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@",promotionArray[0],promotionArray[1],promotionArray[2]];
                }else if (promotionArray.count == 4){
                    self.cuxiaonameLabel.hidden = NO;
                    self.cuxiaoH.constant  = 94;
                    self.cuxiaoxinxiH.constant  = 72;
                    self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3]];
                }else if (promotionArray.count == 5){
                    self.cuxiaonameLabel.hidden = NO;
                    self.cuxiaoH.constant  = 112;
                    self.cuxiaoxinxiH.constant  = 90;
                    self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@\n⑤ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3],promotionArray[4]];
                }else if (promotionArray.count == 6){
                    self.cuxiaonameLabel.hidden = NO;
                    self.cuxiaoH.constant  = 130;
                    self.cuxiaoxinxiH.constant  = 108;
                    self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@\n⑤ %@\n⑥ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3],promotionArray[4],promotionArray[5]];
                }else if (promotionArray.count == 7){
                    self.cuxiaonameLabel.hidden = NO;
                    self.cuxiaoH.constant  = 148;
                    self.cuxiaoxinxiH.constant  = 126;
                    self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@\n⑤ %@\n⑥ %@\n⑦ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3],promotionArray[4],promotionArray[5],promotionArray[6]];
                }else if (promotionArray.count == 8){
                    self.cuxiaonameLabel.hidden = NO;
                    self.cuxiaoH.constant  = 166;
                    self.cuxiaoxinxiH.constant  = 144;
                    self.cuxiaoxinxiLabel.text = [NSString stringWithFormat:@"① %@\n② %@\n③ %@\n④ %@\n⑤ %@\n⑥ %@\n⑦ %@\n⑧ %@",promotionArray[0],promotionArray[1],promotionArray[2],promotionArray[3],promotionArray[4],promotionArray[5],promotionArray[6],promotionArray[7]];
                }
                
                NSString *count = dic[@"comment_score"];
                
                UIImage *image1 = [UIImage imageNamed:@"Star_big2"];
                
                if (count.intValue == 0) {
                    
                    self.star1.image = image1;
                    self.star2.image = image1;
                    self.star3.image = image1;
                    self.star4.image = image1;
                    self.star5.image = image1;
                }else if (count.intValue == 1){
                    
                    self.star2.image = image1;
                    self.star3.image = image1;
                    self.star4.image = image1;
                    self.star5.image = image1;
                    
                }else if (count.intValue == 2){
                    
                    self.star3.image = image1;
                    self.star4.image = image1;
                    self.star5.image = image1;
                    
                }else if (count.intValue == 3){
                    
                    self.star4.image = image1;
                    self.star5.image = image1;
                    
                }else if (count.intValue == 4){
                    
                    self.star5.image = image1;
                    
                }else if (count.intValue == 5){
                    
                    
                }
                
                if (dic && dic[@"pinfo"] && dic[@"pinfo"]!=[NSNull null]) {
                    
                    NSDictionary *tempdic = dic[@"pinfo"];
                    self.shareDic = tempdic;
                    if (tempdic[@"jmsp_id"] && tempdic[@"jmsp_id"] !=[NSNull null]) {
                        spid = dic[@"pinfo"][@"jmsp_id"];
                        
                    }
                    
                    //加载h5详情页
                    if (dic[@"pinfo"][@"detail"]) {
                        NSString *htmlCode = [NSString stringWithFormat:@"<html><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"><style type=\"text/css\">body{font-size : 0.9em;}img{width:%@ !important;}</style></head><body>%@</body></html>",@"100%",dic[@"pinfo"][@"detail"]];
                        NSLog(@"%@",htmlCode);
                        
                        [self.webView loadHTMLString:htmlCode baseURL:nil];
                    }
                    
                    self.biaotiLabel.text = dic[@"pinfo"][@"pname"];
                    self.texingLabel.text = dic[@"pinfo"][@"p_name"];
                    
                    
                    
                    if ([dic[@"pinfo"][@"way"] isEqualToString:@"1"]) {
                        self.kujingBgView.hidden = YES;
                        self.kuajingHeight.constant = 0;
                        isglobal = NO;
                      
                    }
                    else if ([dic[@"pinfo"][@"way"] isEqualToString:@"3"]){
                        
                        self.kujingBgView.hidden = YES;
                        self.kuajingHeight.constant = 0;
                        isglobal = NO;
                        
                    }
                    
                    else{
                        NSString *promition_start_time = dic[@"pinfo"][@"promition_start_time"];
                        NSString *promition_end_time = dic[@"pinfo"][@"promition_end_time"];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
                        NSString *nowdate= [dateFormatter stringFromDate:[NSDate date]];
                        NSDate *date=[dateFormatter dateFromString:nowdate];
                        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
                        NSLog(@"timeSp:%@",timeSp);
                        
                        self.kujingBgView.hidden = NO;
                        self.kuajingHeight.constant = 120;
                        
                        if (![dic[@"pinfo"][@"production_name"] isEqualToString:@""]) {
                            
                            self.yuanchandiLabel.text = dic[@"pinfo"][@"production_name"];
                            self.blankview.hidden = YES;
                            
                        }else{
                            
                            self.yuanchandiView.hidden = YES;
                            self.yuanchandiH.constant = 0;
                            self.kuajingHeight.constant = 80;
                            
                        }
                        
                        if ([promition_start_time isEqual:@0] || [promition_end_time isEqual:@0] ) {
                            float xiaofeishuilv = 0.00;
                            if (dic[@"pinfo"][@"tax"] != [NSNull null] && dic[@"pinfo"][@"tax"]) {
                                xiaofeishuilv = [dic[@"pinfo"][@"tax"] floatValue];
                            }
                            float pricef = [dic[@"pinfo"][@"price"] floatValue];
                            float zengzhishuilv = [dic[@"tax"][@"vat"] floatValue];
                            float shuifei =(((xiaofeishuilv + zengzhishuilv)/(1 - xiaofeishuilv)) * 0.7) * pricef;
                            self.shuilvLabel.text =[NSString stringWithFormat:@"预计￥%.2f",shuifei];
                            
                        }else if (![promition_start_time isEqual:@0] && ![promition_end_time isEqual:@0] ){
                            
                            NSString *is_promotion = dic[@"pinfo"][@"is_promotion"];
                            
                            if ([is_promotion isKindOfClass:[NSString class]]) {
                                if ([is_promotion isEqualToString:@"1"] && promition_start_time.doubleValue < timeSp.doubleValue && promition_end_time.doubleValue > timeSp.doubleValue) {
                                    
                                    float pricef = [dic[@"pinfo"][@"promotion_price"]floatValue];
                                    
                                    float xiaofeishuilv = 0.00;
                                    if (dic[@"pinfo"][@"tax"] != [NSNull null] && dic[@"pinfo"][@"tax"]) {
                                        xiaofeishuilv = [dic[@"pinfo"][@"tax"] floatValue];
                                    }
                                    
                                    float zengzhishuilv = [dic[@"tax"][@"vat"] floatValue];
                                    float shuifei =(((xiaofeishuilv + zengzhishuilv)/(1 - xiaofeishuilv)) * 0.7) * pricef;
                                    self.shuilvLabel.text =[NSString stringWithFormat:@"预计￥%.2f",shuifei];
                                    NSLog(@"self.shuilvLabel.text===%@",self.shuilvLabel.text);
                                    
                                }else{
                                    
                                    float xiaofeishuilv = 0.00;
                                    if (dic[@"pinfo"][@"tax"] != [NSNull null] && dic[@"pinfo"][@"tax"]) {
                                        xiaofeishuilv = [dic[@"pinfo"][@"tax"] floatValue];
                                    }
                                    float pricef = [dic[@"pinfo"][@"price"] floatValue];
                                    float zengzhishuilv = [dic[@"tax"][@"vat"] floatValue];
                                    float shuifei =(((xiaofeishuilv + zengzhishuilv)/(1 - xiaofeishuilv)) * 0.7) * pricef;
                                    self.shuilvLabel.text =[NSString stringWithFormat:@"预计￥%.2f",shuifei];
                                    
                                }
                            }
                            
                        }
                        
                        isglobal = YES;
                        
                    }
                    
                }
                if (dic && dic[@"pinfo"] && dic[@"pinfo"] !=[NSNull null]) {
                    
                    NSDictionary *tempdic2 = dic[@"pinfo"];
                    if (tempdic2[@"detail"] && tempdic2[@"detail"] !=[NSNull null]) {
                        weburl = tempdic2[@"detail"];
                    }
                }
                
                NSLog(@"_imageArray===%@",dic[@"pinfo"][@"pic_more"]);
                _imageArray = dic[@"pinfo"][@"pic_more"];
   
                if (![_imageArray isKindOfClass:[NSNull class]]) {//防崩溃
                    [self imageUIInit];
                }
  
                [overView removeFromSuperview];
                
            }
            else if([responseObject[@"code"]isEqual:@1002]){
                
                [overView removeFromSuperview];
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText =[NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                [_hud hide:YES afterDelay:1];
                [self showError];
                
            }else{
            
                [overView removeFromSuperview];
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText =[NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                [_hud hide:YES afterDelay:1];
            }
    
        } failure:^( NSError *error) {
            self.shoucangButton.enabled = NO;
            self.jiarugouwucheBtn.enabled = NO;
            
            [overView removeFromSuperview];

            [self closeLoadingView];
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = REQUEST_ERROR_ZL;
            [_hud hide:YES afterDelay:2];
        }];

}
-(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小
-(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取gif图片的大小
-(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
-(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

//店铺数据
-(void)loaddataDianpu{
    

    NSLog(@"paramDic==%@===22%@",_paramDic,pDic);
    
    NSString *dpid = pDic[@"pinfo"][@"userid"];
   
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=shop&s=shop&uid=%@&client_type=ios&app_version=%@",MATROJP_BASE_URL,dpid,vCFBundleShortVersionStr];
    
    [MLHttpManager get:urlStr params:nil m:@"shop" s:@"shop" success:^(id responseObject){
        NSLog(@"responseObject===%@",responseObject);
        [self closeLoadingView];
        if ([responseObject[@"code"] isEqual:@0]) {
            NSDictionary *shop_info = responseObject[@"data"][@"shop_info"];
            dPDic = shop_info;
            NSString *logo = shop_info[@"logo"];
            if (![logo isKindOfClass:[NSNull class]]) {
                
                if ([logo hasSuffix:@"webp"]) {
                    [self.dianpuimage setZLWebPImageWithURLStr:logo withPlaceHolderImage:PLACEHOLDER_IMAGE];
                } else {
                    [self.dianpuimage sd_setImageWithURL:[NSURL URLWithString:logo] placeholderImage:[UIImage imageNamed:@"icon_default"]];
                }
            }else{
                
                self.dianpuimage.image = [UIImage imageNamed:@"icon_default"];
            }
            self.dianpuH.constant = 210;
            self.yonghucaozuoH.constant = 44;
            /*
            NSArray *csarr = shop_info[@"cs"];
            if (csarr.count == 0) {
                self.dianpuH.constant = 166;
                self.yonghucaozuoH.constant = 0;
            }else{
                for (NSDictionary *tempdic in csarr) {
                    NSString *tool = tempdic[@"tool"];
                    NSString *number = tempdic[@"number"];
                    
                    if ([tool isKindOfClass:[NSString class]]) {
                        if ([tool isEqualToString:@"4"]) {
                            phoneNum = number;
                            break;
                        }
                    }
                }
                
                if (![phoneNum isEqualToString:@""] && ![phoneNum isKindOfClass:[NSNull class]] && phoneNum != nil) {
                    self.dianpuH.constant = 210;
                    self.yonghucaozuoH.constant = 44;
                }else{
                    
                    self.dianpuH.constant = 166;
                    self.yonghucaozuoH.constant = 0;
                }
            }*/
            self.dianpuname.text = shop_info[@"company"];
            NSString *tempstr = shop_info[@"main_pro"];
            if ([tempstr isKindOfClass:[NSString class]]) {
                if ([tempstr isEqualToString:@""]) {
                    
                    self.dianputexing.hidden = YES;
                    [self.dianpuname mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.centerY.mas_equalTo(self.dianpuimage);
                        
                    }];
                    
                }else{
                    
                    self.dianputexing.text = shop_info[@"main_pro"];
                    
                }
            }

            NSString  *score_a = shop_info[@"score_a"];
            NSString *score_b = shop_info[@"score_b"];
            NSString *score_c = shop_info[@"score_c"];
            
            self.miaoshuNum.text = [NSString stringWithFormat:@"%@",score_a];
            self.fuwuNum.text = [NSString stringWithFormat:@"%@",score_b];
            self.wuliuNum.text = [NSString stringWithFormat:@"%@",score_c];
            
            self.guanzhuNum.text = shop_info[@"shop_collect"];
            self.shangpinNum.text = shop_info[@"product_num"];
            self.dongtaiNum.text = shop_info[@"news_num"];
            
        }else if ([responseObject[@"code"]isEqual:@1002]){
            
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            [self showError];
        
        }else{
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            
        }
        
    } failure:^(NSError *error){
        [self closeLoadingView];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:1];
        
    }];
   
    
}


//猜你喜欢的数据
- (void)guessYLike {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=guess_like&method=get_guess_like&start=0&limit=8&catid=&brandid=",MATROJP_BASE_URL];
    
    [MLHttpManager get:urlStr params:nil m:@"product" s:@"guess_like" success:^(id responseObject) {
        //NSLog(@"responseObject===%@",responseObject);
        [self closeLoadingView];
        if([responseObject[@"code"]isEqual:@0])
        {
            [_recommendArray removeAllObjects];
            NSArray *arr = responseObject[@"data"][@"product"];
            if (arr && arr.count>0) {
                [_recommendArray addObjectsFromArray:arr];
            }
            NSInteger row = 2;
            if (_recommendArray.count != 0) {
                _likeH.constant = 170*row;
                
            }else{
                
                _likeH.constant = 0;
                
            }
            [_collectionView reloadData];
            NSLog(@"猜你喜欢数据：++++%@",responseObject[@"data"]);
        }else if ([responseObject[@"code"]isEqual:@1002]){
        
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            [self showError];
        }else{
        
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
        }
        
        
    } failure:^(NSError *error) {
        [self closeLoadingView];
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = REQUEST_ERROR_ZL;
        [_hud hide:YES afterDelay:2];
    }];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//关于税费计算
- (IBAction)actShuifei:(id)sender {
    NSString *code = @"35";
    MLHelpCenterDetailController *vc = [[MLHelpCenterDetailController alloc]init];
    vc.webCode = code;
    [self.navigationController  pushViewController:vc animated:YES];
    
}


#pragma mark 立即购买
- (IBAction)buyAction:(id)sender {
  
    [self addShoppingBag:nil];
    
    
}
#pragma mark 加入购物袋
- (IBAction)addShoppingBag:(id)sender {
    /*
     http://localbbc.matrojp.com/api.php?m=product&s=cart&action=add_cart
     POST
     id=12301 商品id    商品详情接口里的   pinfo  下的id
     nums=1 商品数量
     sid=12311 商品规格ID    没有规格的填0 有规格填 商品详情接口里的   pinfo  下的 property  下的 id 字段
     
     sku=0  商品货号   没有规格的时候填商品详情接口里的   pinfo  下的code,如果是带规格的那么填pinfo  下的 property  下的 sku字段
    */
    
    if ([self.kuncuntisLabel.text isEqualToString:@"售罄"]) {
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"此商品已售罄";
        [_hud hide:YES afterDelay:1];
        return;
    }
    
    float amount = [pDic[@"pinfo"][@"amount"] floatValue];
    
    if (amount && amount < 0) {
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"已超出此商品购买数量";
        [_hud hide:YES afterDelay:1];
        return;
    }
    
    if ([_shuliangStepper.text containsString:@"."]) {
        
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"您输入的数量有误";
        [_hud hide:YES afterDelay:1];
        return;
    }
    
    if (userid) {
        
    NSString *pid = pDic[@"pinfo"][@"id"];
    NSString *sid;
    NSString *sku;
    if (_titleArray && _titleArray.count ==0) {
        sid = @"0";
        sku = pDic[@"pinfo"][@"code"]?:@"";
        
    }else{
        
        if (isSelectguige == NO) {
            
            NSArray *temparr = pDic[@"pinfo"][@"porperty"];
            if (temparr && temparr.count > 0) {
                NSDictionary *tempdic = temparr[0];
                sid = tempdic[@"id"]?:@"";
                sku = tempdic[@"sku"]?:@"";
            }
        }
        else{
            sid = Searchdic[@"id"]?:@"";
            sku= Searchdic[@"sku"]?:@"";
        }
    }
    
 
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=add_cart",MATROJP_BASE_URL];
    NSDictionary *params = @{@"id":pid,@"nums":[NSNumber numberWithInteger:_shuliangStepper.value],@"sid":sid,@"sku":sku};
    
        NSLog(@"params===%@",params);
        
    [MLHttpManager post:urlStr params:params m:@"product" s:@"cart" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if ([result[@"code"]isEqual:@0]) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"加入购物袋成功";
            [_hud hide:YES afterDelay:1];
            [self getCartNum];
        }else if ([result[@"code"] isEqual:@1002]){
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
            [self showError];
            
        }else{
        
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            [_hud hide:YES afterDelay:1];
        }
    }
    failure:^(NSError *error) {
        NSLog(@"请求失败 error===%@",error);
        [_hud show:YES];
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"加入购物袋失败";
        [_hud hide:YES afterDelay:1];
    }];
        
    }
    else{ //离线情况下 本地缓存

        if (dPDic&&pDic) { //已经有店铺名称的和商品详情的情况
            //店铺id
            NSString *cid = _paramDic[@"userid"];
            NSString *pid = @"";
            
            /*
             zhoulu修改 START================================
             */
            if (_titleArray && _titleArray.count == 0) {
                pid = pDic[@"pinfo"][@"code"];//pDic[@"pinfo"][@"id"];
            }else{
                
                if (isSelectguige == NO) {
                    
                    NSArray *temparr = pDic[@"pinfo"][@"porperty"];
                    if (temparr && temparr.count > 0) {
                        NSDictionary *tempdic = temparr[0];
                        pid = tempdic[@"sku"];
                    }
                }
                else{
                    pid = Searchdic[@"sku"];
                    
                }
            }
            
            
            /*
             zhoulu修改 END================================
             */
            //根据店铺id去查记录
            NSPredicate *cPre = [NSPredicate predicateWithFormat:@"cid == %@",cid];
            CompanyInfo *cp = [CompanyInfo MR_findFirstWithPredicate:cPre];
            if (cp) {//如果能查到店铺
                NSString *pids = cp.shopCart;
                //是否包含该记录
                if([pids rangeOfString:pid].location == NSNotFound)
                {//如果已经包含  查出该记录  记录Nums++
                    NSString *pids = cp.shopCart;
                    NSMutableArray *tmp = [[pids componentsSeparatedByString:@","] mutableCopy];
                    [tmp addObject:pid];
                    cp.shopCart = [tmp componentsJoinedByString:@","];
                    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
                }
            }else{ //如果查不到记录
                //添加一条店铺记录
                CompanyInfo *cp = [CompanyInfo MR_createEntity];
                cp.company = dPDic[@"company"];
                cp.cid = self.paramDic[@"userid"];
                cp.shopCart = pid;
                cp.checkAll = 0;
                [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
             }
           
            
            
            [self saveShopCartWithPid:pid];
            
        }
    }
    
}


- (void)saveShopCartWithPid:(NSString *)pid{
    NSLog(@"pid111===%@",pid);
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"sku == %@",pid];
    OffLlineShopCart *model2 = (OffLlineShopCart *)[OffLlineShopCart MR_findFirstWithPredicate:pre];
    if (model2) { //说明已经存在了 Num加
        model2.num = model2.num + self.shuliangStepper.value;
        NSLog(@"model2.num---->%hd",model2.num);
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            [MBProgressHUD showMessag:@"加入购物袋成功" toView:self.view];
            [self getCartNum];
        }];
    }
    else{ //如果没有就直接加进去
        OffLlineShopCart  *model = [OffLlineShopCart MR_createEntity];

        NSString *sid ;
        NSString *sku;
        if (_titleArray && _titleArray.count ==0) {
            sid = @"0";
            sku = pDic[@"pinfo"][@"code"]?:@"";
            model.amount = [pDic[@"pinfo"][@"amount"] integerValue];
            model.pro_price = [pDic[@"pinfo"][@"price"] floatValue];
            
        }else{
            
            if (isSelectguige == NO) {
                
                NSArray *temparr = pDic[@"pinfo"][@"porperty"];
                if (temparr && temparr.count > 0) {
                    NSDictionary *tempdic = temparr[0];
                    sid = tempdic[@"id"]?:@"";
                    sku = tempdic[@"sku"]?:@"";
                    model.amount = [tempdic[@"stock"] integerValue];
                    model.pro_price = [tempdic[@"price"] floatValue];
                    NSArray *setmealArr = temparr[0][@"setmeal"];
                    
                    if (setmealArr && setmealArr.count >0) {
                        if (setmealArr.count == 1) {
                            
                            model.setmeal = setmealArr[0][@"name"]?:@"";
                            
                        }else if(setmealArr.count == 2 ){
                            
                            NSString *name1 = setmealArr[0][@"name"]?:@"";
                            NSString *name2 = setmealArr[1][@"name"]?:@"";
                            NSString *setmealname = [NSString stringWithFormat:@"%@,%@",name1,name2];
                            model.setmeal = setmealname;
   
                        }
                    }
                    
                }
            }
            else{
                
                sid = Searchdic[@"id"]?:@"";
                sku= Searchdic[@"sku"]?:@"";
                
                model.amount = [Searchdic[@"stock"] integerValue];
                model.pro_price = [Searchdic[@"price"] floatValue];
                NSArray *setmealArr = Searchdic[@"setmeal"];
                
                if (setmealArr && setmealArr.count >0) {
                    if (setmealArr.count == 1) {
                        
                        model.setmeal = setmealArr[0][@"name"]?:@"";
                        
                    }else if(setmealArr.count == 2 ){
                        
                        NSString *name1 = setmealArr[0][@"name"]?:@"";
                        NSString *name2 = setmealArr[1][@"name"]?:@"";
                        NSString *setmealname = [NSString stringWithFormat:@"%@,%@",name1,name2];
                        model.setmeal = setmealname;
  
                    }
                }
                
            }
        }
 
        model.pid = pDic[@"pinfo"][@"id"];
        model.pname = pDic[@"pinfo"][@"pname"];
        model.pic = pDic[@"pinfo"][@"pic"];
        model.num = self.shuliangStepper.value;
        model.company_id= _paramDic[@"userid"];
        
//        model.sid = pDic[@"pinfo"][@"property"][@"id"]?:@"0";
//        model.sku = pDic[@"pinfo"][@"property"][@"sku"]?:pDic[@"pinfo"][@"code"];
        model.sid = sid;
        model.sku = sku;
        NSLog(@"sid===%@sku===%@====%@",sid,sku,model.setmeal);
        
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            [MBProgressHUD showMessag:@"加入购物袋成功" toView:self.view];
            [self getCartNum];
        }];
        
    }

}



#pragma alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MLLoginViewController *vc = [[MLLoginViewController alloc] init];
     vc.isLogin = YES;
   // YMNavigationController *nvc = [[YMNavigationController alloc]initWithRootViewController:vc];
     [self presentViewController:vc animated:YES completion:nil];
    
}
#pragma mark- 分享按钮
-(void)shareButtonAction{
    
    if (!self.shareDic) {
        return;
    }
    NSLog(@"self.paramDic===%@",self.shareDic);
    
    MLShareGoodsViewController *vc = [[MLShareGoodsViewController alloc]init];
    vc.paramDic = self.shareDic;
    
    if (self.imageScrollView.subviews.count>0) {
         UIImageView *imgView = [self.imageScrollView.subviews firstObject];
        vc.qzoneImg = imgView.image;
    }
   
    __weak typeof(self) weakself = self;
    vc.erweimaBlock = ^(){
        MLGoodsSharePhotoViewController *vc = [[MLGoodsSharePhotoViewController alloc]init];
        vc.goodsDetail = weakself.shareDic;
        vc.paramDic = weakself.shareDic;
        vc.img_url = imgUrlArray.count>0?[imgUrlArray firstObject]:@"";
        vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            
            vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
        }else{
            
            self.modalPresentationStyle=UIModalPresentationCurrentContext;
            
        }
        [self presentViewController:vc  animated:YES completion:^(void)
         {
             vc.view.superview.backgroundColor = [UIColor clearColor];
             
         }];
    };
    vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
        vc.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        
    }else{
        
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
        
    }
    
    [self presentViewController:vc  animated:YES completion:^(void)
     {
         vc.view.superview.backgroundColor = [UIColor clearColor];
         
     }];
    
    
}

#pragma mark- 图片相关
- (void)imageUIInit {
    
    CGFloat imageScrollViewWidth = MAIN_SCREEN_WIDTH;
    CGFloat imageScrollViewHeight = _imageScrollView.bounds.size.height;
    
        for(int i = 0; i<_imageArray.count; i++) {
            if ([_imageArray[i] isKindOfClass:[NSNull class]]) {
                continue;
            }

        }
    for (int i=0; i<_imageArray.count; i++) {
        UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(imageScrollViewWidth*i, 0, imageScrollViewWidth,imageScrollViewHeight)];
        
        if ([_imageArray[i] hasSuffix:@"webp"]) {
            [imageview setZLWebPImageWithURLStr:_imageArray[i] withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [imageview sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        }
        NSLog(@"imageview == %@",imageview.sd_imageURL);
        
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.tag = i;
        imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
        [imageview addGestureRecognizer:singleTap];
        [_imageScrollView addSubview:imageview];
    }
    
    _imageScrollView.contentSize = CGSizeMake(imageScrollViewWidth*_imageArray.count, 0);
    _imageScrollView.bounces = NO;
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.delegate = self;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    
    _pagecontrol.numberOfPages = _imageArray.count;

}

- (void)photoTapped:(UITapGestureRecognizer *)tap{
    CPPhotoInfoViewController * vc = [[CPPhotoInfoViewController alloc]init];
    
    vc.bigPhotoImageArray =_imageArray;
    
    vc.bigPhotoImageNum = tap.view.tag;
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _imageScrollView) {
        NSInteger i = scrollView.contentOffset.x/scrollView.frame.size.width + 1;
        _pagecontrol.currentPage = i - 1;
    }

}

- (IBAction)bagButtonAction:(id)sender {
    [self getAppDelegate].tabBarController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- 购买须知
- (IBAction)xuzhiAction:(id)sender {
    
    MLBuyKnowViewController *vc = [[MLBuyKnowViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark- YAScrollSegmentControlDelegate
- (void)didSelectItemAtIndex:(NSInteger)index;{
    NSLog(@"%ld",index);
    if (titleView.selectedIndex == index) {
        return;
    }else{
        if (index == 0) {
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.navigationItem.title = @"商品详情";
                //下拉执行对应的操作
                self.mainScrollView.contentOffset = CGPointMake(0, 0);
                [self.pingmu1rootScrollView setContentOffset:CGPointMake(0, 0)];
            } completion:^(BOOL finished) {
                //结束加载
                [_webView.scrollView.header endRefreshing];
            }];

        }else{
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.navigationItem.title = @"图文详情";
                self.mainScrollView.contentOffset = CGPointMake(0, MAIN_SCREEN_HEIGHT - 64);
            } completion:^(BOOL finished) {
                //结束加载
                [_pingmu1rootScrollView.footer endRefreshing];
            }];
            
        }
    }

}



#pragma mark - UIWebViewDelegate

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", error);
}



#pragma mark- UICollectionViewDataSource And UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _recommendArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RecommendCollectionViewCell" ;
    
    UINib *nib = [UINib nibWithNibName:@"RecommendCollectionViewCell"bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:CellIdentifier];
    
    RecommendCollectionViewCell * cell = (RecommendCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *paramdic = [_recommendArray objectAtIndex:indexPath.row];
    if (paramdic[@"activity_pic"]) {
        NSArray *activity_picArr = paramdic[@"activity_pic"];
        CGFloat width = 0.f;
        if (activity_picArr && activity_picArr.count>0) {
            cell.ActivityView.hidden = NO;
            for (int i = 0; i<activity_picArr.count; i++) {
                NSString *url = activity_picArr[i][@"pic_app"];
                CGSize size =[self getImageSizeWithURL:url];
                if (i>=1) {
                    NSString *preurl = activity_picArr[i-1][@"pic_app"];
                    CGSize presize =[self getImageSizeWithURL:preurl];
                    width = width + presize.width/4;
                }
                
                //                        NSLog(@"size--->%@---->%f",NSStringFromCGSize(size),width);
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width + i*5), 0, size.width/4, size.height/4)];
                if ([url hasSuffix:@"webp"]) {
                    [imageView setZLWebPImageWithURLStr:url withPlaceHolderImage:PLACEHOLDER_IMAGE];
                } else {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon_default"]];
                }
                [cell.ActivityView addSubview:imageView];
            }
        }else{
            cell.ActivityView.hidden = YES;
        }
    }else{
        cell.ActivityView.hidden = YES;
    }
    cell.productNameLabel.text = paramdic[@"pname"];
    NSString *picstr = paramdic[@"pic"];
    if (![picstr isKindOfClass:[NSNull class]]) {
        
        if ([paramdic[@"pic"] hasSuffix:@"webp"]) {
            [cell.productImageView setZLWebPImageWithURLStr:paramdic[@"pic"] withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:paramdic[@"pic"]] placeholderImage:[UIImage imageNamed:@"icon_default"]];
        }
    }else{
    
        cell.productImageView .image = [UIImage imageNamed:@"icon_default"];
    }
    
    NSString *pricestr = paramdic[@"price"];
    float promotion_price = [paramdic[@"promotion_price"] floatValue];
    if (promotion_price == 0.00) {
        CGFloat price = [pricestr floatValue];
        cell.productPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
    }else{
    
       cell.productPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",promotion_price];
    }
    
    
    /*
    NSString *priceStr = paramdic[@"XJ"];
    NSString *realStr = paramdic[@"LSDJ"];
    CGFloat xj = [priceStr floatValue];
    CGFloat lsdj = [realStr floatValue];
    
    NSString   *newpriceStr = [NSString stringWithFormat:@"<font name = \"STHeitiSC-Light\" size = \"13\"><color value = \"#856D47\">￥%.2f </></><font name = \"STHeitiSC-Light\" size = \"13\"><strike  word=\"true\"><color value = \"#505050\">￥%.2f</></></>",xj,lsdj];
    cell.productPriceLabel.attributedText = [newpriceStr createAttributedString];
     */
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((MAIN_SCREEN_WIDTH - 35)/4, 165);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
    NSDictionary *dic = [_recommendArray objectAtIndex:indexPath.row];
    if (dic) {
        MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
        vc.paramDic = dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 0);
}



#pragma mark- UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    __weak typeof(self) weakself = self;
    static NSString *CellIdentifier = @"MLGoodsDetailsTableViewCell" ;
    MLGoodsDetailsTableViewCell *cell = (MLGoodsDetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    
    cell.infoTitleLabel.text = [ NSString stringWithFormat:@"%@:", _titleArray[indexPath.row]];
    
    NSString *is_promotion = pDic[@"pinfo"][@"is_promotion"];
    NSString *promition_start_time = pDic[@"pinfo"][@"promition_start_time"];
    NSString *promition_end_time = pDic[@"pinfo"][@"promition_end_time"];
    NSString *limit_quantity = pDic[@"pinfo"][@"limit_quantity"];
    NSString *limit_num = pDic[@"pinfo"][@"limit_num"];
    
   
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
    NSString *nowdate= [dateFormatter stringFromDate:[NSDate date]];
    NSDate *date=[dateFormatter dateFromString:nowdate];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp);
    
    if (indexPath.row == 0) {
        cell.tags = huoyuanArray;
        cell.goodsBiaoQianSelBlock = ^(NSArray *tagsIndex){
            isSelectguige = YES;
            
            NSString *indexStr = [tagsIndex firstObject];
            NSInteger index = [indexStr integerValue];
            huoyunaIndex = index;
            
            NSString *str = [huoyuanArray objectAtIndex:index];
            NSString *idstr1 = [huoyuanIDArray objectAtIndex:index];
            NSString *idstr2 = nil;
            if (jieduanIDArray && jieduanIDArray.count == 0) {
                
            }else{
                
                idstr2 = [jieduanIDArray objectAtIndex:jieduanIndex];

            }
            NSLog(@"%ld%@%@%@",(long)index,str,idstr1,idstr2);
            
            NSString *promotion_price;
            NSString *price;
            NSString *market_price;
            NSString *stock;
            NSString *safe_stock;
  
            for (NSDictionary *searchDic in porpertyArray) {
                NSMutableArray *guige = [[NSMutableArray alloc] init];
                NSArray *setmealArr = searchDic[@"setmeal"];
                if (setmealArr.count == 1) {
                    NSDictionary *guigeDic1 = setmealArr[0];
                    
                    NSString *guigestr1 = guigeDic1[@"name"];
                    NSString *guigeIDstr1 = guigeDic1[@"property_value_id"];
                    
                    if ([guigeIDstr1 isEqual:idstr1] ) {
                        
                        [guige addObject:guigestr1];
                        
                        Searchdic = searchDic;
                        break;
                    }
                    
//                    [guige addObject:guigestr1];
                    
                }else{
                    
                    NSDictionary *guigeDic1 = setmealArr[0];
                    NSDictionary *guigeDic2 = setmealArr[1];
                    NSString *guigestr1 = guigeDic1[@"name"];
                    NSString *guigeIDstr1 = guigeDic1[@"property_value_id"];
                    NSString *guigestr2 = guigeDic2[@"name"];
                    NSString *guigeIDstr2 = guigeDic2[@"property_value_id"];
                    
                    if ([guigeIDstr1 isEqual:idstr1] && [guigeIDstr2 isEqual:idstr2]) {
                        
                        [guige addObject:guigestr1];
                        [guige addObject:guigestr2];
                        Searchdic = searchDic;
                        break;
                    }
                   
                }
                
                /*
                for (NSString *searchStr in guige) {
                    if ([searchStr isEqualToString:str]) {
                        Searchdic = searchDic;
                        promotion_price = searchDic[@"promotion_price"];
                        price = searchDic[@"price"];
                        market_price = searchDic[@"market_price"];
                        if (market_price.floatValue == 0.0) {
                            self.yuanjiaLabel.hidden = YES;
                        }
                        stock = searchDic[@"stock"];
                        safe_stock = searchDic[@"safe_stock"];
                        
                    }
                }
                 */
            }
            
            NSLog(@"Searchdic==%@",Searchdic);
            
            promotion_price = Searchdic[@"promotion_price"];
            price = Searchdic[@"price"];
            market_price = Searchdic[@"market_price"];
            if (market_price.floatValue == 0.0) {
                self.yuanjiaLabel.hidden = YES;
            }
            stock = Searchdic[@"stock"];
            safe_stock = Searchdic[@"safe_stock"];
            
            NSLog(@"%@  %@  %@  %@  %@",promotion_price,price,market_price,stock,safe_stock);
            
            if ([promition_start_time isEqual:@0] || [promition_end_time isEqual:@0] ) {
                
                float pricef = price.floatValue;
                self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                /*
                float  originprice= [market_price floatValue];
                NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                NSAttributedString *attrStr =
                [[NSAttributedString alloc]initWithString:pricestr
                                               attributes:
                 @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                   NSForegroundColorAttributeName:[UIColor grayColor],
                   NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                   NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                self.yuanjiaLabel.attributedText = attrStr; //原价要划掉
                 */
                
            }else if(![promition_start_time isEqual:@0] && ![promition_end_time isEqual:@0] ){
                
                if ([is_promotion isEqualToString:@"1"]  && promition_start_time.doubleValue < timeSp.doubleValue && promition_end_time.doubleValue > timeSp.doubleValue) {
                    
                    float pricef = promotion_price.floatValue;
                    self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                    
                    float  originprice= [price floatValue];
                    NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                    NSAttributedString *attrStr =
                    [[NSAttributedString alloc]initWithString:pricestr
                                                   attributes:
                     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                       NSForegroundColorAttributeName:[UIColor grayColor],
                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                    self.yuanjiaLabel.attributedText = attrStr; //原价要划掉
                    
                }else{
                    
                    float pricef = price.floatValue;
                    self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                    /*
                    float  originprice= [market_price floatValue];
                    NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                    NSAttributedString *attrStr =
                    [[NSAttributedString alloc]initWithString:pricestr
                                                   attributes:
                     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                       NSForegroundColorAttributeName:[UIColor grayColor],
                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                    self.yuanjiaLabel.attributedText = attrStr; //原价要划掉
                    */
                }
            }
 
            [self.shuliangStepper setTextValue:1];
            UIButton *leftbtn = (UIButton*)self.shuliangStepper.leftView;
            UIButton *rightbtn = (UIButton*)self.shuliangStepper.rightView;
            
            if (limit_quantity && [limit_quantity isEqualToString:@"0"]) {
                self.xiangouW.constant = 0;
                self.shuliangStepper.maxValue = stock.intValue;
                leftbtn.enabled=YES;
                rightbtn.enabled = YES;
                if (stock.floatValue >5) {
                    self.kuncuntisLabel.text = @"库存充足";
                    self.shuliangStepper.minValue = 1;
                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                    self.jiarugouwucheBtn.enabled = YES;
                }else if(stock.floatValue >0 && stock.floatValue <=5){
                    
                    self.kuncuntisLabel.text = @"库存紧张";
                    self.shuliangStepper.minValue = 1;
                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                    self.jiarugouwucheBtn.enabled = YES;
                }
                
                if (stock.floatValue  <= 0) {
                    [self.shuliangStepper setTextValue:0];
                    leftbtn.enabled=NO;
                    rightbtn.enabled = NO;
                    self.kuncuntisLabel.text = @"售罄";
                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                }
            }else{
                
                if (MAIN_SCREEN_WIDTH == 320.f) {
                    [self.xiangouLab setFont:[UIFont systemFontOfSize:11]];
                    [self.kuncuntisLabel setFont:[UIFont systemFontOfSize:11]];
                    self.xiangouW.constant = 60;
                    self.xiangouLab.text = [NSString stringWithFormat:@"(限购%@-%@件)",limit_num,limit_quantity];
                    if (limit_quantity.intValue > stock.intValue) {
                        
                        self.shuliangStepper.maxValue = stock.intValue;
                    }else{
                        self.shuliangStepper.maxValue = limit_quantity.intValue;
                    }
                    leftbtn.enabled=YES;
                    rightbtn.enabled = YES;
                    
                    if (stock.floatValue >5) {
                        self.kuncuntisLabel.text = @"库存充足";
                        self.shuliangStepper.minValue = 1;
                        [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                        self.jiarugouwucheBtn.enabled = YES;
                    }else if(stock.floatValue >0 && stock.floatValue <=5){
                        
                        self.kuncuntisLabel.text = @"库存紧张";
                        self.shuliangStepper.minValue = 1;
                        [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                        self.jiarugouwucheBtn.enabled = YES;
                    }
                    
                    if (stock.floatValue  <= 0) {
                        [self.shuliangStepper setTextValue:0];
                        leftbtn.enabled=NO;
                        rightbtn.enabled = NO;
                        self.kuncuntisLabel.text = @"售罄";
                        [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                    }
                }else{
                    [self.xiangouLab setFont:[UIFont systemFontOfSize:13]];
                    [self.kuncuntisLabel setFont:[UIFont systemFontOfSize:13]];
                    self.xiangouW.constant = 90;
                    self.xiangouLab.text = [NSString stringWithFormat:@"(限购%@-%@件)",limit_num,limit_quantity];
                    if (limit_quantity.intValue > stock.intValue) {
                        
                        self.shuliangStepper.maxValue = stock.intValue;
                    }else{
                        self.shuliangStepper.maxValue = limit_quantity.intValue;
                    }
                    leftbtn.enabled=YES;
                    rightbtn.enabled = YES;
                    if (stock.floatValue >5) {
                        self.kuncuntisLabel.text = @"库存充足";
                        self.shuliangStepper.minValue = 1;
                        [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                        self.jiarugouwucheBtn.enabled = YES;
                    }else if(stock.floatValue >0 && stock.floatValue <=5){
                        
                        self.kuncuntisLabel.text = @"库存紧张";
                        self.shuliangStepper.minValue = 1;
                        [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                        self.jiarugouwucheBtn.enabled = YES;
                    }
                    
                    if (stock.floatValue  <= 0) {
                        [self.shuliangStepper setTextValue:0];
                        leftbtn.enabled=NO;
                        rightbtn.enabled = NO;
                        self.kuncuntisLabel.text = @"售罄";
                        [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                    }
                }
       
            }

        };
        
    }else{
    
        cell.tags = jieduanArray;
        cell.goodsBiaoQianSelBlock = ^(NSArray *tagsIndex){
            isSelectguige = YES;
            NSString *indexStr = [tagsIndex firstObject];
            NSInteger index = [indexStr integerValue];
            jieduanIndex = index;
            NSString *str = [jieduanArray objectAtIndex:index];
            NSString *idstr1 = [huoyuanIDArray objectAtIndex:huoyunaIndex];
            NSString *idstr2 = [jieduanIDArray objectAtIndex:index];
            NSLog(@"%ld%@%@%@",(long)index,str,idstr1,idstr2);

            NSString *promotion_price;
            NSString *price;
            NSString *market_price;
            NSString *stock;
            NSString *safe_stock;
            
            
            for (NSDictionary *searchDic in porpertyArray) {
                NSMutableArray *guige = [[NSMutableArray alloc] init];
                NSArray *setmealArr = searchDic[@"setmeal"];
                if (setmealArr.count == 1) {
                    NSDictionary *guigeDic1 = setmealArr[0];
                    
                    NSString *guigestr1 = guigeDic1[@"name"];
                    
                    
                    [guige addObject:guigestr1];
                    
                }else{
                    
                    NSDictionary *guigeDic1 = setmealArr[0];
                    NSDictionary *guigeDic2 = setmealArr[1];
                    NSString *guigestr1 = guigeDic1[@"name"];
                    NSString *guigeIDstr1 = guigeDic1[@"property_value_id"];
                    NSString *guigestr2 = guigeDic2[@"name"];
                    NSString *guigeIDstr2 = guigeDic2[@"property_value_id"];
                    
                    if ([guigeIDstr1 isEqual:idstr1] && [guigeIDstr2 isEqual:idstr2]) {
                        
                        [guige addObject:guigestr1];
                        [guige addObject:guigestr2];
                        Searchdic = searchDic;
                        break;
                    }
                }
                
                /*
                for (NSString *searchStr in guige) {
                    if ([searchStr isEqualToString:str]) {
                        Searchdic = searchDic;
                        promotion_price = searchDic[@"promotion_price"];
                        price = searchDic[@"price"];
                        market_price = searchDic[@"market_price"];
                        if (market_price.floatValue == 0.0) {
                            self.yuanjiaLabel.hidden = YES;
                        }
                        
                        stock = searchDic[@"stock"];
                        safe_stock = searchDic[@"safe_stock"];
                        
                    }
                }
                 */
            }
            
            NSLog(@"Searchdic==%@",Searchdic);
            
            promotion_price = Searchdic[@"promotion_price"];
            price = Searchdic[@"price"];
            market_price = Searchdic[@"market_price"];
            if (market_price.floatValue == 0.0) {
                self.yuanjiaLabel.hidden = YES;
            }
            stock = Searchdic[@"stock"];
            safe_stock = Searchdic[@"safe_stock"];
            
            NSLog(@"%@  %@  %@  %@",price,market_price,stock,safe_stock);
            
            if ([promition_start_time isEqual:@0] || [promition_end_time isEqual:@0] ) {
                
                float pricef = price.floatValue;
                self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                float  originprice= [market_price floatValue];
                NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                NSAttributedString *attrStr =
                [[NSAttributedString alloc]initWithString:pricestr
                                               attributes:
                 @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                   NSForegroundColorAttributeName:[UIColor grayColor],
                   NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                   NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                
            }else if(![promition_start_time isEqual:@0] && ![promition_end_time isEqual:@0] ){
                
                if ([is_promotion isEqualToString:@"1"]  && promition_start_time.doubleValue < timeSp.doubleValue && promition_end_time.doubleValue > timeSp.doubleValue) {
                    
                    float pricef = promotion_price.floatValue;
                    self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                    float  originprice= [market_price floatValue];
                    NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                    NSAttributedString *attrStr =
                    [[NSAttributedString alloc]initWithString:pricestr
                                                   attributes:
                     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                       NSForegroundColorAttributeName:[UIColor grayColor],
                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                    self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                    
                }else{
                    
                    float pricef = price.floatValue;
                    self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
                    float  originprice= [market_price floatValue];
                    NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
                    NSAttributedString *attrStr =
                    [[NSAttributedString alloc]initWithString:pricestr
                                                   attributes:
                     @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
                       NSForegroundColorAttributeName:[UIColor grayColor],
                       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                       NSStrikethroughColorAttributeName:[UIColor grayColor]}];
                    self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
                    
                }
            }
            
//            float pricef = price.floatValue;
//            self.jiageLabel.text = [NSString stringWithFormat:@"￥%.2f",pricef];
//            float  originprice= [market_price floatValue];
//            NSString *pricestr = [NSString stringWithFormat:@"￥%.2f",originprice];
//            NSAttributedString *attrStr =
//            [[NSAttributedString alloc]initWithString:pricestr
//                                           attributes:
//             @{NSFontAttributeName:[UIFont systemFontOfSize:13.f],
//               NSForegroundColorAttributeName:[UIColor grayColor],
//               NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
//               NSStrikethroughColorAttributeName:[UIColor grayColor]}];
//            self.yuanjiaLabel.attributedText=attrStr; //原价要划掉
            
            [self.shuliangStepper setTextValue:1];
            UIButton *leftbtn = (UIButton*)self.shuliangStepper.leftView;
            UIButton *rightbtn = (UIButton*)self.shuliangStepper.rightView;
            
            
            if (limit_quantity && [limit_quantity isEqualToString:@"0"]) {
                self.xiangouW.constant = 0;
                self.shuliangStepper.maxValue = stock.intValue;
                leftbtn.enabled=YES;
                rightbtn.enabled = YES;
                if (stock.floatValue >5) {
                    self.kuncuntisLabel.text = @"库存充足";
                    self.shuliangStepper.minValue = 1;
                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                    self.jiarugouwucheBtn.enabled = YES;
                }else if(stock.floatValue >0 && stock.floatValue <=5){
                    
                    self.kuncuntisLabel.text = @"库存紧张";
                    self.shuliangStepper.minValue = 1;
                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                    self.jiarugouwucheBtn.enabled = YES;
                }
                
                if (stock.floatValue  <= 0) {
                    [self.shuliangStepper setTextValue:0];
                    leftbtn.enabled=NO;
                    rightbtn.enabled = NO;
                    self.kuncuntisLabel.text = @"售罄";
                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                }
                
            }else{
                
                if (MAIN_SCREEN_WIDTH == 320.f) {
                    [self.xiangouLab setFont:[UIFont systemFontOfSize:11]];
                    [self.kuncuntisLabel setFont:[UIFont systemFontOfSize:11]];
                    self.xiangouW.constant = 60;
                    self.xiangouLab.text = [NSString stringWithFormat:@"(限购%@-%@件)",limit_num,limit_quantity];
                    if (limit_quantity.intValue > stock.intValue) {
                        
                        self.shuliangStepper.maxValue = stock.intValue;
                    }else{
                        self.shuliangStepper.maxValue = limit_quantity.intValue;
                    }
                    leftbtn.enabled=YES;
                    rightbtn.enabled = YES;
                    if (stock.floatValue >5) {
                        self.kuncuntisLabel.text = @"库存充足";
                        self.shuliangStepper.minValue = 1;
                        [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                        self.jiarugouwucheBtn.enabled = YES;
                    }else if(stock.floatValue >0 && stock.floatValue <=5){
                        
                        self.kuncuntisLabel.text = @"库存紧张";
                        self.shuliangStepper.minValue = 1;
                        [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                        self.jiarugouwucheBtn.enabled = YES;
                    }
                    
                    if (stock.floatValue  <= 0) {
                        [self.shuliangStepper setTextValue:0];
                        leftbtn.enabled=NO;
                        rightbtn.enabled = NO;
                        self.kuncuntisLabel.text = @"售罄";
                        [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                    }
                }else{
                    [self.xiangouLab setFont:[UIFont systemFontOfSize:13]];
                    [self.kuncuntisLabel setFont:[UIFont systemFontOfSize:13]];
                    self.xiangouW.constant = 90;
                    self.xiangouLab.text = [NSString stringWithFormat:@"(限购%@-%@件)",limit_num,limit_quantity];
                if (limit_quantity.intValue > stock.intValue) {
                    
                    self.shuliangStepper.maxValue = stock.intValue;
                }else{
                    self.shuliangStepper.maxValue = limit_quantity.intValue;
                }
                    leftbtn.enabled=YES;
                    rightbtn.enabled = YES;
                if (stock.floatValue >5) {
                    self.kuncuntisLabel.text = @"库存充足";
                    self.shuliangStepper.minValue = 1;
                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                    self.jiarugouwucheBtn.enabled = YES;
                }else if(stock.floatValue>0 && stock.floatValue <=5){
                    
                    self.kuncuntisLabel.text = @"库存紧张";
                    self.shuliangStepper.minValue = 1;
                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"F1653E"]];
                    self.jiarugouwucheBtn.enabled = YES;
                }
                
                if (stock.floatValue  <= 0) {
                    [self.shuliangStepper setTextValue:0];
                    leftbtn.enabled=NO;
                    rightbtn.enabled = NO;
                    self.kuncuntisLabel.text = @"售罄";
                    [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
                    }
                }
                
            }
  
            /*
            if ((stock.floatValue - safe_stock.floatValue)>5) {
                self.kuncuntisLabel.text = @"库存充足";
                self.shuliangStepper.minValue = 1;
            }else if((stock.floatValue - safe_stock.floatValue)>0&&(stock.floatValue - safe_stock.floatValue)<=5){
                
                self.kuncuntisLabel.text = @"库存紧张";
                self.shuliangStepper.minValue = 1;
            }
            
            if ((stock.floatValue - safe_stock.floatValue) == 0) {
                [self.shuliangStepper setTextValue:0];
                leftbtn.enabled=NO;
                rightbtn.enabled = NO;
                self.kuncuntisLabel.text = @"售罄";
                [self.jiarugouwucheBtn setBackgroundColor:[UIColor colorWithHexString:@"aaaaaa"]];
            }
            */
        };

    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 1) {
        if (jieduanArray.count >5) {
           self.guigeH.constant  = 120;
            return 80;
        }else{
        
            return 40;
        }
        
    }
    else {
        if (huoyuanArray.count >5) {
            self.guigeH.constant  = 120;
            return 80;
        }else{
            
            return 40;
        }
    }
    
}


#pragma Mark 收藏
- (IBAction)shouCangClick:(id)sender {
  /*
    http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_product
   do = add 【操作码】
  
   pid= 13911 【商品id】
   
   uname = ml_13771961207【会员名】
 
  */
    
    NSString *pid = pDic[@"pinfo"][@"id"];
    NSString *uname = pDic[@"pinfo"][@"user"];
    if (userid) {
        
        if (!self.shoucangButton.selected) {
        
        self.shoucangButton.selected = YES;
        self.GuanzhuBtn.selected = YES;
        NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_product",MATROJP_BASE_URL];
            NSDictionary *params = @{@"do":@"add",@"pid":pid,@"uname":uname};
            
        
      [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_product" success:^(id responseObject) {
          NSDictionary *result = (NSDictionary *)responseObject;
          if ([result[@"code"] isEqual:@0]) {
              NSString *share_add = result[@"data"][@"share_add"];
              if (share_add) {
                  [_hud show:YES];
                  _hud.mode = MBProgressHUDModeText;
                  _hud.labelText = @"收藏成功";
                  [_hud hide:YES afterDelay:1];
                  
                  [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big1"] forState:UIControlStateNormal];
                  [self.shoucangButton setTitle:@"已收藏" forState:UIControlStateNormal];
                  [self.shoucangButton setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
              }

          }else if ([result[@"code"]isEqual:@1002]){
              [_hud show:YES];
              _hud.mode = MBProgressHUDModeText;
              _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
              [_hud hide:YES afterDelay:1];
              [self showError];
              
          }else{
              [_hud show:YES];
              _hud.mode = MBProgressHUDModeText;
              _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
              [_hud hide:YES afterDelay:1];
              
          }
          
      } failure:^(NSError *error) {
          NSLog(@"请求失败 error===%@",error);
          [_hud show:YES];
          _hud.mode = MBProgressHUDModeText;
          _hud.labelText = @"你的网络好像不给力";
          [_hud hide:YES afterDelay:1];
          
      }];
    }else{
        self.shoucangButton.selected = NO;
        self.GuanzhuBtn.selected = NO;
        [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big2"] forState:UIControlStateNormal];
        [self.shoucangButton setTitle:@"收藏" forState:UIControlStateNormal];
        [self.shoucangButton setTitleColor:RGBA(38, 14, 0, 1) forState:UIControlStateNormal];
        [self deleteClick:pid];
        
        return;
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
}


#pragma Mark 取消收藏

- (void) deleteClick:(NSString*)sender{
    /*
     http://bbctest.matrojp.com/api.php?m=sns&s=admin_share_product
     
     【post】
     
     do=del 【操作码】
     
     id=2281 【收藏商品id】
    */
    NSLog(@"pDic===%@",pDic);
    NSString *pid = pDic[@"pinfo"][@"id"];
  
    if (userid) {
 
            NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_product",MATROJP_BASE_URL];
            NSDictionary *params = @{@"do":@"sel"};
            
            [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_product" success:^(id responseObject) {
                
                NSLog(@"请求成功responseObject===%@",responseObject);
                if ([responseObject[@"code"]isEqual:@0]) {
                    if (![responseObject[@"data"][@"share_list"] isKindOfClass:[NSNull class]]) {
                        
                        
                        for (NSDictionary *tempdic in responseObject[@"data"][@"share_list"]) {
                            
                            if ([pid  isEqualToString:tempdic[@"pid"]]) {
                                
                                if (!self.shoucangButton.selected) {
                                    
                                    self.shoucangButton.selected = NO;
                                    self.GuanzhuBtn.selected = NO;
                                    [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big2"] forState:UIControlStateNormal];
                                    [self.shoucangButton setTitleColor:RGBA(38, 14, 0, 1) forState:UIControlStateNormal];
                                    
                                    NSString *ppid = tempdic[@"id"];
                                    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_product",MATROJP_BASE_URL];
                                    NSDictionary *params = @{@"do":@"del",@"id":ppid};
                                    
                                    [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_product" success:^(id responseObject) {
                                        NSDictionary *result = (NSDictionary *)responseObject;
                                        if ([result[@"code"]isEqual:@0]) {
                                            NSString *share_add = result[@"data"][@"ads_del"];
                                            if (share_add) {
                                                [_hud show:YES];
                                                _hud.mode = MBProgressHUDModeText;
                                                _hud.labelText = @"取消收藏成功";
                                                [_hud hide:YES afterDelay:1];
                                            }else{
                                                
                                            }
                                        }else if ([result[@"code"]isEqual:@1002]){
                                            
                                            [_hud show:YES];
                                            _hud.mode = MBProgressHUDModeText;
                                            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                                            [_hud hide:YES afterDelay:1];
                                            [self showError];
                                            
                                        }else{
                                            [_hud show:YES];
                                            _hud.mode = MBProgressHUDModeText;
                                            _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                                            [_hud hide:YES afterDelay:1];
                                            
                                        }
                                       
                                        
                                    } failure:^(NSError *error) {
                                        NSLog(@"请求失败 error===%@",error);
                                        
                                    }];
                                }else{
                                    self.shoucangButton.selected = NO;
                                    self.GuanzhuBtn.selected = NO;
                                    [self.shoucangButton setImage:[UIImage imageNamed:@"Star_big1"] forState:UIControlStateNormal];
                                    [self.shoucangButton setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
                                    
                                    return;
                                }
                            }
                        }
                    }
                }else if ([responseObject[@"code"]isEqual:@1002]){
                   
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                    [_hud hide:YES afterDelay:1];
                    [self showError];
                    
                }else{
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                    [_hud hide:YES afterDelay:1];
                
                }
               
    } failure:^(NSError *error) {
                NSLog(@"请求失败 error===%@",error);
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = @"你的网络好像不给力";
                [_hud hide:YES afterDelay:1];
                
        }];
    }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
                [alert show];
        
        
                return;
            }

}

-(void)showError
{
    MLLoginViewController *vc = [[MLLoginViewController alloc]init];
    vc.isLogin = YES;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)actDianpu:(id)sender {
//    MLYSShopInfoViewController *vc = [[MLYSShopInfoViewController alloc]init];
//    vc.dpid = pDic[@"pinfo"][@"userid"];
    
    MLShopInfoViewController *vc = [[MLShopInfoViewController alloc]init];
    NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:kUSERDEFAULT_USERID];
    NSString *versionStr = [self getVersion];
    vc.store_link = [NSString stringWithFormat:@"%@/store/index?sid=%@&uid=%@&versionflag=%@",DianPuURL_URLString,pDic[@"pinfo"][@"userid"],phone,versionStr];
    NSLog(@"vc.store_link---->%@---->%@",vc.store_link,pDic);
    vc.uid = pDic[@"pinfo"][@"userid"];
    vc.shopparamDic = dPDic;
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (NSString*)getVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"version===%@",version);
    return version;
}
//收藏店铺
- (IBAction)actKefu:(id)sender {

    NSLog(@"联系客服pdic---->%@",pDic);
    if (userid) {
        if (!self.GuanzhuDianpu.selected) {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_shop",MATROJP_BASE_URL];
        NSDictionary *params = @{@"do":@"add",@"shopid":pDic[@"pinfo"][@"userid"],@"uname":@"ml_13771961207",@"shopname":dPDic[@"company"]};
        
        [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
            NSLog(@"请求成功responseObject===%@",responseObject);
            
            _hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:_hud];
            if ([responseObject[@"code"]isEqual:@0]) {
                if ([responseObject[@"data"][@"shop_add"]isEqual:@1]) {
                    self.GuanzhuDianpu.selected = YES;
//                    self.GuanzhuBtn.selected = YES;
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"收藏成功";
                    [_hud hide:YES afterDelay:2];
          
                }else{
                    
                    [_hud show:YES];
                    _hud.mode = MBProgressHUDModeText;
                    _hud.labelText = @"收藏失败";
                    [_hud hide:YES afterDelay:1];
                    
                }
            }else if ([responseObject[@"code"]isEqual:@1002]){
                
                [_hud show:YES];
                _hud.mode = MBProgressHUDModeText;
                _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                [_hud hide:YES afterDelay:1];
                [self showError];
            }else{
                NSString *msg = responseObject[@"msg"];
                [MBProgressHUD show:msg view:self.view];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败 error===%@",error);
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:1];
            
            
        }];
    }else{
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_shop",MATROJP_BASE_URL];
        NSDictionary *params = @{@"do":@"sel"};
        
        [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
            NSLog(@"请求成功responseObject=quxiao=%@",responseObject);
            
            if ([responseObject[@"data"][@"shop_list"] isKindOfClass:[NSString class]]) {
                
                
            }else{
                
                NSString *shopid = pDic[@"pinfo"][@"userid"];
                for (NSDictionary *tempdic in responseObject[@"data"][@"shop_list"]) {
                    if ([shopid isEqualToString:tempdic[@"shopid"]]) {
                        
                        NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=sns&s=admin_share_shop",MATROJP_BASE_URL];
                        NSDictionary *params = @{@"do":@"del",@"id":tempdic[@"id"]};
                        [MLHttpManager post:urlStr params:params m:@"sns" s:@"admin_share_shop" success:^(id responseObject) {
                            NSLog(@"请求成功responseObject==222=%@",responseObject);
                            
                            _hud = [[MBProgressHUD alloc]initWithView:self.view];
                            [self.view addSubview:_hud];
                            if ([responseObject[@"code"]isEqual:@0]) {
                                if ([responseObject[@"data"][@"shop_del"]isEqual:@1]) {
//                                    self.GuanzhuBtn.selected = NO;
                                    self.GuanzhuDianpu.selected = NO;
                                    [_hud show:YES];
                                    _hud.mode = MBProgressHUDModeText;
                                    _hud.labelText = @"取消收藏成功";
                                    [_hud hide:YES afterDelay:2];
            
                                }else{
                                    
                                    [_hud show:YES];
                                    _hud.mode = MBProgressHUDModeText;
                                    _hud.labelText = @"您的网络不给力啊";
                                    [_hud hide:YES afterDelay:1];
                                }
                            }else if ([responseObject[@"code"]isEqual:@1002]){
                                
                                [_hud show:YES];
                                _hud.mode = MBProgressHUDModeText;
                                _hud.labelText = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                                [_hud hide:YES afterDelay:1];
                                [self showError];
                            }else{
                                NSString *msg = responseObject[@"msg"];
                                [MBProgressHUD show:msg view:self.view];
                            }
                            
                            
                        } failure:^(NSError *error) {
                            NSLog(@"请求失败 error===%@",error);
                            [_hud show:YES];
                            _hud.mode = MBProgressHUDModeText;
                            _hud.labelText = @"请求失败";
                            [_hud hide:YES afterDelay:1];
                            
                        }];
                    }
                }
            }
            
        } failure:^(NSError *error) {
            NSLog(@"请求失败 error===%@",error);
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"请求失败";
            [_hud hide:YES afterDelay:1];
            
            }];
    
        }
    }else{
        [MBProgressHUD show:@"请先登录" view:self.view];
        [self showError];
    }
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]];
//    [[UIApplication sharedApplication] openURL:url];
    
}

//更改购物车数据后重新调接口同步
- (void)getCartNum{
    CartNum = 0;
    JSBadgeView *shopCarBadge = [[JSBadgeView alloc]initWithParentView:self.ShopCarBtn alignment:JSBadgeViewAlignmentTopRight];
    shopCarBadge.badgeBackgroundColor = RGBA(239, 103, 67, 1);
    if (userid) {
        NSString * url = [NSString stringWithFormat:@"%@/api.php?m=product&s=cart&action=cart_num",ZHOULU_ML_BASE_URLString];
        [MLHttpManager get:url params:nil m:@"product" s:@"cart" success:^(id responseObject) {
            NSLog(@"cart_num---->%@",responseObject);
            
            if ([responseObject[@"code"] isEqual:@0]) {
                if (responseObject[@"data"]) {
                    
                    if (responseObject[@"data"][@"cart_num"] && [responseObject[@"data"][@"cart_num"] isKindOfClass:[NSString class]]) {
                        shopCarBadge.hidden = YES;
                    }else{
                        NSString *cartNum = responseObject[@"data"][@"cart_num"];
                        if ([cartNum isEqual:@0]) {
                            shopCarBadge.hidden = YES;
                        }else{
                            shopCarBadge.hidden = NO;
                            shopCarBadge.badgeText = [NSString stringWithFormat:@"%@",cartNum];
                        }
                        
                    }
                    
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        NSArray *allCart = [CompanyInfo MR_findAll];
        NSMutableArray *tmp = [NSMutableArray array];
        for (CompanyInfo *cp in allCart) {
            MLOffLineShopCart *ofCart = [[MLOffLineShopCart alloc]init];
            ofCart.cpInfo = cp;
            [tmp addObject:ofCart];
        }
        self.offlineCart = nil;
        self.offlineCart = tmp;
        
        for (MLOffLineShopCart *model in self.offlineCart) {
            for (OffLlineShopCart *prolist in model.goodsArray) {
                CartNum+= prolist.num;
            }
        }
        if (CartNum >0) {
            shopCarBadge.hidden = NO;
            NSString *cartNum = [NSString stringWithFormat:@"%ld",(long)CartNum];
            shopCarBadge.badgeText = [NSString stringWithFormat:@"%@",cartNum];;
        }else{
            shopCarBadge.hidden = YES;
        }

        
    }
    
    
}

- (NSMutableArray *)offlineCart{
    if (!_offlineCart) {
        _offlineCart = [NSMutableArray array];
        
    }
    return _offlineCart;
}
@end


