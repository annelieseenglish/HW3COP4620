#include "y.tab.h"
#include "ast.h"
#include <string.h>
#include <stdlib.h>

int yyparse();

typedef struct {	//struct to store def variable info
    char *name;
    int num_params;
    int ast_node_id;     // AST node ID where function is defined
} FunctionEntry;


typedef struct {	//struct to store variable info
    char *name;
    int scope_start;          // Start & end of scope (where variable becomes valid)
    int scope_end;
    char *func_name;
} VariableEntry;

typedef struct {	//all def functions
    FunctionEntry *entries;  // Dynamic array of function entries
    int count;
    int capacity;
} FunctionTable;

typedef struct {	//all declared variables
    VariableEntry *entries;  // Dynamic array of variable entries
    int count;
    int capacity;
} VariableTable;

FunctionTable func_table;
VariableTable var_table;

// SYMBOL TABLE INITIALIZATION AND CLEANUP

void init_function_table() {	//initializing with initil capacity
    func_table.capacity = 16;
    func_table.count = 0;
    func_table.entries = (FunctionEntry*)malloc(sizeof(FunctionEntry) * func_table.capacity);
}

void init_variable_table() {
    var_table.capacity = 32;
    var_table.count = 0;
    var_table.entries = (VariableEntry*)malloc(sizeof(VariableEntry) * var_table.capacity);
}

void free_symbol_tables() {
    for (int i = 0; i < func_table.count; i++) {
        free(func_table.entries[i].name);
    }
    free(func_table.entries);
    
    for (int i = 0; i < var_table.count; i++) {
        free(var_table.entries[i].name);
        free(var_table.entries[i].func_name);
    }    free(var_table.entries);
}

// FUNCTION TABLE OPERATIONS

// Add a function to the function table
// Returns 1 if error (duplicate), 0 if success
int add_function(char *name, int num_params, int ast_node_id) {
    for (int i = 0; i < func_table.count; i++) {
        if (strcmp(func_table.entries[i].name, name) == 0) {
            fprintf(stderr, "Function %s is defined twice\n", name);
            return 1;  // Error: duplicate function definition
        }
    }

    if (func_table.count >= func_table.capacity) {	//expand capacity dynamically if needed
        func_table.capacity *= 2;
        func_table.entries = (FunctionEntry*)realloc(func_table.entries, 
                                                      sizeof(FunctionEntry) * func_table.capacity);
    }

    func_table.entries[func_table.count].name = strdup(name);
    func_table.entries[func_table.count].num_params = num_params;
    func_table.entries[func_table.count].ast_node_id = ast_node_id;
    func_table.count++;
    
    return 0;  // Success yay
}

// Look up a function by name
// Returns pointer to FunctionEntry if found, NULL if not found
FunctionEntry* lookup_function(char *name) {
    for (int i = 0; i < func_table.count; i++) {
        if (strcmp(func_table.entries[i].name, name) == 0) {
            return &func_table.entries[i];
        }
    }
    return NULL;  // Function not found :(
}

// VARIABLE TABLE OPERATIONS

// Add a variable to the variable table
// Returns 1 if error (duplicate or name conflict), 0 if success
int add_variable(char *name, int scope_start, int scope_end, char *func_name) {
    for (int i = 0; i < var_table.count; i++) {
        if (strcmp(var_table.entries[i].name, name) == 0 &&
            strcmp(var_table.entries[i].func_name, func_name) == 0) {
            fprintf(stderr, "Variable %s is declared twice\n", name);
            return 1;  // Error same variable found in same function
        }
    }

//variable and function cannot have the same name
    if (lookup_function(name) != NULL) {
        fprintf(stderr, "Variable %s has the name of a defined function\n", name);
        return 1;
    }

    // Expand capacity dynamically if needed
    if (var_table.count >= var_table.capacity) {
        var_table.capacity *= 2;
        var_table.entries = (VariableEntry*)realloc(var_table.entries, 
                                                     sizeof(VariableEntry) * var_table.capacity);
    }
    var_table.entries[var_table.count].name = strdup(name);
    var_table.entries[var_table.count].scope_start = scope_start;
    var_table.entries[var_table.count].scope_end = scope_end;
    var_table.entries[var_table.count].func_name = strdup(func_name);
    var_table.count++;
    return 0;  // Success yay
}

// Look up a variable and check if it's valid at a given AST node
// Returns pointer to VariableEntry if found and in scope, NULL otherwise
VariableEntry* lookup_variable(char *name, int node_id) {
    for (int i = 0; i < var_table.count; i++) {
        //valid if name matches & current node id within variable scope
        if (strcmp(var_table.entries[i].name, name) == 0 &&
            node_id >= var_table.entries[i].scope_start &&
            node_id <= var_table.entries[i].scope_end) {
            return &var_table.entries[i];
        }
    }
    return NULL;
}

// Pass  1

int stgen(struct ast* node)
{
    if (node->ntoken == INP)	//handle INP nodes
    {
        struct ast* deffun = node->parent;
        struct ast* funid = get_child(deffun, 1);
        char *func_name = funid->token;
        // Calculate scope
        int scope_start = funid->id;
        int num_children = get_child_num(deffun);
        int scope_end = get_child(deffun, num_children)->id;

printf("found input declaration ``%s'' for function %s;\n ",
	       node->token,
               func_name,
               scope_start,
               scope_end);
        // Add variable to symbol table check for duplicated and confliction
        if (add_variable(node->token, scope_start, scope_end, func_name) == 1) {
            return 1;
        }
    }

    // Handle FUNID nodes
    if (node->ntoken == FUNID)
    {
        int num_params = 0;
        int num_children = get_child_num(node->parent);
        for (int i = 1; i <= num_children; i++) {
            struct ast* child = get_child(node->parent, i);
            if (child != NULL && child->ntoken == INP) {
                num_params++;
            }
        }
        // Add function to symbol table
        if (add_function(node->token, num_params, node->id) == 1) {
            return 1;  // Error occurred, stop
        }
    }
    return 0;  // Success, continue visiting other nodes
}

// Pass 2

int check(struct ast* node)
{
    if (node->ntoken == VARID)	//handle varid nodes
    {
        printf("found variable ``%s'' in AST node with id %d;\n\
 is it a legal use?\n",
               node->token,
               node->id);
        if (lookup_variable(node->token, node->id) == NULL) {	//variable must be declared and in scope
            fprintf(stderr, "Variable %s is not declared\n", node->token);
            return 1;  // Error: variable not declared or out of scope
        }
    }

    if (node->ntoken == CALL)	//handle call nodes
    {
        char *func_name = node->token;

        if (strcmp(func_name, "GET-INT") == 0 || strcmp(func_name, "get-int") == 0) {
            return 0;  // Skip checking for get-int
        }

        FunctionEntry *func = lookup_function(func_name);	//checks if function defined before use
        if (func == NULL) {
            fprintf(stderr, "Function %s is not defined\n", func_name);
            return 1;  // Error: function not defined
        }

        int actual_num_params = get_child_num(node);

        if (func->num_params != actual_num_params) {	//# args must matcg func def
            fprintf(stderr, "Wrong number of arguments of function %s\n", func_name);
            return 1;  // Error mismatch
        }
    }
    return 0;  // Success, continue visiting other nodes
}

//Main func
int main(int argc, char **argv) {
    init_function_table();
    init_variable_table();

    // Parse input and build AST
    int retval = yyparse();
    if (retval == 0)  // Parsing successful
    {
        print_ast();
        // PASS 1: Visit all AST nodes and build symbol table
        retval = visit_ast(stgen);
        if (retval == 1) {
            printf("unable to construct symbol table\n");
        }
        else {
            // PASS 2: Visit all AST nodes and perform semantic checks
            retval = visit_ast(check);
            if (retval == 1) {
                printf("semantic error\n");
            }
        }
    }
    free_ast();
    free_symbol_tables();
    return retval;
}
