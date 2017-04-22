//
//  EventMasterTVController.m
//  Fredit
//
//  Created by Codetector on 2017/4/11.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "EventMasterTVController.h"
#import "CoreDataSyncorization.h"
#import "UNIRest.h"
#import <CoreData/CoreData.h>
#import "FreditAPI.h"
#import "FreditDataAccessObject.h"
#import "Event+CoreDataClass.h"
#import "AppDelegate.h"
#import "EventTableViewCell.h"
#import "SVProgressHUD.h"
#import "EventDetailViewController.h"
#import "EventDetailEditingTVC.h"
#import "UIColor+ColorFromRGB.h"

@interface EventMasterTVController() <NSFetchedResultsControllerDelegate, MGSwipeTableCellDelegate>

@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (atomic) BOOL isUpdating;

@end

@implementation EventMasterTVController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    context = [[delegate persistentContainer]viewContext];
    return context;
}

- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    request.entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[self managedObjectContext]];
    request.predicate = [NSPredicate predicateWithFormat:@"changed >= 0"];
    NSSortDescriptor *eventTimeAscSort = [NSSortDescriptor sortDescriptorWithKey:@"eventTime" ascending:NO];
    NSSortDescriptor *eventIdAscSort = [NSSortDescriptor sortDescriptorWithKey:@"eventId" ascending:NO];
    
    [request setSortDescriptors:@[eventTimeAscSort, eventIdAscSort]];
    
    NSManagedObjectContext *moc = [self managedObjectContext]; //Retrieve the main queue NSManagedObjectContext
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self fetchedResultsController]setDelegate:self];

    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (void) viewDidLoad {
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    UIColor* themePink = [UIColor colorWithRed:1.000 green:0.452 blue:0.756 alpha:1];
    self.refreshControl.backgroundColor = themePink;
    self.navigationController.navigationBar.barTintColor = themePink;
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    
    [self initializeFetchedResultsController];
    [self setIsUpdating:false];
    [self reloadData];
    self.tableView.estimatedRowHeight = 110;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (IBAction)addEvent:(UIBarButtonItem *)sender {
    EventDetailEditingTVC* editing = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetailEditVC"];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:editing];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void) reloadData {
    if (self.refreshControl && !self.isUpdating) {
        self.isUpdating = true;
        [[CoreDataSyncorization sharedSyncorization]attemptFullSyncorization:^{
            [self.refreshControl endRefreshing];
            self.isUpdating = false;
        }];
    } else if(self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = [[[self fetchedResultsController]sections]count];
    if (number == 0 || [[[self fetchedResultsController]sections][0]numberOfObjects] == 0) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Menlo" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return number;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    id<NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsController] sections];
    return [([[self fetchedResultsController]sections][section]) numberOfObjects];
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    Event* eventObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell updateViewWithEvent:eventObject];
    
    //Setup the slides
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"Remove Event" message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* delAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if ([[FreditAPI sharedInstance]isAuthenticated]) {
                [(Event*)[[self fetchedResultsController] objectAtIndexPath:[self.tableView indexPathForCell:cell]] setChanged:-1];
                [[self managedObjectContext]save:nil];
            }
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setEditing:false animated:true];
        }];
        [controller addAction: delAction];
        [controller addAction: cancelAction];
        [self presentViewController:controller animated:YES completion:nil];
        return true;
    }]];
    cell.rightExpansion.fillOnTrigger = YES;
    cell.rightExpansion.buttonIndex = 0;
    
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Send Mail" backgroundColor:[UIColor colorWithRGB:0x007aff] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        [SVProgressHUD showWithStatus:@"Sending..."];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Event* this = (Event*)[[self fetchedResultsController] objectAtIndexPath:[self.tableView indexPathForCell:cell]];
            [[FreditAPI sharedInstance]sendMailforEvent:this toAddress:@"codetector@codetector.cn"];
            [SVProgressHUD dismiss];
            [SVProgressHUD setMaximumDismissTimeInterval:1];
            [SVProgressHUD showSuccessWithStatus:@"Email Sent"];
        });
        return true;
    }]];
    
    cell.leftExpansion.buttonIndex = 0;
    cell.leftExpansion.fillOnTrigger = YES;
    
    return cell;
}



//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([[self tableView]indexPathForSelectedRow]) {
        [[self tableView]deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }
}

#pragma CoreData delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] endUpdates];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController* controller  = [segue destinationViewController];
    if ([controller isKindOfClass:[UINavigationController class]]) {
        controller = [(UINavigationController*)controller topViewController];
    }
    if ([controller isKindOfClass:[EventDetailViewController class]]
        && [sender isKindOfClass:[EventTableViewCell class]]) {
        [(EventDetailViewController *)controller populateViewWithEvent:[(EventTableViewCell*) sender baseEvent]];
    }
}

@end
