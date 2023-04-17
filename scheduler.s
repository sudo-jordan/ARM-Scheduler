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
