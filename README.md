## LiteMatrix
LiteMatrix is a 2D-array generic Swift container.
It is implemented as an Objective-C wrapper around a C-style 2D array of dumb pointers (void *) casted from type id. These pointers are actually mapped to id objects are that stored in an NSArray to be cleaned up by ARC. The dynamic allocations for the C-array are cleaned up in the dealloc method.
