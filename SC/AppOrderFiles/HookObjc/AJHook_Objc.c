//
//  AJHook_Objc.c
//  SC
//
//  Created by yl on 2020/9/15.
//  Copyright © 2020 anjing. All rights reserved.
//

#include "AJHook_Objc.h"
#include "hook_core_arm64.h"

//调用方法
#define call(b, value) \
__asm volatile ("mov x12, %0\n" :: "r"(value)); \
__asm volatile (#b " x12\n");

//记录上下文
#define save() \
__asm volatile ( \
"stp x8, x9, [sp, #-16]!\n" \
"stp x6, x7, [sp, #-16]!\n" \
"stp x4, x5, [sp, #-16]!\n" \
"stp x2, x3, [sp, #-16]!\n" \
"stp x0, x1, [sp, #-16]!\n");

//恢复上下文
#define load() \
__asm volatile ( \
"ldp x0, x1, [sp], #16\n" \
"ldp x2, x3, [sp], #16\n" \
"ldp x4, x5, [sp], #16\n" \
"ldp x6, x7, [sp], #16\n" \
"ldp x8, x9, [sp], #16\n");

//初始objc_msgSend
static id (*origin_objc_msgSend)(void);

static void hook_Objc_msgSend() {
    save()

    __asm volatile ("mov x2, lr\n");

    call(blr, &pre_objc_msgSend)

    load()

    call(blr, origin_objc_msgSend)

    save()

    call(blr, &post_objc_msgSend)

    __asm volatile ("mov lr, x0\n");

    load()

    __asm volatile ("ret\n");
}

void startHook() {
    start_hook(hook_Objc_msgSend, (void *)&origin_objc_msgSend);
}
