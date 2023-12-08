.data
.globl res1
res1:
.string "result 1: %d\n"

.globl res2
res2:
.string "result 2: %d\n"

.globl example_t
example_t:
.word 7, 15, 30

.globl example_d
example_d:
.word 9, 40, 200

.globl input_t
input_t:
.word 62, 64, 91, 90

.globl input_d
input_d:
.word 553, 1010, 1473, 1074

.text
.global main
main:
    push %rbp
    // Final result
    mov $1, %r15
    
    // Load arrays example
    // lea example_t, %r12
    // lea example_d, %r13

    // Load arrays input
    lea input_t, %r12
    lea input_d, %r13

    mov $4, %r14
    array_loop:
    // set time and duration args
    mov $0, %rdi
    mov $0, %rsi

    mov (%r12), %di
    mov (%r13), %si
    call calc_pair

    // multiply result
    mov %rax, %rbx
    mov %r15, %rax
    mov $0, %rdx
    mul %rbx
    mov %rax, %r15

    add $2, %r12
    add $2, %r13

    dec %r14
    jnz array_loop
    array_end:

    // Print final result
    mov %rsp, %rbp
    mov $res1, %rdi
    mov %r15, %rsi
    call printf

    // Load example
    // mov $71530, %rdi
    // mov $940200, %rsi

    // Load input
    mov $62649190, %rdi
    mov $553101014731074, %rsi

    call calc_pair

    mov %rsp, %rbp
    mov $res2, %rdi
    mov %rax, %rsi
    call printf

    mov $0, %rax
    leave
    ret

calc_pair:
    // Set result to 0
    mov $0, %r11
    
    // t - 1
    mov %rdi, %rax
    dec %rax

    // init counter to 0
    mov $0, %r10
    loop:
    cmp %r10, %rax
    jz loop_done
    inc %r10

    // jump to beginning of loop if i * (t-i) <= d 
    mov %r10, %rax
    mov %rdi, %rbx
    mov $0, %rdx
    sub %r10, %rbx
    mul %rbx

    // do the comparison
    cmp %rax, %rsi
    jge loop
    // increment result
    inc %r11
    jmp loop

    loop_done:
    mov %r11, %rax
    ret

    // div by 2
    //mov $2, %rbx
    //mov $0, %rdx
    //div %rbx
    // Ceiling function (only for / 2)
    //add %rdx, %rax
