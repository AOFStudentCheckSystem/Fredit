//
//  EventMasterTVController.m
//  Fredit
//
//  Created by Codetector on 2017/4/11.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "EventMasterTVController.h"
#import <UNIRest.h>
#import <CoreData/CoreData.h>
#import "FreditAPI.h"
#import "Event+CoreDataClass.h"
#import "AppDelegate.h"
#import "EventTableViewCell.h"
#import <SVProgressHUD.h>
#import "EventDetailViewController.h"

@interface EventMasterTVController() <NSFetchedResultsControllerDelegate>

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

- (NSManagedObjectContext *)asyncManagedObjectContext {
    NSManagedObjectContext *context = nil;
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    context = [[delegate persistentContainer] newBackgroundContext];
    return context;
}

- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    request.entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[self managedObjectContext]];
    
    NSSortDescriptor *eventTimeAscSort = [NSSortDescriptor sortDescriptorWithKey:@"eventTime" ascending:NO];
    
    [request setSortDescriptors:@[eventTimeAscSort]];
    
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
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (IBAction)addEvent:(UIBarButtonItem *)sender {
}
- (void) reloadData {
//    if (self.refreshControl && !self.refreshControl.refreshing) {
////        self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
//        [[self tableView]setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:true];
//        [self.refreshControl beginRefreshing];
//    }
    if (self.refreshControl && !self.isUpdating) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSDictionary* data = [[FreditAPI sharedInstance]listAllEvents];
            self.isUpdating = true;
            if (data != nil) {
                NSManagedObjectContext* context = [self managedObjectContext];
                NSMutableArray* eventIds = [[NSMutableArray alloc]init];
                //Add new Events
                for (NSDictionary* dict in (NSArray *)[data objectForKey:@"content"]) {
                    Event* event = [Event fetchOrCreateWithEventId:[dict objectForKey:@"eventId"] inManagedObjectContext: context];
                    NSString* eventId = [dict objectForKey:@"eventId"];
                    [eventIds addObject: eventId];
                    [event setEventId:eventId];
                    [event setEventTime:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"eventTime"] longValue] / 1000]];
                    event.eventStatus = [[dict objectForKey:@"eventStatus"]intValue];
                    event.eventName = [dict objectForKey:@"eventName"];
                    event.eventDescription = [dict objectForKey:@"eventDescription"];
                }
                //Remove outdate events
                NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
                [request setPredicate:[NSPredicate predicateWithFormat:@"NOT (eventId in %@)" argumentArray:@[eventIds]]];
                NSArray* delArray = [context executeFetchRequest:request error:nil];
                for (NSManagedObject* obj in delArray) {
                    [context deleteObject:obj];
                    NSLog(@"Removing %@", [(Event*)obj eventName]);
                }
                //Save Data
//                [context save:nil];
            } else {
                [SVProgressHUD showErrorWithStatus:@"Network Error!"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MMM d, h:mm a"];
                NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
                NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                            forKey:NSForegroundColorAttributeName];
                NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
                self.refreshControl.attributedTitle = attributedTitle;
                [self.refreshControl endRefreshing];
                [SVProgressHUD dismiss];
                self.isUpdating = false;
            });
        });
    } else if(self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = [[[self fetchedResultsController]sections]count];
    
    if (number == 0) {
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
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return !self.isUpdating;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isUpdating) {
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        UIAlertController* controller = [UIAlertController alertControllerWithTitle:@"Remove Event" message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* delAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD showWithStatus:@"Removing..."];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                if ([[FreditAPI sharedInstance] removeEvent:[(Event*)[[self fetchedResultsController] objectAtIndexPath:indexPath] eventId]]) {
                    [self reloadData];
                } else {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:@"Error Occoured!"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setEditing:false animated:true];
                });
            });
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setEditing:false animated:true];
        }];
        [controller addAction: delAction];
        [controller addAction: cancelAction];
        [self presentViewController:controller animated:YES completion:nil];
    }
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
