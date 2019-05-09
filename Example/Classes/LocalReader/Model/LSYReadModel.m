//
//  LSYReadModel.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadModel.h"

@implementation LSYReadModel
//读取txt文件 分析
-(instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self) {
        _content = content;
        NSMutableArray *charpter = [NSMutableArray array];
        [LSYReadUtilites separateChapter:&charpter content:content];
        _chapters = charpter;
        _notes = [NSMutableArray array];
        _marks = [NSMutableArray array];
        _record = [[LSYRecordModel alloc] init];
        _record.chapterModel = charpter.firstObject;
        _record.chapterCount = _chapters.count;
        _marksRecord = [NSMutableDictionary dictionary];
        _type = ReaderTxt;
    }
    return self;
}


-(instancetype)initWithRTBookDirectoryModel:(RTBookDirectoryModel *)model
{
    self = [super init];
    if (self) {
        _content = model.bookDetailModel.content ?: @"";
        NSMutableArray *charpter = [NSMutableArray array];
        [LSYReadUtilites separateChapter:&charpter model:model];
        _chapters = charpter;
        _notes = [NSMutableArray array];
        _marks = [NSMutableArray array];
        _record = [[LSYRecordModel alloc] init];
        _record.chapter = 1;
        _record.chapterModel = [RTBookDirectoryModel modelWithBookModel:model];
        _record.chapterCount = _chapters.count;
        _marksRecord = [NSMutableDictionary dictionary];
        _type = ReaderTxt;
    }
    return self;
}

-(instancetype)initWithePub:(NSString *)ePubPath;
{
    self = [super init];
    if (self) {
        _chapters = [LSYReadUtilites ePubFileHandle:ePubPath];
        _notes = [NSMutableArray array];
        _marks = [NSMutableArray array];
        _record = [[LSYRecordModel alloc] init];
        _record.chapterModel = _chapters.firstObject;
        _record.chapterCount = _chapters.count;
        _marksRecord = [NSMutableDictionary dictionary];
        _type = ReaderEpub;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.marks forKey:@"marks"];
    [aCoder encodeObject:self.notes forKey:@"notes"];
    [aCoder encodeObject:self.chapters forKey:@"chapters"];
    [aCoder encodeObject:self.record forKey:@"record"];
    [aCoder encodeObject:self.resource forKey:@"resource"];
    [aCoder encodeObject:self.marksRecord forKey:@"marksRecord"];
    [aCoder encodeObject:@(self.type) forKey:@"type"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.marks = [aDecoder decodeObjectForKey:@"marks"];
        self.notes = [aDecoder decodeObjectForKey:@"notes"];
        self.chapters = [aDecoder decodeObjectForKey:@"chapters"];
        self.record = [aDecoder decodeObjectForKey:@"record"];
        self.resource = [aDecoder decodeObjectForKey:@"resource"];
        self.marksRecord = [aDecoder decodeObjectForKey:@"marksRecord"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
    }
    return self;
}
+(void)updateLocalModel:(LSYReadModel *)readModel url:(NSURL *)url
{
    
    NSString *key = [url.path lastPathComponent];
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:readModel forKey:key];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}
+(id)getLocalModelWithURL:(NSURL *)url rtBookDirectoryModel:(RTBookDirectoryModel *)model
{
    NSString *key = [url.path lastPathComponent];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!data) {
        if ([[key pathExtension] isEqualToString:@"txt"]) {
            LSYReadModel *readmodel1 = [[LSYReadModel alloc] initWithContent:[LSYReadUtilites encodeWithURL:url]];
            readmodel1.resource = url;
            [LSYReadModel updateLocalModel:readmodel1 url:url];
            return readmodel1;
        }
        else if ([[key pathExtension] isEqualToString:@"epub"]){
            NSLog(@"this is epub");
            LSYReadModel *readmodel1 = [[LSYReadModel alloc] initWithePub:url.path];
            readmodel1.resource = url;
            [LSYReadModel updateLocalModel:readmodel1 url:url];
            return readmodel1;
        }
        else if ([[key pathExtension] isEqualToString:@"plist"]){
            LSYReadModel *readmodel1 = [[LSYReadModel alloc] initWithRTBookDirectoryModel:model];
            readmodel1.resource = url;
            [LSYReadModel updateLocalModel:readmodel1 url:url];
            return readmodel1;
        } else {
            @throw [NSException exceptionWithName:@"FileException" reason:@"文件格式错误" userInfo:nil];
        }
        
    }
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    //主线程操作
    LSYReadModel *readModel = [unarchive decodeObjectForKey:key];
    return readModel;
}
@end
