//
//  EntryListTableViewController.m
//  Diary
//
//  Created by Brian Wong on 8/21/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "EntryListTableViewController.h"
#import "DiaryEntry.h"
#import "EntryViewController.h"
#import "EntryCell.h"

@interface EntryListTableViewController ()<NSFetchedResultsControllerDelegate>

@property (nonatomic,strong)NSFetchedResultsController *fetchResultsController;

@end

@implementation EntryListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Performs our fetch request
    [self.fetchResultsController performFetch:nil];
}

//Next two blocks of code creates our fetch request controller if it hasn't already been

-(NSFetchRequest*)entryListFetchRequest{
    //Init a fetch request based on our entity
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DiaryEntry"];
    
    //Array of sort descriptors with only one element for  sorting the data(sections) using their date entries
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    return fetchRequest;
}

-(NSFetchedResultsController*)fetchResultsController{
    if(_fetchResultsController != nil){
        return _fetchResultsController;
    }
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self entryListFetchRequest];
    
    //Initialized with fetch request, our core data stack's managedObjectContext and the section name method in our DiaryEntry to name each section and sort them using the date entry
    
    //THIS IS WHAT CREATES OUR SECTION HEADERS! (sectionNameKeyPath)
    _fetchResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    _fetchResultsController.delegate = self;
    
    return _fetchResultsController;
}

#pragma mark - Table view data source
- (IBAction)showEditMode:(id)sender {
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    if ([self.tableView isEditing]) {
        // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
        [self.tableView setEditing:NO animated:YES];
        [self.editButtonItem setTitle:@"Edit"];
    }
    else {
        // Turn on edit mode
        [self.tableView setEditing:YES animated:YES];
        [self.editButtonItem setTitle:@"Done"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.fetchResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Returns the sections of our database as an array and uses our section integer to retrieve each existing section
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchResultsController sections][section];
    
    //Return the number of objects (rows) in each section
    return [sectionInfo numberOfObjects];
}

//Returns the name of each section created by our DiaryEntry class
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchResultsController sections][section];
    return [sectionInfo name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //Return each cell to the fetchResultsController
    DiaryEntry *entry = [self.fetchResultsController objectAtIndexPath:indexPath];
    [cell configureCellForEntry:entry];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiaryEntry *entry = [self.fetchResultsController objectAtIndexPath:indexPath];
    
    //Cells class method to layout each them - the view controller shouldn't be doing this!
    return [EntryCell heightForEntry:entry];
    
}

//Allows us to implement swipe to delete
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

//Functionality needed to implement swipe to delete
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiaryEntry *entry = [self.fetchResultsController objectAtIndexPath:indexPath];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [[coreDataStack managedObjectContext]deleteObject:entry];
    [coreDataStack saveContext];
    
}

//Called when subsequent changes to data are going to occur
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

//Based on the data editing we want to perform, we either delete or update the current index path of table view cells, or create a new array of them to insert a cell - this all happens with an animation
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

//Used to account for deleting the last cell in a section or creating a new one - creates and deletes sections
-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            //NSIndexSet creates a unique array (set where no element is alike or ordered) of sections with sectionIndex
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

//Called when changes to data are completed
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


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


#pragma mark - Navigation

//Passes an entry to EntryViewController when a cell is tapped so we can edit it
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"editEntry"]){
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        EntryViewController *entryVC = (EntryViewController*) navigationController.topViewController;
        entryVC.entry = [self.fetchResultsController objectAtIndexPath:indexPath];
    }
}


@end
