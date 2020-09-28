//
//  AJClangOrderFile.m
//  SC
//
//  Created by yl on 2020/9/15.
//  Copyright © 2020 anjing. All rights reserved.
//

#import "AJClangOrderFile.h"
#import <dlfcn.h>
#import <libkern/OSAtomic.h>


static OSQueueHead symbolist = OS_ATOMIC_QUEUE_INIT;

typedef struct {
    void *pc;
    void *next;
}SymbolNode;

void __sanitizer_cov_trace_pc_guard_init(uint32_t *start, uint32_t *stop) {
    static uint32_t N;
    if (start == stop || *start) {
        return;
    }
    
    for (uint32_t *X = start; X < stop; X ++) {
        *X = ++N;
    }
}

void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
    void *PC = __builtin_return_address(0);
    SymbolNode *node = malloc(sizeof(SymbolNode));
    *node = (SymbolNode){PC, NULL};
    
    OSAtomicEnqueue(&symbolist, node, offsetof(SymbolNode, next));
}

extern void ClangOrderFile(void(^completion)(NSString *orderFilePath)) {
    NSMutableArray<NSString *> *symbolNames = [NSMutableArray array];
    
    while (true) {
        SymbolNode *node = OSAtomicDequeue(&symbolist, offsetof(SymbolNode, next));
        
        if (node == NULL) {
            break;
        }
        
        Dl_info info;
        dladdr(node->pc, &info);
        
        NSString *name = @(info.dli_sname);
        
        BOOL isObjc = [name hasPrefix:@"+["] || [name hasPrefix:@"-["];
        NSString *symbolName = isObjc ? name : [@"_" stringByAppendingString:name];
        
        if (![symbolNames containsObject:symbolName]) {
            [symbolNames addObject:symbolName];
        }
    }
    
    NSArray *symbolArray = [[symbolNames reverseObjectEnumerator] allObjects];
    NSLog(@"%@", symbolArray);
    
    NSString *funcString = [symbolArray componentsJoinedByString:@"\n"];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"ld.order"];
    NSData *fileContents = [funcString dataUsingEncoding:NSUTF8StringEncoding];
    BOOL isSuccess = [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileContents attributes:nil];
    
    if (completion) {
        completion(isSuccess ? filePath : nil);
    }
}
