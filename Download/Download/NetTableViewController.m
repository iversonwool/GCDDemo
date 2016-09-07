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

@end

@implementation NetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    // operation 对象会不断的创建
    // 解决重复下载图片的问题
    NSBlockOperation *operation = self.operations[model.icon];
    if (!operation) {
        operation = [NSBlockOperation blockOperationWithBlock:^{
            NSURL *url = [NSURL URLWithString:model.icon];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                cell.imageView.image = image;
                //[self.tableView reloadData];
            }];
        }];
        [self.queue addOperation:operation];
        self.operations[model.icon] = operation;
//        [self.operations setObject:operation forKey:model.icon];
    }
    
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.download;
    return cell;
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

@end
