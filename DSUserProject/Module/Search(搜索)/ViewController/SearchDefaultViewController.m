//
//  SearchDefaultViewController.m
//  JMBaseProject
//
//  Created by Liuny on 2019/7/2.
//  Copyright © 2019 liuny. All rights reserved.
//

#import "SearchDefaultViewController.h"
#import "SearchDefaultCell.h"
#import "TagModel.h"
#import "HXTagCollectionViewFlowLayout.h"

@interface SearchDefaultViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *hotCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *historyCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotCollectionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyCollectionConstraint;
@property (strong, nonatomic) HXTagCollectionViewFlowLayout *hotLayout;
@property (strong, nonatomic) HXTagCollectionViewFlowLayout *historyLayout;

@property (strong, nonatomic) NSMutableArray *hotArray;
@property (strong, nonatomic) NSMutableArray *historyArray;
@end

@implementation SearchDefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initControl{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.hotCollectionView.delegate = self;
    self.hotCollectionView.dataSource = self;
    self.hotLayout = [[HXTagCollectionViewFlowLayout alloc] init];
    JMWeak(self);
    self.hotLayout.completeLayout = ^(CGFloat contentHeight) {
        weakself.hotCollectionHeightConstraint.constant = contentHeight;
    };
    self.hotCollectionView.collectionViewLayout = self.hotLayout;
    
    self.historyCollectionView.delegate = self;
    self.historyCollectionView.dataSource = self;
    self.historyLayout = [[HXTagCollectionViewFlowLayout alloc] init];
    self.historyLayout.completeLayout = ^(CGFloat contentHeight) {
        weakself.historyCollectionConstraint.constant = contentHeight;
    };
    self.historyCollectionView.collectionViewLayout = self.historyLayout;
}

-(void)initData{
    [self requestHotList];
    [self readSearchHistory];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSearchHistory:) name:@"StartSearch" object:nil];
}

-(void)refreshSearchHistory:(NSNotification *)note{
    NSString *searchKey = note.object;
    [self saveSearchHistory:searchKey];
}

-(void)readSearchHistory{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"SearchHistory"];
    self.historyArray = [array mutableCopy];
    [self.historyCollectionView reloadData];
    if(self.historyArray == nil){
        self.historyArray = [[NSMutableArray alloc] init];
    }
}

-(void)saveSearchHistory:(NSString *)searchKey{
    if([self.historyArray containsObject:searchKey]){
        //移到最近搜索位置
        [self.historyArray removeObject:searchKey];
        [self.historyArray insertObject:searchKey atIndex:0];
        
    }else{
        if(self.historyArray.count >= 15){
            //最多显示15个
            [self.historyArray removeLastObject];
        }
        [self.historyArray insertObject:searchKey atIndex:0];
    }
    
    [self.historyCollectionView reloadData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.historyArray forKey:@"SearchHistory"];
    [defaults synchronize];
}

-(void)clearSearchHistory{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"SearchHistory"];
    self.historyArray = nil;
    [self.historyCollectionView reloadData];
}


#pragma mark - UICollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger rtn = 0;
    if(collectionView == self.historyCollectionView){
        rtn = self.historyArray.count;
    }else if(collectionView == self.hotCollectionView){
        rtn = self.hotArray.count;
    }
    return rtn;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchDefaultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchDefaultCell" forIndexPath:indexPath];
    NSString *content = @"";
    if(collectionView == self.historyCollectionView){
        content = self.historyArray[indexPath.row];
    }else if(collectionView == self.hotCollectionView){
        content = self.hotArray[indexPath.row];
    }
    [cell updateContent:content];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *content = @"";
    if(collectionView == self.historyCollectionView){
        content = self.historyArray[indexPath.row];
    }else if(collectionView == self.hotCollectionView){
        content = self.hotArray[indexPath.row];
    }
    UIFont *font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    //没有考虑多行（单行）
    CGFloat width = [content widthForFont:font];
    //向上取整，解决图片边框拉伸问题
    return CGSizeMake(ceilf(width)+13*2, 30);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //单选
    NSString *content = @"";
    if(collectionView == self.historyCollectionView){
        content = self.historyArray[indexPath.row];
    }else if(collectionView == self.hotCollectionView){
        content = self.hotArray[indexPath.row];
    }
    if(self.selectBlock){
        self.selectBlock(content);
    }
}

#pragma mark - Actions
- (IBAction)deleteHistoryAction:(id)sender {
    [self clearSearchHistory];
}

#pragma mark - 网络
-(void)requestHotList{
    NSMutableDictionary *params = [JMCommonMethod baseRequestParams];
    [[JMRequestManager sharedManager] POST:kUrlHotSearchList parameters:params completion:^(JMBaseResponse *response) {
        if(response.error){
            [JMProgressHelper toastInWindowWithMessage:response.errorMsg];
        }else{
            NSArray *dataArray = response.responseObject[@"data"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for(NSDictionary *dic in dataArray){
                [array addObject:[dic getJsonValue:@"name"]];
            }
            self.hotArray = array;
            [self.hotCollectionView reloadData];
        }
    }];
}
@end
