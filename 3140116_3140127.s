

.data
	enterPostMsg: .asciiz " Postfix (input) : "
	divisionMsg: .asciiz "  \n You can not divide by zero!!  "
	invalidPostMsg: .asciiz " \n Invalid Postfix "
	resultMsg : .asciiz " \n Postfix Evoluotion (output):"
	
	
	
	
.text
.globl main

main: 
	
	# prints the enterPostMsg: "

	li $v0, 4
	la $a0,enterPostMsg
	syscall
	
	# $t0 is the stack pointer (i=0)
	
	li $t0,0
	
	
readChar:
	# reads the char

	li $v0,12
	syscall
	
	# stores the char in $t1

	move $t1,$v0 
	
	beq $t1,61,exit # if ($t1 == "=") branches to exit
	bne $t1,32,valueNumber # if ($t1 != "space") branches to valueNumber
	j readChar
	
	
valueNumber:
	li $t2,0 # number=0
		
whileLoop: 
	beq $t1,32,push
	bge $t1,48,calculation
	ble $t1,57,findWhatIs
	beq $t1,61,exit


	# Case 1 : $t1 == 42 ("*") branch to multiplication
	# Case 2 : $t1 == 43 ("+") branch to addition
	# Case 3 : $t1 == 45  ("-") branch to subtraction
	# Case 4 : $t1 == 47 ("/") branch to division
	# Case 5 : $t1 is anything else than the above branch to exit 
	# Case 6 : $t1 >=48 (0 .. 9)  the program continues to calculation
	
findWhatIs:
	beq $t1,42,multiplication
	beq $t1,43,addition
	beq $t1,45,subtraction
	beq $t1,47,division
	blt $t1,48,exit 

calculation: 
	
	# if $t1 >=65 branches to exit as the user pressed letters or other sumbols
	 
	bge $t1,65,exit 
	
	# calculates the number 
	
	mul $t2,$t2,10
	sub $t1,$t1,48
	add $t2,$t2,$t1
	
	# move the value of $t2 to $t3
	
	move $t3,$t2
        
        # reads a char
        
        li $v0, 12
        syscall
        move $t1, $v0
	j whileLoop
	
# multiplies the numbers

multiplication:	
	jal pop
	move $t5, $t4
	jal pop
	mul $t3, $t4, $t5
	j push # push the result back in stack

# adds the numbers 

addition:
	jal pop
	move $t5,$t4
	jal pop
	add $t3,$t4,$t5
	j push # push the result back in stack

# subtracts the numbers

subtraction: 
	jal pop
	move $t5,$t4
	jal pop 
	sub $t3,$t4,$t5
	j push # push the result back in stack
	
# divides the numbers
# if $t5 == 0 then branches to check

division: 
	jal pop
	move $t5,$t4
	jal pop
	beq $t5,0,check # if the second char is zero, branch to check else continue 
	div $t3,$t4,$t5
	j push # push the result back in stack
	
# pop the numbers from the stack to calculate the result (add,subtract,multiply or divide)

pop:  
	lw $t4,0($sp) 
	addi $sp,$sp,4
	addi $t0, $t0, -1
	jr $ra
	
# push the numbers in stack
# after the calculation, push again the result of each one calculation and the final result in the end

push: 
	addi $sp,$sp,-4
	sw $t3,0($sp)
	addi $t0, $t0, 1
	j readChar 
	
	
check: 
	# the second char is zero
	# prints divisionMsg
	# end of program
	
	la $a0, divisionMsg
	li $v0, 4
	syscall
	li $v0,10
	syscall
	
exit: 	
	beq $t0,0,invalid #if $t0==0 branches to invalid 
	#prints result
	la $a0, resultMsg
	li $v0, 4
	syscall
	lw $t3,0($sp)
	move $a0, $t3
	li $v0, 1
	syscall
	li $v0,10
	syscall

# if $t0==0 means that the stack is empty , the user entered "=" 
invalid:
	la $a0, invalidPostMsg
	li $v0, 4
	syscall
	li $v0,10
	syscall

	
	
	
	
	
