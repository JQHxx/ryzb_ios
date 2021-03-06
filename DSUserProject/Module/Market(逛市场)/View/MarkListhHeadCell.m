//
//  MarkListhHeadCell.m
//  JMBaseProject
//
//  Created by 潘传标 on 2019/9/3.
//  Copyright © 2019 liuny. All rights reserved.
//

#import "MarkListhHeadCell.h"
#import "BannerModel.h"
#import "SDCycleScrollView.h"
#import "LiveRoomModel.h"
#import "TagModel.h"
#import "LiveAttentionCell.h"
#import "HomeTypeViewController.h"
#import "GoodDetailViewController.h"
@interface MarkListhHeadCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *cycleScrollView;

@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *bannerData;
@property(nonatomic,strong) SDCycleScrollView *cycleImageView;
@property (strong, nonatomic) NSMutableArray *collectionData;
@property (strong, nonatomic) NSMutableArray *typesArray;
@property (strong, nonatomic) UIButton *typeSelectButton;
@property (strong, nonatomic) HomeTypeViewController *homeTypeVC;
@end
#define TagOffset   5
@implementation MarkListhHeadCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initContro];
    [self initData];
}


-(void)initContro
{
    //轮播图
    SDCycleScrollView *cycleImageView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"home_ban"]];
    cycleImageView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleImageView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycleImageView.pageDotImage = [UIImage imageNamed:@"home_ban_unsel"];
    cycleImageView.currentPageDotImage = [UIImage imageNamed:@"home_ban_sel"];
    self.cycleImageView = cycleImageView;
    [self.cycleScrollView addSubview:cycleImageView];
    [self.cycleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.cycleScrollView);
    }];
    
    self.cycleImageView.layer.cornerRadius = 7.0;
    self.cycleImageView.layer.masksToBounds = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //轮播图点击
    if(index < self.bannerData.count){
        BannerModel *model = self.bannerData[index];
        if (model.type.integerValue == 1) {
            GoodDetailViewController *detailVC = [[GoodDetailViewController alloc] initWithStoryboardName:@"GoodDetail"];
            detailVC.goodId = model.ids;
            [[UIWindow jm_currentViewController].navigationController pushViewController:detailVC animated:YES];
        }else if(model.type.integerValue == 2)
        {
            if(model.goUrl.length == 0){
                return;
            }
            NSURL *url = [ [ NSURL alloc ] initWithString:model.goUrl];
            [[UIApplication sharedApplication] openURL:url];
        }
        
        
    }
}
-(void)initData
{
    [self requestBanner];
    [self requestTypeList];
    [self requestAttentionList];
    
    
}

#pragma mark - UICollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger rtn = MIN(self.collectionData.count, 4);
    return rtn;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LiveAttentionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveAttentionCell" forIndexPath:indexPath];
    cell.cellData = self.collectionData[indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize rtn = CGSizeZero;
    if (self.collectionView == collectionView) {
        rtn.width = kScreenWidth/4.0;
        rtn.height = kScreenWidth/4.0;
    }else
    {
        rtn.width = (kScreenWidth - 37) * 0.5;
        rtn.height =  270;
    }
    
    return rtn;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LiveRoomModel *model = self.collectionData[indexPath.row];
    if (self.showMyAttenionBlock) {
        self.showMyAttenionBlock(model);
    }

}

#pragma mark - Actions
- (IBAction)attentionMoreAction:(id)sender {
    if (self.showAllAttentionBlock) {
        self.showAllAttentionBlock();
    }
}
- (IBAction)showAllTypeAction:(id)sender {
    [self.superview.superview addSubview:self.homeTypeVC.view];
    self.homeTypeVC.typesArray = self.typesArray;
    [self.homeTypeVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview);
    }];
}




-(void)initTypes{
    UIView *leftItem;
    for(int i=0;i<self.typesArray.count;i++){
        UIButton *button = [self typeButton];
        button.tag = i+TagOffset;
        TagModel *model = self.typesArray[i];
        [button setTitle:model.tagText forState:UIControlStateNormal];
        [self.typeView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.typeView);
            if(leftItem){
                make.left.equalTo(leftItem.mas_right).offset(15.0);
            }else{
                make.left.equalTo(self.typeView.mas_left);
            }
        }];
        if(model.isSelect == YES){
            button.selected = YES;
            self.typeSelectButton = button;
        }
        leftItem = button;
        [self.typeView layoutIfNeeded];
        if(button.mj_x+button.mj_w > self.typeView.mj_w){
            [button removeFromSuperview];
            break;
        }
    }
}


-(UIButton *)typeButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular];
    [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:@"home_a03"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"add_a01"] forState:UIControlStateSelected];
    [button setContentEdgeInsets:UIEdgeInsetsMake(5, 13, 5, 13)];
    [button addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}



-(void)typeAction:(UIButton *)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag - TagOffset;
    [self updateSelectType:index];
}
-(void)requestTypeList{
    NSMutableDictionary *params = [JMCommonMethod baseRequestParams];
    [params setJsonValue:@"5" key:@"type"];
    [[JMRequestManager sharedManager] POST:kUrlTypeList parameters:params completion:^(JMBaseResponse *response) {
        if(response.error){
            [JMProgressHelper toastInWindowWithMessage:response.errorMsg];
        }else{
            NSArray *dataList = response.responseObject[@"data"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for(NSDictionary *dic in dataList){
                TagModel *model = [[TagModel alloc] initWithDictionary:dic];
                [array addObject:model];
            }
            self.typesArray = array;
            TagModel *firstItem = self.typesArray.firstObject;
            firstItem.isSelect = YES;
            [self initTypes];
            if (self.selectTypeBlock) {
                self.selectTypeBlock(firstItem.tagId);
            }
        }
    }];
}

-(void)requestBanner{
    NSMutableDictionary *params = [JMCommonMethod baseRequestParams];
    [params setJsonValue:@"4" key:@"type"];
    [[JMRequestManager sharedManager] POST:kUrlBanner parameters:params completion:^(JMBaseResponse *response) {
        if(response.error){
            [JMProgressHelper toastInWindowWithMessage:response.errorMsg];
        }else{
            NSArray *dataArray = response.responseObject[@"data"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSMutableArray *imageArray = [[NSMutableArray alloc] init];
            for(NSDictionary *dic in dataArray){
                BannerModel *model = [[BannerModel alloc] initWithDictionary:dic];
                [array addObject:model];
                [imageArray addObject:model.imageUrl];
            }
            self.cycleImageView.imageURLStringsGroup = imageArray;
            self.bannerData = array;
        }
    }];
}


-(void)requestAttentionList{
    NSMutableDictionary *params = [JMCommonMethod baseRequestParams];
    [params setJsonValue:@"4" key:@"pageSize"];
    [params setJsonValue:@"1" key:@"pageNumber"];
    [[JMRequestManager sharedManager] POST:kUrlLiveAttentionList parameters:params completion:^(JMBaseResponse *response) {
        if(response.error){
            [JMProgressHelper toastInWindowWithMessage:response.errorMsg];
        }else{
            NSDictionary *dataDic = response.responseObject[@"data"];
            NSArray *listArray = dataDic[@"list"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for(NSDictionary *dic in listArray){
                LiveRoomModel *model = [[LiveRoomModel alloc] initWithDictionary:dic];
                [array addObject:model];
            }
            self.collectionData = array;
            [self.collectionView reloadData];
        }
    }];
}


-(void)updateSelectType:(NSInteger)index{
    if(self.typeSelectButton){
        self.typeSelectButton.selected = NO;
        TagModel *model = self.typesArray[self.typeSelectButton.tag-TagOffset];
        model.isSelect = NO;
    }
    NSInteger tag = index+TagOffset;
    UIButton *newButton = (UIButton *)[self.typeView viewWithTag:tag];
    self.typeSelectButton = newButton;
    self.typeSelectButton.selected = YES;
    TagModel *newSelect = self.typesArray[index];
    newSelect.isSelect = YES;
    
    //刷新数据
    if (self.selectTypeBlock) {
        self.selectTypeBlock(newSelect.tagId);
    }
}

-(HomeTypeViewController *)homeTypeVC{
    if(_homeTypeVC == nil){
        _homeTypeVC = [[HomeTypeViewController alloc] initWithStoryboardName:@"Market"];
        JMWeak(self);
        _homeTypeVC.selectBlock = ^(NSInteger index) {
            [weakself updateSelectType:index];
        };
    }
    return _homeTypeVC;
}

-(void)reloadAttionList
{
    [self requestAttentionList];
}
@end
