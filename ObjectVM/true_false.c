//
//  true_false.c
//  ObjectVM
//
//  Created by Kyle Roucis on 13-11-21.
//  Copyright (c) 2013 Kyle Roucis. All rights reserved.
//

#include "true_false.h"

#include "object.h"
#include "class.h"
#include "vm.h"
#include "str.h"
#include "block.h"
#include "nil.h"

#pragma mark True
#pragma mark False

#pragma mark - Bound Methods

static void false_is_nil_native(object* obj, clockwork_vm* vm)
{
    clkwk_pushFalse(vm);
    clkwk_return(vm);
}

static void false_is_true_native(object* obj, clockwork_vm* vm)
{
    clkwk_pushFalse(vm);
    clkwk_return(vm);
}

static void false_is_false_native(object* obj, clockwork_vm* vm)
{
    clkwk_pushTrue(vm);
    clkwk_return(vm);
}

static void false_description_native(object* obj, clockwork_vm* vm)
{
    clkwk_pushStringCstr(vm, "false");
    clkwk_return(vm);
}

static void true_description_native(object* obj, clockwork_vm* vm)
{
    clkwk_pushStringCstr(vm, "true");
    clkwk_return(vm);
}

#pragma mark - Native Methods

class* true_class(clockwork_vm* vm)
{
    class* tc = class_init(vm, "True", "Object");

    return tc;
}

object* true_instance(clockwork_vm* vm)
{
    object* trueSuper = object_init(vm);
    class* trueClass = (class*)clkwk_getConstant(vm, "True");
    object* trueObj = object_create_super(vm, trueSuper, trueClass, sizeof(struct object_header));

    {
        block* descriptionMethodNative = block_init_native(vm, 0, 0, &true_description_native);
        class_addInstanceMethod(trueClass, vm, "description", descriptionMethodNative);
    }

    return trueObj;
}

class* false_class(clockwork_vm* vm)
{
    class* fc = class_init(vm, "False", "Object");

    {
        block* isNilMethodNative = block_init_native(vm, 0, 0, &false_is_nil_native);
        class_addClassMethod(fc, vm, "isNil", isNilMethodNative);
        class_addInstanceMethod(fc, vm, "isNil", isNilMethodNative);
    }

    {
        block* isTrueMethodNative = block_init_native(vm, 0, 0, &false_is_true_native);
        class_addClassMethod(fc, vm, "isTrue", isTrueMethodNative);
        class_addInstanceMethod(fc, vm, "isTrue", isTrueMethodNative);
    }

    {
        block* isFalseMethodNative = block_init_native(vm, 0, 0, &false_is_false_native);
        class_addClassMethod(fc, vm, "isFalse", isFalseMethodNative);
        class_addInstanceMethod(fc, vm, "isFalse", isFalseMethodNative);
    }

    {
        block* descriptionMethodNative = block_init_native(vm, 0, 0, &false_description_native);
        class_addInstanceMethod(fc, vm, "description", descriptionMethodNative);
    }

    return fc;
}

object* false_instance(clockwork_vm* vm)
{
    object* falseSuper = object_init(vm);
    object* falseObj = object_create_super(vm, falseSuper, (class*)clkwk_getConstant(vm, "False"), sizeof(struct object_header));
    return falseObj;
}

int object_isTrue(object* obj, clockwork_vm* vm)
{
    return !(object_isFalse(obj, vm));
}

int object_isFalse(object* obj, clockwork_vm* vm)
{
    return object_isKindOfClass_native(obj, (class*)clkwk_getConstant(vm, "False")) || object_isNil(obj, vm);
}
