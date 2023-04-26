@scheduler.s
@Created by Jordan Saleh and William Daniel Vasquez
@R2-8 are used to hold data for days of the week
.global main
main: @Main is used for setup

loop:

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
	ldr r0, =menu_help
	bl printf
	ldr r0, =bye
	bl printf

@ allow user to select a menu item
	ldr r0, =select
	bl printf
	ldr r0, =format_select
	ldr r1, =select_buff
	bl scanf
	ldr r1, =format_select
	ldr r1, [r1]

@ if input is 1, set event
	cmp r1, #1
	beq set

@ if input is 2, flexible event
	cmp r1, #2
	beq flex

@ if input is 3, clear time
	cmp r1, #3
	beq clear

@ if input is 4, print schedule
	cmp r1, #4
	beq schedule

@ if input is 5, perform option 5
	cmp r1, #5
	beq option4
	
@ if input is 6, quit the program
	cmp r1, #6
	beq exit
	
	b loop @If none of the above are entered, restart loop

set: @Add an event, set time
	ldr r0, =start_time
	bl printf
	ldr r0, =format_select
	ldr r1, =select_buff
	bl scanf
	ldr r1, =format_select
	ldr r1, [r1]
	mov r9, r1 @Copy input to r9, this will be the start time
	@Take another input, same as before, use time_length for a prompt
	mov r10, r1 @Copy input to r10, this will be the length of the event
	@Take another input, same as before, use choose_day for a prompt
	bl createTimeSlot @call to createTimeSlot
	
	cmp r1, #1 @Monday edit
	mov r2, r9 @Setup for check
	bl overlapCheck 
	orreq r2, r11
	b loop
	
	cmp r1, #2 @Tuesday edit
	mov r3, r9 @Setup for check
	bl overlapCheck 
	orreq r3, r11
	b loop
	
	cmp r1, #3 @Wednesday edit
	mov r4, r9 @Setup for check
	bl overlapCheck 
	orreq r4, r11
	b loop
	
	cmp r1, #4 @Thursday edit
	mov r5, r9 @Setup for check
	bl overlapCheck 
	orreq r5, r11
	b loop
	
	cmp r1, #5 @Friday edit
	mov r6, r9 @Setup for check
	bl overlapCheck 
	orreq r6, r11
	b loop
	
	cmp r1, #6 @Saturday edit
	mov r7, r9 @Setup for check
	bl overlapCheck 
	orreq r7, r11
	b loop
	
	cmp r1, #7 @Sunday edit
	mov r7, r9 @Setup for check
	bl overlapCheck 
	orreq r7, r11 @Only edit if there is no overlap
	b loop
	
overlapCheck: @Check to ensure there is no overlap
	mov r10, r9 @Copy into r10
	mov r12, r9 @Copy into r12
	orr r12, r11 
	eor r10, r11
	cmp r12, r10 @Exclusive or and or should be equal if there is no overlap
	bx lr
	
createTimeSlot: @Creates a mask for editing time slots
	ldr r11, =#0xFFFFFFFF @reset time slot
	mov r12, #32 @Number of bits
	sub r12, r10 @Desired shift
	lsl r11, r12 @r11 now has 1 bits equal to r10
	lsr r11, r12 @Fully right-shifted
	lsl r11, r9 @r11 in proper location
	bx lr @return to setting
	
flex: @Add an event, flexible time

clear: @Clear out time

schedule: @Print a portion of the schedule

help: @Display help
	ldr r0, =full_help
	bl printf
	b loop @Return to the loop

exit: @Exit the program
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
	menu_help:	.asciz "\n5. Help"
	bye:		.asciz "\n6. Quit"
	choose_day:	.asciz "\nChoose Day: "
	start_time:	.asciz "\nChoose Start Time: "
	time_length	.asciz "\nHow long will the event last: "
	select:		.asciz "\n\nSelect a menu option> "
	done:		.asciz "\nExiting!"
	full_help	.asciz "\nWhen choosing a day, input a number 1-7, with Monday being equal to 1.\nWhen choosing a time, please input the hour only, and use military time.\nNo change will be made if there is overlap or if there is no possible way to fit a flexible event."
	format_select:	.asciz "%d"
	select_buff:	.word 0
