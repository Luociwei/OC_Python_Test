//
//  LeftFileVC.m
//  TestPlanEditor
//
//  Created by ciwei luo on 2020/3/3.
//  Copyright © 2020 macdev. All rights reserved.
//

#import "LeftFileVC.h"
//#import "OutlineView.h"
#import <CWGeneralManager/NSString+Extension.h>
#import <CWGeneralManager/CWFileManager.h>
@interface TreeNodeModel : NSObject

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *path;
@property(nonatomic,strong)NSMutableArray *childNodes;

@end

@implementation TreeNodeModel

- (NSMutableArray*)childNodes
{
    if(!_childNodes){
        _childNodes = [NSMutableArray array];
    }
    
    return _childNodes;
}

@end




//static NSString *const subScriptFilePath = @"/Users/gdlocal/Suncode_FCT/profile/subScript/";

@interface LeftFileVC ()
@property (nonatomic,strong)  TreeNodeModel *treeModel;
@property (weak) IBOutlet OutlineView *treeView;

@end

@implementation LeftFileVC{
    NSString *scriptFilePath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    scriptFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Python/pythonProject/profile"];

//    [CWFileManager cw_createFile:subScriptFilePath isDirectory:YES];
    
//    NSString *file1 = [[NSBundle mainBundle] pathForResource:@"Example1_PP_FCT__20190909_V1.csv" ofType:nil];
//    NSString *file2 = [[NSBundle mainBundle] pathForResource:@"Example2_FCT__ACE_FWDL.csv" ofType:nil];
//    [[NSFileManager defaultManager] copyItemAtPath:file1 toPath:[scriptFilePath stringByAppendingPathComponent:file1.lastPathComponent] error:nil];
//    [[NSFileManager defaultManager] copyItemAtPath:file2 toPath:[subScriptFilePath stringByAppendingPathComponent:file2.lastPathComponent] error:nil];
    
    [self treeViewDataConfig];
}


-(void)headerFolderClick{
//    system([[NSString stringWithFormat:@"open %@",subScriptFilePath] UTF8String]);
    [FileManager cw_openFileWithPath:scriptFilePath];
    
}
- (void)treeViewDataConfig {
    self.treeView.wantsLayer=YES;
    self.treeView.layer.backgroundColor = [NSColor windowBackgroundColor].CGColor;
    
    NSButton *btn = [NSButton buttonWithImage:[NSImage imageNamed:@"NSFolder"] target:self action:@selector(headerFolderClick)];
    btn.frame=CGRectMake(0,2, 30, 20);
    btn.bordered=NO;
    btn.bezelStyle = NSBezelStyleSmallSquare;
    [self.treeView.headerView addSubview:btn] ;
    
    NSFileManager *fileM =[NSFileManager defaultManager];

    NSArray *rootList = [fileM contentsOfDirectoryAtPath:scriptFilePath error:nil];
    
    for (NSString *rootName in rootList) {
        NSString *fullpath =[scriptFilePath stringByAppendingPathComponent:rootName];
        TreeNodeModel *rootNode = [[TreeNodeModel alloc]init];
        rootNode.name=rootName;
        rootNode.path =fullpath;
        [self.treeModel.childNodes addObject:rootNode];
        [self addChildNodeWithFile:fullpath upNode:rootNode];
    }

    [self.treeView reloadData];

    [self.treeView expandItem:[self.treeView itemAtRow:1] expandChildren:YES];
}


-(void)addChildNodeWithFile:(NSString *)path upNode:(TreeNodeModel *)upNode{
    BOOL isDir = YES;
    TreeNodeModel *lastNode = upNode;
    NSFileManager *fileM =[NSFileManager defaultManager];
    if ([fileM fileExistsAtPath:path isDirectory:&isDir]) {
        
        NSArray *childList =[fileM contentsOfDirectoryAtPath:path error:nil];
        if (childList.count) {
            for (NSString *childName in childList) {
                TreeNodeModel *levelNode = [[TreeNodeModel alloc]init];
                levelNode.name = childName;
                levelNode.path=[path stringByAppendingPathComponent:childName];
                [lastNode.childNodes addObject:levelNode];
                
            }
        }
    }
}


#pragma mark- NSOutlineViewDataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if(!item){
        return [self.treeModel.childNodes count];
    }
    else{
        
        TreeNodeModel *nodeModel = item;
        return [nodeModel.childNodes count];
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if(!item){
        return self.treeModel.childNodes[index];
    }
    else{
        
        TreeNodeModel *nodeModel = item;
        return nodeModel.childNodes[index];
    }
}



- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if(!item){
        return [self.treeModel.childNodes count]>0 ;
    }
    else{
        
        TreeNodeModel *nodeModel = item;
        return [nodeModel.childNodes count]>0;
    }
    
    
}




#pragma mark- NSOutlineViewDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item ;
{
    NSView *result  =  [outlineView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    NSArray *subviews = [result subviews];
    
    // NSImageView *imageView = subviews[0];
    
    NSTextField *field = subviews[0];
    
    TreeNodeModel *model = item;
    
    field.stringValue = model.name;
    
    //    if([[model childNodes]count]<=0){
    //        imageView.image = [NSImage imageNamed:NSImageNameListViewTemplate];
    //    }
    //    else {
    //        imageView.image = [NSImage imageNamed:NSImageNameFolder];
    //    }
    
    return result;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(nullable NSTableColumn *)tableColumn item:(id)item{
    return YES;
}

#pragma Action




#pragma mark-   Notification

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSOutlineView *treeView = notification.object;
    
    NSInteger row = [treeView selectedRow];
    
    TreeNodeModel *model = (TreeNodeModel*)[treeView itemAtRow:row];
    
    NSLog(@"name =%@",model.path);
    if ([model.path containsString:@".json"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftFileVCScriptFileClick" object:model.path];
    }
    
}


- (TreeNodeModel*)treeModel
{
    if(!_treeModel){
        _treeModel = [[TreeNodeModel alloc]init];
    }
    return _treeModel;
}


@end
