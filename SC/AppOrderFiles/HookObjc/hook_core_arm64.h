//
//  hook_core_arm64.h
//  FishhookDemo
//
//  Created by yl on 2020/9/8.
//  Copyright © 2020 yl. All rights reserved.
//

#ifndef hook_core_arm64_h
#define hook_core_arm64_h

#include <stdio.h>
#include <objc/runtime.h>

void pre_objc_msgSend(id object, SEL _cmd, uintptr_t lr);
uintptr_t post_objc_msgSend(void);

void start_hook(void *hook_objc_msgSend, void **origin_objc_msgSend);

#endif /* hook_core_arm64_h */
