//
//  OVMAppDelegate.m
//  ObjectVM
//
//  Created by Kyle Roucis on 13-11-10.
//  Copyright (c) 2013 Kyle Roucis. All rights reserved.
//

#import "OVMAppDelegate.h"

#import "vm.h"
#import "str.h"
#import "object.h"
#import "class.h"
#import "integer.h"
#import "tokenizer.h"
#import "input_stream.h"
#import "binary.h"
#import "assembler.h"
#import "disassembler.h"
#import "block.h"
#import "array.h"

#import "parser.h"
#import "ast.h"

#import "memory_manager.h"
#import "symbols.h"

#import "primitive_table.h"

#import <string.h>

@implementation OVMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//    memory_manager* mm = memory_manager_init(1024);


    clockwork_vm* vm = clkwk_init();

//    primitive_table* tbl = primitive_table_init(vm, 10);
//    primitive_table_dealloc(tbl, vm, Yes);

    // test.clkwkasm
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString* binaryPath = [documentsDirectory stringByAppendingPathComponent:@"binary.clkwk"];
//    NSData* binaryData = [NSData dataWithContentsOfFile:binaryPath];
//    unsigned long long len = [binaryData length];
//    const char* asm_data = [binaryData bytes];
//
//    clockwork_binary* asm_bin = clockwork_binary_init(asm_data, len, vm);

//    printf("[[-- Start ASM --]]\n");
//    for (int i = 0; i < len; i++)
//    {
//        printf("%d ", asm_data[i]);
//    }
//    printf("\n[[-- End ASM --]]\n");
//
//    printf("[[-- Start DIS --]]\n");
//    char* d = malloc(len * 2);
//    uint64_t disLen = disassembler_disassembleBinary(asm_bin, vm, d, len * 2);
//    for (int i = 0; i < disLen; i++)
//    {
//        printf("%c", d[i]);
//    }
//    printf("[[-- End DIS --]]\n");
//
//    clkwk_runBinary(vm, asm_bin);

    NSString* path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"clkwkasm"];

    FILE* file = fopen([path UTF8String], "r");
    fseek(file, 0L, SEEK_END);
    long size = ftell(file);
    rewind(file);

    char* s = malloc(size);
    fread(s, sizeof(char), size, file);

    clockwork_binary* asm_bin;
    unsigned long long len;
    const char* asm_data;

    asm_bin = assembler_assemble_cstr(s, strlen(s), vm);
    printf("[[-- Start ASM --]]\n");
    len = clockwork_binary_length(asm_bin);
    asm_data = clockwork_binary_data(asm_bin);
    for (int i = 0; i < len; i++)
    {
        printf("%d ", asm_data[i]);
    }
    printf("\n[[-- End ASM --]]\n");

    // Write binary to disk
//    NSData* binary = [NSData dataWithBytes:asm_data length:len];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString* binaryPath = [documentsDirectory stringByAppendingPathComponent:@"binary.clkwk"];
//    if (![binary writeToFile:binaryPath atomically:true])
//    {
//        NSLog(@"UHOH!");
//    }

//    printf("[[-- Start DIS --]]\n");
//    free(d);
//    char* d = malloc(size * 2);
//    uint64_t disLen = disassembler_disassembleBinary(asm_bin, vm, d, size * 2);
//    for (int i = 0; i < disLen; i++)
//    {
//        printf("%c", d[i]);
//    }
//    printf("[[-- End DIS --]]\n");
//
//    clkwk_runBinary(vm, asm_bin);
//
//    clockwork_binary_dealloc(asm_bin, vm);
//    free(s);
//    free(d);
//    fclose(file);
//
//    // math.clkwkasm
//    path = [[NSBundle mainBundle] pathForResource:@"math" ofType:@"clkwkasm"];
//
//    file = fopen([path UTF8String], "r");
//    fseek(file, 0L, SEEK_END);
//    size = ftell(file);
//    rewind(file);
//
//    s = malloc(size);
//    fread(s, sizeof(char), size, file);
//
//    asm_bin = assembler_assemble_cstr(s, strlen(s), vm);
//    printf("[[-- Start ASM --]]\n");
//    len = assembled_binary_size(asm_bin);
//    const char* const asm_math = assembled_binary_data(asm_bin);
//    for (int i = 0; i < len; i++)
//    {
//        printf("%d ", asm_math[i]);
//    }
//    printf("\n[[-- End ASM --]]\n");
//
//    clkwk_runBinary(vm, asm_bin);

//    [self testForwardCrash];
}

- (void) testSimpleAST
{
    numeric_literal_ast_node* six_node = malloc(sizeof(numeric_literal_ast_node));
    six_node->type = NumericTypeInteger;
    six_node->node_type = NodeTypeNumeric;
    six_node->value.uint = 6;

    numeric_literal_ast_node* two_point_seven_node = malloc(sizeof(numeric_literal_ast_node));
    two_point_seven_node->type = NumericTypeFloat;
    two_point_seven_node->node_type = NodeTypeNumeric;
    two_point_seven_node->value.dbl = 2.7;

    binary_ast_node* add_node = malloc(sizeof(binary_ast_node));
    add_node->node_type = NodeTypeBinaryOp;
    add_node->op = BinaryOperatorAdd;
    add_node->left_operand = (ast_node*)six_node;
    add_node->right_operand = (ast_node*)two_point_seven_node;

    free(add_node);
    free(two_point_seven_node);
    free(six_node);
}

@end
