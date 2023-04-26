@scheduler.s
@Created by Jordan Saleh and William Daniel Vasquez
@R2-8 are used to hold data for days of the week
.global main
main:
mov r4, #0
mov r5, #0
mov r6, #0
mov r7, #0
mov r8, #0
mov r9, #0
mov r10, #0
b loop

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

	b loop @If none of the above are entered, restart loop

takeInput:
	push {lr}
	ldr r0, =start_time
        bl printf
        ldr r0, =format_select
        ldr r1, =select_buff
        bl scanf
        ldr r1, =select_buff
        ldr r1, [r1]
        mov r11, r1 @Copy input to r11, this will be the start time
        @Take another input, same as before, use time_length for a prompt
        ldr r0, =time_length
        bl printf
        ldr r0, =format_select
        ldr r1, =select_buff
	bl scanf
        ldr r1, =select_buff
        ldr r1, [r1]
        mov r12, r1 @Copy input to r12, this will be the length of the event
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
	bleq mondayEdit
	beq loop
	cmp r1, #2 @Tuesday edit
	bleq tuesdayEdit
	beq loop
	cmp r1, #3 @Wednesday edit
	bleq wednesdayEdit
	beq loop
	cmp r1, #4 @Thursday edit
	bleq thursdayEdit
	beq loop
	cmp r1, #5 @Friday edit
	bleq fridayEdit
	beq loop
	cmp r1, #6 @Saturday edit
	bleq saturdayEdit
	beq loop
	cmp r1, #7 @Sunday edit
	bleq sundayEdit
	b loop
	
clear: @clear time out
	bl takeInput @take input, sets day choice to r1 and a time mask to r11
	ldr r2, =#0xFFFFFFFF
	eor r11, r2 @Inverts r11
	
	cmp r1, #1 @Monday clear
	andeq r4, r11
	beq loop
	cmp r1, #2 @Tuesday clear
	andeq r5, r11
	beq loop
	cmp r1, #3 @Wednesday clear
	andeq r6, r11
	beq loop
	cmp r1, #4 @Thursday clear
	andeq r7, r11
	beq loop
	cmp r1, #5 @Friday clear
	andeq r8, r11
	beq loop
	cmp r1, #6 @Saturday clear
	andeq r9, r11
	beq loop
	cmp r1, #7 @Sunday clear
	andeq r10, r11
	beq loop
	
flex: @Add an event, flexible time
	ldr r0, =time_length
        bl printf
        ldr r0, =format_select
        ldr r1, =select_buff
	bl scanf
        ldr r1, =select_buff
        ldr r1, [r1]
	mov r11, #0 @set start time at 0
	mov r12, r1 @copy input into r12
	bl createTimeSlot @Fully right-shifted time slot in r11
	mov r3, #0
	b flexCheck
	
flexCheck: @Check the first time slot for each day, attempting an edit. If none found, lsl r0 and check next time slot. Loop until all slots checked.
	cmp r3, #23
	ldreq r0, =no_time
	bleq printf
        beq loop
	
	bl mondayEdit @Attempt to edit Monday
	cmp r11, r4 @Check to see if r2 has been edited
	moveq r1, r0 @save the count to r12 for safekeeping
	ldreq r0, =flex_monday @Confirm placement
	bleq printf
	@Add in a print of r12 here, so that it will say what time slot the event was placed in. Make sure you add eq to the end of every instruction
	beq loop
	
	bl tuesdayEdit @Attempt to edit Tuesday
	cmp r11, r5 @Check to see if r3 has been edited
	moveq r1, r0 @save the count to r12 for safekeeping
	ldreq r0, =flex_tuesday @Confirm placement
	bleq printf
	@Add in a print of r12 here, so that it will say what time slot the event was placed in. Make sure you add eq to the end of every instruction
	beq loop
	
	bl wednesdayEdit @Attempt to edit Wednesday
	cmp r11, r6 @Check to see if r4 has been edited
	moveq r1, r0 @save the count to r12 for safekeeping
	ldreq r0, =flex_wednesday @Confirm placement
	bleq printf
	@Add in a print of r12 here, so that it will say what time slot the event was placed in. Make sure you add eq to the end of every instruction
	beq loop
	
	bl thursdayEdit @Attempt to edit Thursday
	cmp r11, r7 @Check to see if r5 has been edited
	moveq r1, r0 @save the count to r12 for safekeeping
	ldreq r0, =flex_thursday @Confirm placement
	bleq printf
	@Add in a print of r12 here, so that it will say what time slot the event was placed in. Make sure you add eq to the end of every instruction
	beq loop
	
	bl fridayEdit @Attempt to edit friday
	cmp r11, r8 @Check to see if r6 has been edited
	moveq r1, r0 @save the count to r12 for safekeeping
	ldreq r0, =flex_friday @Confirm placement
	bleq printf
	@Add in a print of r12 here, so that it will say what time slot the event was placed in. Make sure you add eq to the end of every instruction
	beq loop
	
	bl saturdayEdit @Attempt to edit Saturday
	cmp r11, r9 @Check to see if r7 has been edited
	moveq r1, r0 @save the count to r12 for safekeeping
	ldreq r0, =flex_saturday @Confirm placement
	bleq printf
	@Add in a print of r12 here, so that it will say what time slot the event was placed in. Make sure you add eq to the end of every instruction
	beq loop
	
	bl sundayEdit @Attempt to edit Sunday
	cmp r11, r10 @Check to see if r8 has been edited
	moveq r1, r0 @save the count to r12 for safekeeping
	ldreq r0, =flex_sunday @Confirm placement
	bleq printf
	@Add in a print of r12 here, so that it will say what time slot the event was placed in. Make sure you add eq to the end of every instruction
	beq loop
	
	adds r0, #1 @Increment time slot counter
	lsl r0, #1 @If no open time slots found, shift one time slot over
	b flexCheck

schedule: @Print a portion of the schedule
	ldr r0, =choose_sched
	bl printf
	ldr r0, =format_select
	ldr r1, =select_buff
	bl scanf
	ldr r1, =select_buff
	ldr r1, [r1]

	cmp r1, #1
	ldreq r0, =print_mon
	bleq printf
	ldreq r0, =format_select
	moveq r1, r4
	bleq printf
	beq loop

	cmp r1, #2
	moveq r1, r5
	ldreq r0, =print_tues
	bleq printf
	ldreq r0, =select_buff
	bleq printf
	beq loop

	cmp r1, #3
	moveq r1, r6
	ldreq r0, =print_wed
	bleq printf
	ldreq r0, =select_buff
	bleq printf
	beq loop

	cmp r1, #4
	moveq r1, r7
	ldreq r0, =print_thurs
	bleq printf
	ldreq r0, =select_buff
	bleq printf
	beq loop

	cmp r1, #5
	moveq r1, r8
	ldreq r0, =print_fri
	bleq printf
	ldreq r0, =select_buff
	bleq printf
	beq loop

	cmp r1, #6
	moveq r1, r9
	ldreq r0, =print_sat
	bleq printf
	ldreq r0, =select_buff
	bleq printf
	beq loop

	cmp r1, #7
	moveq r1, r10
	ldreq r0, =print_sun
	bleq printf
	ldreq r0, =select_buff
	bleq printf
	beq loop

mondayEdit:
	push {lr}
	mov r2, r4 @Setup for check
	bl overlapCheck 
	orreq r4, r11
	pop {lr}
	bx lr
	
tuesdayEdit:
	push {lr}
	mov r2, r5 @Setup for check
	bl overlapCheck 
	orreq r5, r11
	pop {lr}
	bx lr

wednesdayEdit:
	push {lr}
	mov r2, r6 @Setup for check
	bl overlapCheck 
	orreq r6, r11
	pop {lr}
	bx lr

thursdayEdit:
	push {lr}
	mov r2, r7 @Setup for check
	bl overlapCheck 
	orreq r7, r11
	pop {lr}
	bx lr

fridayEdit:
	push {lr}
	mov r2, r8 @Setup for check
	bl overlapCheck 
	orreq r8, r11
	pop {lr}
	bx lr
	
saturdayEdit:
	push {lr}
	mov r2, r9 @Setup for check
	bl overlapCheck 
	orreq r9, r11
	pop {lr}
	bx lr

sundayEdit:
	push {lr}
	mov r2, r10 @Setup for check
	bl overlapCheck 
	orreq r10, r11 @Only edit if there is no overlap
	pop {lr}
	bx lr

createTimeSlot: @Creates a mask for editing time slots, r11
	ldr r0, =#0xFFFFFFFF @reset time slot
	mov r2, #32 @Number of bits
	sub r2, r12 @Desired shift
	lsl r0, r2 @r0 now has 1 bits equal to r12
	lsr r0, r2 @Fully right-shifted
	lsl r0, r11 @r0 in proper location
	mov r11, r0 @save in r11
	bx lr @return to takeInput
	
overlapCheck: @Check to ensure there is no overlap
	mov r0, r2 @Copy into r0
	mov r1, r11 @Copy into r1
	orr r0, r1
	eor r0, r1
	cmp r0, r1 @Exclusive or and or should be equal if there is no overlap
	bx lr

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
	time_length:	.asciz "\nHow long will the event last: "
	select:		.asciz "\n\nSelect a menu option> "
	done:		.asciz "\nExiting!"
	full_help:	.asciz "\nWhen choosing a day, input a number 1-7, with Monday being equal to 1.\nWhen choosing a time, please input the hour only, and use military time.\nNo change will be made if there is overlap or if there is no possible way to fit a flexible event."
	no_time:	.asciz "\nNo time slots found for this event."
	flex_monday:	.asciz "\nThis event has been placed on Monday at time slot %d\n"
	flex_tuesday:	.asciz "\nThis event has been placed on Tuesday at time slot %d\n"
	flex_wednesday:	.asciz "\nThis event has been placed on Wednesday at time slot %d\n"
	flex_thursday:	.asciz "\nThis event has been placed on Thursday at time slot %d\n"
	flex_friday:	.asciz "\nThis event has been placed on Friday at time slot %d\n"
	flex_saturday:	.asciz "\nThis event has been placed on Saturday at time slot %d\n"
	flex_sunday:	.asciz "\nThis event has been placed on Sunday at time slot %d\n"
	choose_sched:	.asciz "\nWhich day of your schedule would you like to print? > "
	print_mon:      .asciz "\nMonday: "
        print_tues:     .asciz "\nTuesday: %d\n"
        print_wed:      .asciz "\nWednesday: %d\n"
        print_thurs:    .asciz "\nThursday: %d\n"
        print_fri:      .asciz "\nFriday: %d\n"
        print_sat:      .asciz "\nSaturday: %d\n"
        print_sun:      .asciz "\nSunday: %d\n"
	format_select:	.asciz "%d"
	select_buff:	.word 0
