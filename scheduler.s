.global main
main:

@ print entire menu
	ldr r0, =welcome
	bl printf
	ldr r0, =add_set
	bl printf
	ldr r0, =add_flex
	bl printf
	ldr r0, =clear_time
	bl printf
	ldr r0, =print_sched
	bl printf
	ldr r0, =bye
	bl printf

@ allow user to select a menu item
	ldr r0, =select
	bl printf
	ldr r0, =format_select
	ldr r1, =select_buff
	bl scanf

@ if input is 1, perform option 1
	ldr r1, =format_select
	ldr r1, [r1]
	cmp r1, #1
	beq option1

@ if input is 2, perform option 2
	cmp r1, #2
	beq option2

@ if input is 3, perform option 3
	cmp r1, #3
	beq option3

@ if input is 4, perform option 4
	cmp r1, #4
	beq option4

@ if input is 5, quit the program
	cmp r1, #5
	beq exit

option1:
option2:
option3:
option4:
option5:

exit:
	ldr r0, =done
	bl printf
	mov r7, #1
	mov r0, #0
	svc 0
.data
	welcome:	.asciz "\nWelcome to our Scheduler. Please choose an action: \n"
	add_set:	.asciz "\n1. Add Set Event"
	add_flex:	.asciz "\n2. Add Flexible Event"
	clear_time:	.asciz "\n3. Clear Time"
	print_sched:	.asciz "\n4. Print Schedule"
	bye:		.asciz "\n5. Quit"
	choose_day:	.asciz "\nChoose Day: "
	choose_time:	.asciz "\nChoose Time: "
	select:		.asciz "\n\nSelect > "
	done:		.asciz "\nExiting!"

	format_select:	.asciz "%d"
	select_buff:	.word 0
