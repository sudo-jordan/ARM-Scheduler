@scheduler.s
@Created by Jordan Saleh and William Daniel Vasquez
@R2-8 are used to hold data for days of the week
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
	ldr r1, =select_buff
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

@ if input is 5, show help
	cmp r1, #5
	beq help
	
@ if input is 6, quit the program
	cmp r1, #6
	beq exit
	
	b main @If none of the above are entered, restart loop

takeInput:
	push {lr}
	ldr r0, =start_time
        bl printf
        ldr r0, =format_select
        ldr r1, =select_buff
        bl scanf
        ldr r1, =select_buff
        ldr r1, [r1]
        mov r9, r1 @Copy input to r9, this will be the start time
        @Take another input, same as before, use time_length for a prompt
        ldr r0, =time_length
        bl printf
        ldr r0, =format_select
        ldr r1, =select_buff
	bl scanf
        ldr r1, =select_buff
        ldr r1, [r1]
        mov r10, r1 @Copy input to r10, this will be the length of the event
        @Take another input, same as before, use choose_day for a prompt
        ldr r0, =choose_day
        bl printf
        ldr r0, =format_select
        ldr r1, =select_buff
	bl scanf
        ldr r1, =select_buff
        ldr r1, [r1]
        bl createTimeSlot @call to createTimeSlot
	pop {lr}
	bx lr @Return to either set or clear

set: @Add an event, set time
        bl takeInput @take input, sets day choice to r1 and time mask to r11
	
	cmp r1, #1 @Monday edit
	bl mondayEdit
	b main
	cmp r1, #2 @Tuesday edit
	bl tuesdayEdit
	b main
	cmp r1, #3 @Wednesday edit
	bl wednesdayEdit
	b main
	cmp r1, #4 @Thursday edit
	bl thursdayEdit
	b main
	cmp r1, #5 @Friday edit
	bl fridayEdit
	b main
	cmp r1, #6 @Saturday edit
	bl saturdayEdit
	b main
	cmp r1, #7 @Sunday edit
	bl sundayEdit
	b main
	
clear: @clear time out
	bl takeInput @take input, sets day choice to r1 and a time mask to r11
	ldr r12, =#0xFFFFFFFF
	eor r11, r12 @Inverts r11
	
	cmp r1, #1 @Monday clear
	bl mondayClear
	b main
	cmp r1, #2 @Tuesday clear
	bl tuesdayClear
	b main
	cmp r1, #3 @Wednesday clear
	bl wednesdayClear
	b main
	cmp r1, #4 @Thursday clear
	bl thursdayClear
	b main
	cmp r1, #5 @Friday clear
	bl fridayClear
	b main
	cmp r1, #6 @Saturday clear
	bl saturdayClear
	b main
	cmp r1, #7 @Sunday clear
	bl sundayClear
	b main
	
mondayEdit:
	push {lr}
	mov r9, r2 @Setup for check
	bl overlapCheck 
	orreq r2, r11
	pop {lr}
	bx lr
	
mondayClear:
	and r2, r11
	bx lr
	
tuesdayEdit:
	push {lr}
	mov r9, r3 @Setup for check
	bl overlapCheck 
	orreq r3, r11
	pop {lr}
	bx lr
	
tuesdayClear:
	and r3, r11
	bx lr

wednesdayEdit:
	push {lr}
	mov r9, r4 @Setup for check
	bl overlapCheck 
	orreq r4, r11
	pop {lr}
	bx lr
	
wednesdayClear:
	and r4, r11
	bx lr

thursdayEdit:
	push {lr}
	mov r9, r5 @Setup for check
	bl overlapCheck 
	orreq r5, r11
	pop {lr}
	bx lr
	
thursdayClear:
	and r5, r11
	bx lr

fridayEdit:
	push {lr}
	mov r9, r6 @Setup for check
	bl overlapCheck 
	orreq r6, r11
	pop {lr}
	bx lr

fridayClear:
	and r6, r11
	bx lr
	
saturdayEdit:
	push {lr}
	mov r9, r7 @Setup for check
	bl overlapCheck 
	orreq r7, r11
	pop {lr}
	bx lr
	
saturdayClear:
	and r7, r11
	bx lr

sundayEdit:
	push {lr}
	mov r9, r8 @Setup for check
	bl overlapCheck 
	orreq r8, r11 @Only edit if there is no overlap
	pop {lr}
	bx lr
	
sundayClear:
	and r8, r11
	bx lr

createTimeSlot: @Creates a mask for editing time slots, r11
	ldr r11, =#0xFFFFFFFF @reset time slot
	mov r12, #32 @Number of bits
	sub r12, r10 @Desired shift
	lsl r11, r12 @r11 now has 1 bits equal to r10
	lsr r11, r12 @Fully right-shifted
	lsl r11, r9 @r11 in proper location
	bx lr @return to takeInput
	
overlapCheck: @Check to ensure there is no overlap
	mov r10, r9 @Copy into r10
	mov r12, r9 @Copy into r12
	orr r12, r11 
	eor r10, r11
	cmp r12, r10 @Exclusive or and or should be equal if there is no overlap
	bx lr
	
flex: @Add an event, flexible time

schedule: @Print a portion of the schedule

help: @Display help
	ldr r0, =full_help
	bl printf
	b main @Return to the loop

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
	time_length:	.asciz "\nHow long will the event last: "
	select:		.asciz "\n\nSelect a menu option> "
	done:		.asciz "\nExiting!"
	full_help:	.asciz "\nWhen choosing a day, input a number 1-7, with Monday being equal to 1.\nWhen choosing a time, please input the hour only, and use military time.\nNo change will be made if there is overlap or if there is no possible way to fit a flexible event."
	format_select:	.asciz "%d"
	select_buff:	.word 0
