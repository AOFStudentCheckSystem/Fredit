//
//  StudentTVC.m
//  Fredit
//
//  Created by Codetector on 2017/4/21.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "AppDelegate.h"
#import "StudentTVC.h"
#import "FreditAPI.h"
#import "CoreDataSyncorization.h"
#import "StudentTableViewCell.h"

@interface StudentTVC ()
@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@end

@implementation StudentTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    
    UISearchBar* searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    self.tableView.tableHeaderView = searchBar;
    [searchBar sizeToFit];
    
    [self initializeFetchedResultsController];
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    context = [[delegate persistentContainer]viewContext];
    return context;
}

- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    request.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:[self managedObjectContext]];
    request.predicate = [NSPredicate predicateWithFormat:@"changed >= 0"];
    NSSortDescriptor *eventStatusSort = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
    NSSortDescriptor *eventTimeAscSort = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *eventIdAscSort = [NSSortDescriptor sortDescriptorWithKey:@"idNumber" ascending:NO];
    
    [request setSortDescriptors:@[eventStatusSort, eventTimeAscSort, eventIdAscSort]];
    
    NSManagedObjectContext *moc = [self managedObjectContext]; //Retrieve the main queue NSManagedObjectContext
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:@"lastnameInitial" cacheName:nil]];
    [[self fetchedResultsController]setDelegate:self];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void) reloadData {
    if ([FreditAPI isDeviceOnline]) {
        [[CoreDataSyncorization sharedSyncorization] syncorizeAllStudents];
    }
    [self.refreshControl endRefreshing];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell" forIndexPath:indexPath];
    [cell refreshContentWithStudent:(Student *)[self.fetchedResultsController objectAtIndexPath:indexPath]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.fetchedResultsController sections][section].name;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sectionIndexTitles;
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

@end
