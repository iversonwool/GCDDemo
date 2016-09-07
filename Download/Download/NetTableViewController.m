//
//  NetTableViewController.m
//  Download
//
//  Created by 李浩 on 16/9/2.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "NetTableViewController.h"
#import "AppModel.h"

static NSString *cellID = @"appCell";

@interface NetTableViewController ()
/** 存放应用*/
@property (nonatomic, strong) NSMutableArray *apps;
/** 存放所有下载操作的队列*/
// 保证queue只有一个
@property (nonatomic, strong) NSOperationQueue *queue;
/** 存放操作队列 */
@property (nonatomic, strong) NSMutableDictionary *operations;
@property (nonatomic, strong) NSMutableDictionary *images;


@end

@implementation NetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSMutableDictionary *)images {
    if (!_images) {
        self.images = [NSMutableDictionary dictionary];
    }
    return _images;
}

- (NSOperationQueue *)queue {
    if (!_queue) {
        self.queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSMutableArray *)apps {
    if (!_apps) {
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"apps" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dic in array) {
            AppModel *model = [AppModel modelWithDict:dic];
            [mArr addObject:model];
        }
        self.apps = mArr;
    }
    return _apps;
}

- (NSMutableDictionary *)operations {
    if (!_operations) {
        self.operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // 内存吃紧
    // 移除操作
    [self.queue cancelAllOperations];
    [self.operations removeAllObjects];
    
    // 移除图片
    [self.images removeAllObjects];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.apps.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    // Configure the cell...
    AppModel *model = self.apps[indexPath.row];
    // 刚开始一进来，缓存中没有图片，进行可以看到的图片张数的下载，下载完成之后，会刷新表格，图片的设置其实是从缓存中取出来的刚才下载的图片
    // 先从images缓存中取出图片URL对应的UIImage
    UIImage *image = self.images[model.icon];
    if (image) {
        cell.imageView.image = image;
    } else {
        // 设置占位图片 placeholder
        cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
        
        // download image
        [self downloadImageWithUrl:model.icon IndexPath:indexPath];
    }
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.download;
    return cell;
}

- (void)downloadImageWithUrl:(NSString *)imageUrl IndexPath:(NSIndexPath *)indexPath {
    // operation 对象会不断的创建
    // 解决重复下载图片的问题
    
    // 下载失败会重新下载
    NSBlockOperation *operation = self.operations[imageUrl];
    // 减少缩进的小技巧
    if (operation) return;
    operation = [NSBlockOperation blockOperationWithBlock:^{
        // 模拟下载耗时
        [NSThread sleepForTimeInterval:5];
        NSURL *url = [NSURL URLWithString:imageUrl];
        // 下载操作
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 直接设置图片可能产生图片错乱
            //cell.imageView.image = image;
            // 添加图片到images
            // 图片不能为空
            if (image) {
                [self.images setObject:image forKey:imageUrl];
            }
            // 移除operation（防止字典越来越大）
            [self.operations removeObjectForKey:imageUrl];
            // 刷新表格，但是不需要全部刷新，只需要刷新对应的那一行
            // 当初的cell可能不是现在的cell，当初的行号还是现在的行号
            //[self.tableView reloadData];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
    [self.queue addOperation:operation];
    // 存放下载操作（解决重复下载的问题）
    self.operations[imageUrl] = operation;
    
    
    // [self.operations setObject:operation forKey:model.icon];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 开始拖拽时暂停下载
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.queue.suspended = YES;
}

// 结束拖拽时开始下载
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.queue.suspended = NO;
}

@end
