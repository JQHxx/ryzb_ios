//
//  GroupChildrenViewController.m
//  JMBaseProject
//
//  Created by Liuny on 2019/1/3.
//  Copyright © 2019 liuny. All rights reserved.
//

#import "GroupLevelTwoViewController.h"
#import "GroupChildrenCell.h"
#import "GroupChildrenViewController.h"

@interface GroupLevelTwoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *collectionData;
@end

@implementation GroupLevelTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)changeParentGroup:(NSString *)groupId{
    [self requestLevelTwoList:groupId];
}

-(void)initControl{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

-(void)initData{

}

#pragma mark - UICollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GroupChildrenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupChildrenCell" forIndexPath:indexPath];
    cell.cellData = self.collectionData[indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //宽度 = 屏幕宽度 - 左边table宽度 - collection的section左右边距
    CGFloat width = (kScreenWidth - 100.0 - 10*2)/3.0;
    return CGSizeMake(width, width + 30);
}

// 两个item之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self goChildrenVC:indexPath.row];
}

#pragma mark - 跳转
-(void)goChildrenVC:(NSInteger)index{
    GroupChildrenViewController *childrenVC = [[GroupChildrenViewController alloc] initWithStoryboardName:@"GoodType"];
    GroupModel *model = self.collectionData[index];
    childrenVC.typeId = model.groupId;
    [self.navigationController pushViewController:childrenVC animated:YES];
}

#pragma mark - 网络
-(void)requestLevelTwoList:(NSString *)groupId{
    //二级分类
    NSMutableDictionary *params = [JMCommonMethod baseRequestParams];
    [params setJsonValue:groupId key:@"parentId"];
    [[JMRequestManager sharedManager] POST:kUrlTypeLevelOne parameters:params completion:^(JMBaseResponse *response) {
        if(response.error){
            [JMProgressHelper toastInWindowWithMessage:response.errorMsg];
        }else{
            NSArray *dataArray = response.responseObject[@"data"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for(NSDictionary *dic in dataArray){
                GroupModel *group = [[GroupModel alloc] initWithDictionary:dic];
                [array addObject:group];
            }
            self.collectionData = array;
            [self.collectionView reloadData];
        }
    }];
}
@end
