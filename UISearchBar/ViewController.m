//
//  ViewController.m
//  UISearchBar
//
//  Created by 李蛋伯 on 2016/8/17.
//  Copyright © 2016年 李蛋伯. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"

@interface ViewController ()<UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>

//下拉上推标记
@property (assign, nonatomic) NSInteger switchTip;
//表视图全局对象
@property (strong, nonatomic) UITableView *tableView;
//搜索栏控制器
@property (strong, nonatomic) UISearchController *searchController;
//全部球队信息
@property (strong, nonatomic) NSArray *listTeams;
//查询之后的球队信息，为可变数组类型，是listTeams的子集
@property (strong, nonatomic) NSMutableArray *listFilterTeams;
//一个内容过滤方法。参数searchText：过滤结果的条件。scope：搜索范围栏中选择按钮的索引。本例中有两个按钮，将它们的值分别设置为0、1.
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSUInteger)scope;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UISearchBarTable";
    
    _searchController.searchBar.frame = CGRectMake(0, -44, self.view.frame.size.width, 44);
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //将数据导入集合数组listTeams
    _listTeams = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"team" ofType:@"plist"]];
    
    //实例化表视图对象
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    
    //表视图数据对象设为self（也就是ViewController）
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    //初次进入查询所有数据
    [self filterContentForSearchText:@"" scope:-1];
    
    //实例化搜索栏控制器UISearchController
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    
    //self（即ViewController）为更新搜索结果对象
    _searchController.searchResultsUpdater = self;
    
    //搜索时的背景颜色
    _searchController.dimsBackgroundDuringPresentation = false;
    
    //设置self为按钮委托对象
    _searchController.searchBar.delegate = self;
    
    //表视图表头设为搜索栏
    _tableView.tableHeaderView = _searchController.searchBar;
    
    //搜索栏中输入字体大小自适应
    [_searchController.searchBar sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 搜索栏内容过滤方法
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSUInteger)scope{
    
    if ([searchText length] == 0) {
        //查询所有
        _listFilterTeams = [NSMutableArray arrayWithArray:_listTeams];
        
        return;
    }
    
    //NSPredicate是谓词，可以定义一个查询条件，用来在内存中过滤集合对象。
    NSPredicate *scopePredicate;
    NSArray *tempArray;
    
    //NSPredicate构造器中format参数设置Predicate字符串格式。本例中的 @"SELF.image contains[c] %@" 是Predicate字符串，类似SQL语句或是HQL语句，其中SELF代表要查询的对象，SELF.image是查询对象的image字段（字典对象的键或实体对象的属性），contains[c]是包含字符的意思，其中小写c表示不区分大小写。
    switch (scope) {
        
        //中文，name字段是中文名
        case 0:
            //进行中文查询（匹配字典中name键）
            scopePredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
            // - filteredArrayUsingPredicate: 方法是按照之前的条件进行过滤，结果返回的还是NSArray对象
            tempArray = [_listTeams filteredArrayUsingPredicate:scopePredicate];
            //需要重新构造一个NSMutableArray对象，才能将结果放到属性listFilterTeams中
            _listFilterTeams = [NSMutableArray arrayWithArray:tempArray];
            
            break;
        
        //英文，image字段保存英文名
        case 1:
            scopePredicate = [NSPredicate predicateWithFormat:@"SELF.image contains[c] %@",searchText];
            tempArray = [_listTeams filteredArrayUsingPredicate:scopePredicate];
            _listFilterTeams = [NSMutableArray arrayWithArray:tempArray];
            
            break;
            
        default:
            //查询所有
            _listFilterTeams = [NSMutableArray arrayWithArray:_listTeams];
            
            break;
    }
}

#pragma mark --- 实现代理UISearchBarDelegate协议方法
//点击搜索范围栏时调用该方法
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    
    [self updateSearchResultsForSearchController:_searchController];
}

#pragma mark --- 实现UISearchResultsUpdating协议方法
//当搜索栏成为第一响应者，并且内容被改变时调用该方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    NSString *searchString = searchController.searchBar.text;
    
    //查询
    [self filterContentForSearchText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    //重新搜索完成后，一定要重新加载表视图
    [self.tableView reloadData];
    
}

#pragma mark --- 实现数据源UITableViewDataSource协议方法
//返回表视图中某节的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //返回搜索过滤后的集合数组行数
    return [_listFilterTeams count];
}

//为单元格提供数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //设置可重用标识符，并获得可重用单元格对象
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == 0) {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    
    //将搜索过滤后的数据传入
    NSDictionary *rowDict = _listFilterTeams[[indexPath row]];
    //Title文本
    cell.textLabel.text = rowDict[@"name"];
    //subTitle文本
    cell.detailTextLabel.text = rowDict[@"image"];
    //图片数据
    cell.imageView.image = [UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@.png",rowDict[@"image"]]];
    //设置单元格样式
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //返回单元格
    return cell;
}

#pragma mark -- 下拉弹出 上推隐藏，通过UIscrollView的方法进行监听
//下拉操作
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (_searchController.searchBar.text.length == 0 && _searchController.searchBar.frame.origin.y >= 0) {
        
        _searchController.searchBar.frame = CGRectMake(0, -44, self.view.frame.size.width, 44);
        
        _switchTip = 0;
    }
}

//上推操作
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_switchTip == 0){
        
        if (scrollView.contentOffset.y <= -44){
            
            [UIView animateWithDuration:0.3 animations:^{
                _searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
                _tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
            }];
            
            [self performSelector:@selector(closeSearch) withObject:nil afterDelay:2];
            
            _switchTip = 1;
        }
    }
}

//隐藏操作
- (void)closeSearch{
    
    if (![self.searchController.searchBar isFirstResponder] && self.searchController.searchBar.text.length == 0){
        
        [UIView animateWithDuration:0.3 animations:^{
            _searchController.searchBar.frame = CGRectMake(0, -44, self.view.frame.size.width, 44);
            _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }];
    }
    _switchTip = 0;
}




@end
