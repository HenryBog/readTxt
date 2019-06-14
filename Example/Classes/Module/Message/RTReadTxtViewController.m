//
//  RTReadTxtViewController.m
//  CYLTabBarController
//
//  Created by Henry on 2019/5/9.
//  Copyright © 2019年 微博@iOS程序犭袁. All rights reserved.
//

#import "RTReadTxtViewController.h"
#import "LSYReadViewController.h"
#import "LSYChapterModel.h"
#import "LSYMenuView.h"
#import "LSYCatalogViewController.h"
#import "UIImage+ImageEffects.h"
#import "LSYNoteModel.h"
#import "LSYMarkModel.h"
#import <objc/runtime.h>
#import "NSString+HTML.h"
#import "NSArray+YYAdd.h"
#define AnimationDelay 0.3

@interface RTReadTxtViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,LSYMenuViewDelegate,UIGestureRecognizerDelegate,LSYCatalogViewControllerDelegate,LSYReadViewControllerDelegate>
@property (nonatomic, assign) NSUInteger chapter;           //当前显示的章节
@property (nonatomic, assign) NSUInteger page;              //当前显示的页数
@property (nonatomic, assign) NSUInteger chapterChange;    //将要变化的章节
@property (nonatomic, assign) NSUInteger pageChange;        //将要变化的页数
@property (nonatomic, assign) BOOL isTransition;            //是否开始翻页


@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,getter=isShowBar) BOOL showBar; //是否显示状态栏
@property (nonatomic,strong) LSYMenuView *menuView; //菜单栏
@property (nonatomic,strong) LSYCatalogViewController *catalogVC;   //侧边栏
@property (nonatomic,strong) UIView * catalogView;  //侧边栏背景
@property (nonatomic,strong) LSYReadViewController *readView;   //当前阅读视图
@end

@implementation RTReadTxtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.pageViewController];
    [_pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:_model.record.page]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    _chapter = _model.record.chapter;
    _page = _model.record.page;
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolMenu)];
        tap.delegate = self;
        tap;
    })];
    //上部分与下部分 操作视图
    [self.view addSubview:self.menuView];
    //列表视图   目录 笔记
    [self addChildViewController:self.catalogVC];
    //侧边栏背景
    [self.view addSubview:self.catalogView];
    //侧边栏加列表视图
    [self.catalogView addSubview:self.catalogVC.view];
    //添加笔记
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotes:) name:LSYNoteNotification object:nil];
    
}

-(void)addNotes:(NSNotification *)no
{
    LSYNoteModel *model = no.object;
    model.recordModel = [_model.record copy];
    [[_model mutableArrayValueForKey:@"notes"] addObject:model];    //这样写才能KVO数组变化
    [LSYReadUtilites showAlertTitle:nil content:@"保存笔记成功"];
}

-(BOOL)prefersStatusBarHidden
{
    return !_showBar;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)showToolMenu
{
    [_readView.readView cancelSelected];
    NSString * key = [NSString stringWithFormat:@"%d_%d",(int)_model.record.chapter,(int)_model.record.page];
    
    id state = _model.marksRecord[key];
    state?(_menuView.topView.state=1): (_menuView.topView.state=0);
    [self.menuView showAnimation:YES];
    
}

#pragma mark - init
-(LSYMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[LSYMenuView alloc] initWithFrame:self.view.frame];
        _menuView.hidden = YES;
        _menuView.delegate = self;
        _menuView.recordModel = _model.record;
    }
    return _menuView;
}
-(UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}
-(LSYCatalogViewController *)catalogVC
{
    if (!_catalogVC) {
        _catalogVC = [[LSYCatalogViewController alloc] init];
        _catalogVC.readModel = _model;
        _catalogVC.catalogDelegate = self;
    }
    return _catalogVC;
}
-(UIView *)catalogView
{
    if (!_catalogView) {
        _catalogView = [[UIView alloc] initWithFrame:CGRectMake(-ViewSize(self.view).width, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height)];
        _catalogView.backgroundColor = [UIColor clearColor];
        _catalogView.hidden = YES;
        [_catalogView addGestureRecognizer:({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCatalog)];
            tap.delegate = self;
            tap;
        })];
    }
    return _catalogView;
}
#pragma mark - CatalogViewController Delegate
-(void)catalog:(LSYCatalogViewController *)catalog didSelectChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    [_pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    [self updateReadModelWithChapter:chapter page:page];
    [self hiddenCatalog];
    
}
#pragma mark -  UIGestureRecognizer Delegate
//解决TabView与Tap手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
#pragma mark - Privite Method
-(void)catalogShowState:(BOOL)show
{
    show?({
        _catalogView.hidden = !show;
        [UIView animateWithDuration:AnimationDelay animations:^{
            _catalogView.frame = CGRectMake(0, 0,2*ViewSize(self.view).width, ViewSize(self.view).height);
            
        } completion:^(BOOL finished) {
            [_catalogView insertSubview:[[UIImageView alloc] initWithImage:[self blurredSnapshot]] atIndex:0];
        }];
    }):({
        if ([_catalogView.subviews.firstObject isKindOfClass:[UIImageView class]]) {
            [_catalogView.subviews.firstObject removeFromSuperview];
        }
        [UIView animateWithDuration:AnimationDelay animations:^{
            _catalogView.frame = CGRectMake(-ViewSize(self.view).width, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height);
        } completion:^(BOOL finished) {
            _catalogView.hidden = !show;
            
        }];
    });
}
-(void)hiddenCatalog
{
    [self catalogShowState:NO];
}
- (UIImage *)blurredSnapshot {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), NO, 1.0f);
    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    UIGraphicsEndImageContext();
    return blurredSnapshotImage;
}
#pragma mark - Menu View Delegate
-(void)menuViewDidHidden:(LSYMenuView *)menu
{
    _showBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)menuViewDidAppear:(LSYMenuView *)menu
{
    _showBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
}
-(void)menuViewInvokeCatalog:(LSYBottomMenuView *)bottomMenu
{
    [_menuView hiddenAnimation:NO];
    [self catalogShowState:YES];
    
}

-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    [_pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    [self updateReadModelWithChapter:chapter page:page];
}
-(void)menuViewFontSize:(LSYBottomMenuView *)bottomMenu
{
    
    [_model.record.chapterModel updateFont];
    [_pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:(_model.record.page>_model.record.chapterModel.pageCount-1)?_model.record.chapterModel.pageCount-1:_model.record.page]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    [self updateReadModelWithChapter:_model.record.chapter page:(_model.record.page>_model.record.chapterModel.pageCount-1)?_model.record.chapterModel.pageCount-1:_model.record.page];
}

-(void)menuViewMark:(LSYTopMenuView *)topMenu
{
    
    
    NSString * key = [NSString stringWithFormat:@"%d_%d",(int)_model.record.chapter,(int)_model.record.page];
    id state = _model.marksRecord[key];
    if (state) {
        //如果存在移除书签信息
        [_model.marksRecord removeObjectForKey:key];
        [[_model mutableArrayValueForKey:@"marks"] removeObject:state];
    }
    else{
        //记录书签信息
        LSYMarkModel *model = [[LSYMarkModel alloc] init];
        model.date = [NSDate date];
        model.recordModel = [_model.record copy];
        [[_model mutableArrayValueForKey:@"marks"] addObject:model];
        [_model.marksRecord setObject:model forKey:key];
    }
    _menuView.topView.state = !state;
    
    
}
#pragma mark - Create Read View Controller

-(LSYReadViewController *)readViewWithChapter:(NSUInteger)chapter page:(NSUInteger)page{
    if (_model.record.chapter != chapter) {
        [_model.record.chapterModel updateFont];
    }
    _readView = [[LSYReadViewController alloc] init];
    _readView.recordModel = _model.record;
    _readView.type = ReaderTxt;
    LSYChapterModel *model = [_model.chapters objectOrNilAtIndex:chapter];
    if (model && model.pageCount > page) {
        NSString *content = [model stringOfPage:page];
        NSString *str = [NSString stringWithFormat:@"_pageChange:%lu \n _page:%lu \n model.pageCount:%lu \n  content:%@", _pageChange,_page,model.pageCount,[content substringToIndex:100]];
        _readView.content = content;
    } else {
        _readView.content = _model.content;
    }
    _readView.delegate = self;
    NSLog(@"_readGreate");
    return _readView;
}
#pragma mark - Read View Controller Delegate
-(void)readViewEndEdit:(LSYReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = YES;
            break;
        }
    }
}
-(void)readViewEditeding:(LSYReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = NO;
            break;
        }
    }
}
#pragma mark -PageViewController DataSource
//前一个页面
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    _pageChange = _page;
    _chapterChange = _chapter;
    //如果到头部
    if (_chapterChange == 0 &&_pageChange == 0) {
        return nil;
    }
    if (_pageChange == 0) {
        _chapterChange--;
        LSYChapterModel *model = [_model.chapters objectOrNilAtIndex:_chapterChange];
        if (model) {
            _pageChange = _model.chapters[_chapterChange].pageCount - 1;
        } else {
            //可能有潜在崩溃风险   要确定选择上章内容不会为空。
            _pageChange = 0;
        }
    } else {
        _pageChange--;
    }
    return [self readViewWithChapter:_chapterChange page:_pageChange];
    
}
//后一个页面
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    //已经到底
    if (_pageChange == _model.chapters.lastObject.pageCount - 1 && _chapterChange == _model.chapters.count - 1) {
        return nil;
    }
    LSYReadViewController *pageVC = (LSYReadViewController *)viewController;
    NSUInteger page = pageVC.recordModel.page;
    NSUInteger chapter = pageVC.recordModel.chapter;
    //当前章节有内容  当前处于章节最后一页
    if ( page >= _model.chapters[_chapterChange].pageCount - 1) {
        chapter++;
        page = 0;
    } else {
        //还没有在章节最后一页
        page++;
    }
    return [self readViewWithChapter:chapter page:page];
}
#pragma mark -PageViewController Delegate
//这个方法是在UIPageViewController结束滚动或翻页的时候触发
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        LSYReadViewController *readView = previousViewControllers.firstObject;
        if (readView && ![self.readView.content isEqualToString:readView.content]) {
            [self pageChangeSetting];
        }
        [self updateReadModelWithChapter:_chapterChange page:_pageChange];
        
    }
}

- (void)pageChangeSetting {
    NSString *content = self.readView.content;
    for (NSInteger i = 0; i < self.readView.recordModel.chapterModel.pageCount; i++) {
        if ([content isEqualToString:[self.readView.recordModel.chapterModel stringOfPage:i]]) {
            _pageChange = i;
        } else {
            continue;
        }
    }
}

- (void)setPage:(NSUInteger)page {
    _page = page;
}

- (void)updateReadModelWithChapter:(NSUInteger)chapter page:(NSUInteger)page {
    _chapter = chapter;
    _page = page;
    _model.record.chapterModel = _model.chapters[chapter];
    _model.record.chapter = chapter;
    _model.record.page = page;
//    [LSYReadModel updateLocalModel:_model url:_resourceURL];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _pageViewController.view.frame = self.view.frame;
    _catalogVC.view.frame = CGRectMake(0, 0, ViewSize(self.view).width-100, ViewSize(self.view).height);
    [_catalogVC reload];
}

@end
