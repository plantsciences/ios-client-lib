//
//  NSMutableArray+PFUpdate.m
//  tableview 2
//
//  Created by Jeff Wolski on 5/10/13.
//  Copyright (c) 2013 Organization Name. All rights reserved.
//

#import "NSMutableArray+PFUpdate.h"

@implementation NSMutableArray (PFUpdate)
- (void)updateToMatchArray:(NSArray *)sourceArray{
    
    NSIndexSet *indiciesOfObjectsToDelete;
    NSIndexSet *indiciesOfObjectsToInsert;
    NSArray *objectsToInsert;
    
    // calculate neccessary removals and insertions
    indiciesOfObjectsToDelete = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ![sourceArray containsObject:obj];
        }];
    
    indiciesOfObjectsToInsert = [sourceArray indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ![self containsObject:obj];
    }];
    
    objectsToInsert = [sourceArray objectsAtIndexes:indiciesOfObjectsToInsert];
    
    
    // perform necessary removals and insertions
    [self removeObjectsAtIndexes:indiciesOfObjectsToDelete];

    [self insertObjects:objectsToInsert atIndexes:indiciesOfObjectsToInsert];

    // sort objects
    // only preexsiting objects or candidates for being out of position
    
    NSMutableIndexSet *currentIndiciesOfPreexistingObjects = [NSMutableIndexSet indexSetWithIndexesInRange:NSRangeFromString([NSString stringWithFormat:@"%d-%d",0,self.count])]; // build a set of all indexes
    [currentIndiciesOfPreexistingObjects removeIndexes:indiciesOfObjectsToInsert]; // Drop indicies of objects that were removed. This leaves the indicies of preexisting objects.  This is independent of whether it's calculated before or after the deletions occur. JW
    
    // perform the sort
    [currentIndiciesOfPreexistingObjects enumerateIndexesUsingBlock:^(NSUInteger currentPositionOfObject, BOOL *stop) {
        id preexistingObject = self[currentPositionOfObject];
        if (preexistingObject != sourceArray[currentPositionOfObject]) {
            NSUInteger correctPositionOfObject = [sourceArray indexOfObject:preexistingObject];
            [self exchangeObjectAtIndex:currentPositionOfObject withObjectAtIndex:correctPositionOfObject];
        }
        
    }];
    
    
}
@end
