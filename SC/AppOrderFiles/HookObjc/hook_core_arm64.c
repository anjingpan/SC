//
//  hook_core_arm64.c
//  FishhookDemo
//
//  Created by yl on 2020/9/8.
//  Copyright © 2020 yl. All rights reserved.
//

#include "hook_core_arm64.h"
#include <dispatch/dispatch.h>
#include <pthread.h>
#include "fishhook.h"
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>

static pthread_key_t _thread_key;

typedef struct {
    uintptr_t lr;
    SEL _cmd;
    id self;
    char *class_name;
    uint64_t time;
} thread_call_record;

typedef struct {
    thread_call_record *record;
    int allocated_length;
    int index;
    bool is_main_thread;
} thread_call_stack;

static inline thread_call_stack *get_thread_call_stack() {
    thread_call_stack *cs = pthread_getspecific(_thread_key);
    
    if (cs == NULL) {
        cs = (thread_call_stack *)malloc(sizeof(thread_call_stack));
        cs->record = (thread_call_record *)calloc(128, sizeof(thread_call_record));
        cs->allocated_length = 64;
        cs->index = -1;
        cs->is_main_thread = pthread_main_np();
        
        pthread_setspecific(_thread_key, cs);
    }
    
    return cs;
}

void pre_objc_msgSend(id object, SEL _cmd, uintptr_t lr) {
    thread_call_stack *cs = get_thread_call_stack();
    if (cs) {
        int nextIndex = (++cs->index);
        if (nextIndex >= cs->allocated_length) {
            cs->allocated_length += 64;
            cs->record = (thread_call_record *)realloc(cs->record, cs->allocated_length * sizeof(thread_call_record));
        }
        
        thread_call_record *new_record = &cs->record[nextIndex];
        new_record->self = object;
        new_record->_cmd = _cmd;
        new_record->class_name = (char *)class_getName(object_getClass(object));
        new_record->lr = lr;
        
        if (cs->is_main_thread) {
            struct timeval now;
            gettimeofday(&now, NULL);
            new_record->time = now.tv_sec * 1000000 + now.tv_usec;
        }
    }
    
}

bool hook_has_prefix(char *target, char *prefix) {
    uint64_t count = strlen(prefix);
    bool ret = true;
    if(strlen(target) < count)
        return false;
    for (int i = 0; i < count; i ++) {
        if (target[i] != prefix[i]) {
            ret = false;
            break;
        }
    }
    return ret;
}

uintptr_t post_objc_msgSend() {
    thread_call_stack *cs = get_thread_call_stack();
    int curIndex = cs->index;
    int lastIndex = cs->index--;
    thread_call_record *lastRecord = &cs->record[lastIndex];
    
    if (cs->is_main_thread) {
        struct timeval now;
        gettimeofday(&now, NULL);
        uint64_t time = now.tv_sec * 1000000 + now.tv_usec;
        
        uint64_t cost = time - lastRecord->time;
        
        if (!hook_has_prefix(cs->record->class_name, "OS_")) {
//            printf("~~~~~%d- [%s %s]%lld ms \n", curIndex, cs->record->class_name, (char *)cs->record->_cmd, cost);
        }
    }
    
    return lastRecord->lr;
}

void release_thread_call_stack(void *ptr) {
    thread_call_stack *cs = (thread_call_stack *)ptr;
    if (!cs) return;
    if (cs->record) free(cs->record);
    free(cs);
}

void start_hook(void *hook_objc_msgSend, void **origin_objc_msgSend) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pthread_key_create(&_thread_key, &release_thread_call_stack);
        
        rebind_symbols((struct rebinding[1]){
            "objc_msgSend",
            hook_objc_msgSend,
            origin_objc_msgSend
        }, 1);
    });

}
