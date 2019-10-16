//
//  XXSearchVC.m
//  Novel
//
//  Created by xth on 2018/1/15.
//  Copyright © 2018年 th. All rights reserved.
//

#import "XXSearchVC.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>
#import "XXBookListVC.h"

@interface XXSearchVC () <UISearchBarDelegate, TTGTextTagCollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *tags;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) TTGTextTagCollectionView *tagsView;

@property (nonatomic, strong) NSMutableArray *colors;

@end

@implementation XXSearchVC


- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = @[].mutableCopy;
        [_tags addObjectsFromArray:@[@"圣墟",@"雪鹰领主",@"辰东",@"我吃西红柿",@"唐家三少",@"天蚕土豆",@"耳根",@"烟雨江南",@"梦入神机",@"骷髅精灵",@"完美世界",@"大主宰",@"斗破苍穹",@"斗罗大陆",@"如果蜗牛有爱情",@"极品家丁",@"择天记",@"神墓",@"遮天",@"太古神王",@"帝霸",@"校花的贴身高手",@"武动乾坤"]];
    }
    return _tags;
}


- (NSMutableArray *)colors {
    if (!_colors) {
        
        _colors = [[NSMutableArray alloc] init];
        
        NSArray *temps = @[kcolorWithRGB(146, 197, 238), kcolorWithRGB(192, 104, 208), kcolorWithRGB(245, 188, 120), kcolorWithRGB(145, 206, 213), kcolorWithRGB(103, 204, 183), kcolorWithRGB(231, 143, 143)];
        
        for (int i = 0; i < 5; i++) {
            [_colors addObjectsFromArray:temps];
        }
    }
    return _colors;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = kwhiteColor;
    [self.view addSubview:_topView];
    
    UILabel *everyLabel = [[UILabel alloc] init];
    everyLabel.font = fontSize(13);
    everyLabel.text = @"大家都在搜";
    [_topView addSubview:everyLabel];
    
    UIImageView *refreshView = [[UIImageView alloc] initWithImage:UIImageName(@"search_refresh")];
    [_topView addSubview:refreshView];
    
    UIButton *refreshButton = [UIButton newButtonTitle:@"换一批" font:fontSize(13) normarlColor:kgrayColor];
    [refreshButton addTarget:self action:@selector(configTag) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:refreshButton];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入书名或作者名";
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    
    [_topView addSubview:_searchBar];
    
    _tagsView = [[TTGTextTagCollectionView alloc] init];
    _tagsView.delegate = self;
    [self configTag];
    [_topView addSubview:_tagsView];
    
    //布局
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(_tagsView.mas_bottom).offset(AdaWidth(12.f));
    }];
    
    [everyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_top).offset(AdaWidth(16));
        make.left.mas_equalTo(_topView.mas_left).offset(AdaWidth(12.f));
    }];
    
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(everyLabel);
        make.right.mas_equalTo(_topView.mas_right).offset(-AdaWidth(12.f));
    }];
    [refreshButton setEnlargeEdgeWithTop:AdaWidth(12.f) right:AdaWidth(12.f) bottom:AdaWidth(12.f) left:20];
    
    [refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(refreshButton);
        make.right.mas_equalTo(refreshButton.mas_left).offset(-4);
    }];
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(everyLabel.mas_bottom).offset(AdaWidth(16));
        make.left.equalTo(@(AdaWidth(12)));
        make.right.equalTo(@(AdaWidth(-12)));
        make.height.mas_equalTo(AdaWidth(40));
    }];
    
    [_tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_searchBar.mas_bottom).offset(AdaWidth(20));
        make.left.mas_equalTo(_topView.mas_left).offset(AdaWidth(12.f));
        make.right.mas_equalTo(_topView.mas_right).offset(-AdaWidth(12.f));
    }];
}


- (void)configTag {
    
    TTGTextTagConfig *textConfig = [[TTGTextTagConfig alloc] init];
    textConfig.textFont = fontSize(14);
    textConfig.textColor = kwhiteColor;
    textConfig.cornerRadius = AdaWidth(5);
    textConfig.selectedCornerRadius = AdaWidth(5);
    textConfig.borderWidth = 0;
    textConfig.selectedBorderWidth = 0;
    textConfig.shadowColor = kclearColor;
    
    textConfig.extraSpace = CGSizeMake(AdaWidth(15), AdaWidth(10));
    
    _tagsView.defaultConfig = textConfig;
    
    //外边距
    _tagsView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //间距
    _tagsView.horizontalSpacing = AdaWidth(15);
    
    _tagsView.verticalSpacing = AdaHeight(10);
    
    _tagsView.alignment = TTGTagCollectionAlignmentLeft;
    _tagsView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSUInteger location = 0;
    NSUInteger length = 1;
    
    NSArray *tags = [self tagArray];
    
    //移除所有的标签
    [_tagsView removeAllTags];
    
    for (int i = 0; i < tags.count; i++) {
        
        textConfig.backgroundColor = self.colors[i];
        textConfig.selectedBackgroundColor = self.colors[i];
        
        [_tagsView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[textConfig copy]];
        location += length;
    }
}


//获取一个随机整数，范围在[from,to]，包括from，包括to
- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}


//获取要随机一个数组
- (NSArray *)tagArray {
    
    NSMutableSet *randomSet = [[NSMutableSet alloc] init];
    
    while (randomSet.count < [self getRandomNumber:3 to:10]) {
        int r = arc4random() % [self.tags count];
        [randomSet addObject:[self.tags objectAtIndex:r]];
    }
    return [randomSet allObjects];
}


#pragma mark - UISearchBarDelegate
//开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.searchBar setShowsCancelButton:YES];
        for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *cancelBtn = (UIButton *)view;
                [cancelBtn setTitleColor:UIColorHex(#4a90e2) forState:0];
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }];
}


//结束编辑
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}


//搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [_searchBar endEditing:YES];
    
    if (_searchBar.text.length > 0) {
        [self saerchWithText:_searchBar.text];
    }
}


- (void)saerchWithText:(NSString *)text {
    XXBookListVC *vc = [[XXBookListVC alloc] initWithType:kBookListType_search id:text];
    vc.navigationItem.title = text;
    [self pushViewController:vc];
}


//取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.searchBar setShowsCancelButton:NO];
        [self.searchBar endEditing:YES];
        
    }];
}


#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    [self saerchWithText:tagText];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
