//
//  MLReturnsRecordViewController.m
//  Matro
//
//  Created by MR.Huang on 16/6/21.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLReturnsRecordViewController.h"
#import "MLAfterSaleProductCell.h"
#import "MLRetrunsHeadCell.h"
#import "MJRefresh.h"
#import "UIView+BlankPage.h"
#import "Masonry.h"
#import "MLReturnsHeader.h"
#import "MLOrderCenterTableViewCell.h"
#import "MLTuiHuoModel.h"
#import "MJExtension.h"
#import "HFSServiceClient.h"
#import "MLOrderInfoHeaderTableViewCell.h"
#import "MLReturnRequestViewController.h"
#import "MBProgressHUD+Add.h"
#import "HFSUtility.h"
#import <CommonCrypto/CommonDigest.h>
#import "MLMoreTableViewCell.h"
#import "MLAfterSaleHeadCell.h"
#import "MLReturnsDetailViewController.h"
#import "HFSConstants.h"
#import "MLHttpManager.h"
#import "HFSConstants.h"
#import "UMMobClick/MobClick.h"
#import "MLGoodsDetailsViewController.h"
#import "MLLoginViewController.h"
#import "MLTuihuojilvFooterView.h"
#import "CommonHeader.h"
@interface MLReturnsRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *orderList;


@end

static NSInteger pageIndex = 1;

@implementation MLReturnsRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(245, 245, 245, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = RGBA(245, 245, 245, 1);
        [tableView registerNib:[UINib nibWithNibName:@"MLAfterSaleHeadCell" bundle:nil] forCellReuseIdentifier:kMLAfterSaleHeadCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLAfterSaleProductCell" bundle:nil] forCellReuseIdentifier:kMLAfterSaleProductCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderCenterTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderCenterTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLOrderInfoHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderInfoHeaderTableViewCell];
        [tableView registerNib:[UINib nibWithNibName:@"MLMoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoreCell"];
        
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.mas_equalTo(self.view);
    }];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 1 ;
        [self getOrderDataSource];
    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getOrderDataSource];
    }];
//    [self.view configBlankPage:EaseBlankPageTypeTuihuo hasData:(self.orderList.count>0)];
    pageIndex = 1 ;
    [self getOrderDataSource];

    
    
    // Do any additional setup after loading the view.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MLTuiHuoModel *model = [self.orderList objectAtIndex:section];
    
    if (model.isMore && !model.isOpen) { //有更多 未展开
        return 5;
    }
    return model.products.count+2;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MLTuiHuoModel *model = [self.orderList objectAtIndex:indexPath.section];
    __weak typeof(self) weakself = self;
    if (indexPath.row == 0 ) {
        MLAfterSaleHeadCell *cell =[tableView dequeueReusableCellWithIdentifier:kMLAfterSaleHeadCell forIndexPath:indexPath];
        cell.callBlock = ^(){
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"打电话给客服？" message:KeFuDianHua preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                tel(KeFuDianHua);
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:doneAction];
            [alertVc addAction:cancel];
            [weakself presentViewController:alertVc animated:YES completion:nil];
        };
        cell.tuiHuoModel = model;
        return cell;
    }else if (indexPath.row==1){
        MLOrderInfoHeaderTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:kOrderInfoHeaderTableViewCell forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.shopName.text = model.company;
        cell.statusLabel.hidden = YES;
        return cell;
    }
    if (model.isMore && !model.isOpen && indexPath.row == 4) {//有更多 未展开 最后一行
        MLMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
        cell.moreActionBlock = ^(){
            model.isOpen = YES;
            [weakself.tableView reloadData];
        };
        [cell.moreButton setTitle:[NSString stringWithFormat:@"还有%li件",model.products.count-2] forState:UIControlStateNormal];
        return cell;
    }
    MLOrderCenterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kOrderCenterTableViewCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.shouhouBtn.hidden = YES;
    cell.countNum.hidden = YES;
    cell.tuiHuoProduct = [model.products objectAtIndex:indexPath.row - 2];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLTuiHuoModel *model = [self.orderList objectAtIndex:indexPath.section];
    if (indexPath.row == 0 ) {
        MLReturnsDetailViewController *vc = [[MLReturnsDetailViewController alloc]init];
        vc.order_id = model.order_id;
        vc.pro_id = model.pro_id;
        NSLog(@"vc.order_id===%@ vc.pro_id===%@",vc.order_id,vc.pro_id);
        vc.cancelSuccess = ^(){
            [self.tableView.header beginRefreshing];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row > 1 && !(model.isMore && !model.isOpen && indexPath.row == 4)) {
        MLTuiHuoProductModel *product = [model.products objectAtIndex:indexPath.row - 2];
        MLGoodsDetailsViewController *vc = [[MLGoodsDetailsViewController alloc]init];
        vc.paramDic = @{@"id":product.pid?:@""};
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLTuiHuoModel *model = [self.orderList objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        return 110.f;
    }
    else if (indexPath.row == 1 ||(model.isMore && !model.isOpen && indexPath.row == 4) ){
        return 40;
    }
    return 134.f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MLTuiHuoModel *model = [self.orderList objectAtIndex:section];
    if ([model.return_status_code isEqualToString:@"9"]) {
        MLTuihuojilvFooterView *footerView = [[MLTuihuojilvFooterView  alloc] initWithReuseIdentifier:@"MLTuihuojilvFooterView"];
        footerView.jiaoyiLab.text = [NSString stringWithFormat:@"￥%.2f",model.transaction_price.floatValue];
        footerView.tuihuojineLab.text = [NSString stringWithFormat:@"￥%.2f",model.return_price.floatValue];
        return footerView;
    }else{
        
        return [[UIView alloc] init];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    MLTuiHuoModel *model = [self.orderList objectAtIndex:section];
    if ([model.return_status_code isEqualToString:@"9"]) {
        return 45;
    }else{
        return 5;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, 0.5)];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

- (NSMutableArray *)orderList{
    if (!_orderList) {
        _orderList = [NSMutableArray array];
    }
    return _orderList;
}

- (void)getOrderDataSource{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=return&s=return_list&cur_page=%li&page_size=10",MATROJP_BASE_URL,pageIndex];
    [MLHttpManager get:url params:nil m:@"return" s:@"return_list" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([result[@"code"] isEqual:@0]) {
            NSDictionary *data = result[@"data"];
            if (pageIndex == 1) {
                [self.orderList removeAllObjects];
            }
            NSString *count = data[@"total"];
            if (self.orderList.count < [count integerValue]) {
                [self.orderList addObjectsFromArray:[MLTuiHuoModel mj_objectArrayWithKeyValuesArray:data[@"return_list"]]];
                pageIndex++;
                [self.tableView reloadData];
            }else{
                [MBProgressHUD showMessag:@"暂无更多数据" toView:self.view];
            }

        }else if ([result[@"code"]isEqual:@1002]){
        
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
            [self loginAction:nil];
        } else{
            NSString *str = result[@"msg"];
            [MBProgressHUD showMessag:str toView:self.view];
        }
        [self.view configBlankPage:EaseBlankPageTypeTuihuo hasData:(self.orderList.count>0)];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    
}

- (void)loginAction:(id)sender{
    MLLoginViewController *loginVc = [[MLLoginViewController alloc]init];
    loginVc.isLogin = YES;
    [self presentViewController:loginVc animated:YES completion:nil];
}

@end
