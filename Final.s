#Tacuma Solomon
#02580808
#Computer Organization
#MIPS Program Assignment


#**************************************************************************************************************

	.data 
str0: .asciiz "Tacuma Solomon \n@02580808 \nComputer Organization \nMIPS Program \n\n\n"
str1: .asciiz "Please enter the first hexadecimal string: "     
str2: .asciiz "Please enter the second hexadecimal string : "
str3: .asciiz "Error. Incorrect Value entered "
str4: .asciiz "Done [Yes = 0, No = 1]: "
str5: .asciiz "The conversion total:   "
str6: .asciiz "The first number is larger than the second number. "
str7: .asciiz "The first number is less than the second number. "
str8: .asciiz "The two numbers are equal."
str9: .asciiz "The first string has illegal characters."
str10: .asciiz "The second string has illegal characters."
str11: .asciiz "One of the strings entered is empty."
newline: .asciiz "\n"  #This will cause the screen cursor to move to a newline
	theString:	
		.space 60
	theString1:
		.space 60
.align 2

.globl main			# leave this here for the moment
	.text			# This is an I/O sequence. Print the string 
			    	# labeled str1: to the console

#**************************************************************************************************************
 
		
main:
	la $a0, str0	    	# Output student information 
	li $v0, 4		      
	syscall  		# execute the syscall to perform input/output 

	
	la $a0, str1	    	# Output("Please enter the first hexadecimal string: ") 
	li $v0, 4		      
	syscall  		# execute the syscall to perform input/output
		       

	li $v0, 8         	# loads system call code 
	la $a0, theString	# read first hexdecimal value
	li $a1, 60
	syscall 

	sw $a0, 0($sp)		#stores value of first integer onto the stack

	la $a0, str2		# Load address of string 2 into register $a0
	li $v0, 4		# Load I/O code to print string to console
	syscall			# Output ("Please enter the second hexadecimal string :")


	li $v0, 8         	# loads system call code 
	la $a0, theString1	# read second hexadecimal value
	li $a1, 60
	syscall 	

	sw $a0, 4($sp)		#stores value of second integer onto the stack
	

	jal hexcmp		#jumps and links address to the hexcmp subprogram

	
	beq $v1, 0, output_larger 	# Branches to the output_larger print sequence if $v1=0
	beq $v1, 1, output_smaller 	# Branches to the output_smaller print sequence if $v1=1
	beq $v1, 3, output_equal 	# Branches to the output_equal print sequence if $v1=2
	beq $v1, 4, output_error1	# Branches to the output_error1 print sequence if $v1=3
	beq $v1, 5, output_error2	# Branches to the output_error2 print sequence if $v1=4	
	beq $v1, 6, output_error3
	
	output_larger:		la $a0, str6		# Outputs "The first number is larger than the smaller number. "
				li $v0, 4		# 
				syscall			# 
				j finish

	output_smaller:		la $a0, str7		# Outputs "The first number is less than the second number. "
				li $v0, 4		# 
				syscall			# 
				j finish
				
	output_equal:		la $a0, str8		# Outputs "The two numbers are equal."
			        li $v0, 4		# 
				syscall			# 
				j finish

	output_error1:		la $a0, str9		# Outputs "The first string has illegal characters."
			        li $v0, 4		# 
				syscall			# 
				j finish

	output_error2:		la $a0, str10		# Outputs "The second string has illegal characters."
			        li $v0, 4		# 
				syscall			# 
				j finish

	output_error3:		la $a0, str11		# Outputs "The second string has illegal characters."
			        li $v0, 4		# 
				syscall			# 
				j finish

	

		

finish:	la $a0, newline		# print the new line character to 			
	li $v0, 4		# make a blank line space 
	syscall 

	

	li $v0, 10		# syscall code 10 for terminating the program
	syscall

#******************************************************************************************************
# SubProgram hexcmp
#This subprogram calls the subprogram hex2dec 2 times, passing in 2 hexadecimal strings,  
#and manages the error codes and result values that are passed to the main program.
#******************************************************************************************************

hexcmp :   sw $ra, 8($sp)	#stores value of return address on the stack

	  lw $a0, 4($sp)  	#returns the value of the second string off of the stack
	  jal hex2dec		#calls hex2dec subprogram
	  lw $t6, 12($sp)	#loads the result off of the stack
	  


	  lw $a0,0($sp)		#returns the value of the first sring off of the stack 
	  jal hex2dec
	  lw $t5, 12($sp)
	  
	  
	  beq $t6, -2, input_error3    #branches to input_error3 if the second string contains no characters

	  beq $t5, -2, input_error3    #branches to input_error3 if the second string contains no characters
	 
	  beq $t6, -1, input_error2    #branches to input_error2 if the second string contains illegal characters

	  beq $t5, -1, input_error1    #branches to input_error1 if the first string contains illegal characters
	  
	  beq $t5, $t6, equal          #branches to equal if the 2 results are equal
		
	  slt $t7, $t5, $t6
	  
	  beq $t7, 0, bigger	    # branches to bigger if the first number is bigger than the second
	  beq $t7, 1, smaller	    # branches to smaller if the first number is smaller than the second




input_error1 :  addi $v1, 4	    # jumps to main program to output error message 1
	        j endhexcmp

input_error2 :  addi $v1, 5	    # jumps to main program to output error message 2
	        j endhexcmp	

input_error3 :  addi $v1, 6	    # jumps to the main program to output error message 3
		j endhexcmp	


equal  :  addi $t7, 3 
	  move $v1, $t7		    # jumps to main program to output that the 2 digits are equal
	  j endhexcmp		    
	
bigger :  move $v1, $t7		    # Jumps to the main program to output that the first digit is bigger
	  j endhexcmp


smaller:  move $v1, $t7 	    # Jumps to the main program to output that the first digit smaller than the second
	  j endhexcmp
	  

endhexcmp: lw $ra, 8($sp)
	   jr $ra




#*******************************************************************************************************
#Subprogram hex2dec
#This program converts the value of a hexadecimal string to that of an unsigned integer.
#it passes the result and error codes to hexcmp.
#*******************************************************************************************************

 	
		
hex2dec:	 
		la $t4,10	#loads ASCII value of the end of a string into a register
		la $v1,0        #sets the value of the sum to zero
		
		
      	 	move $t0, $a0    #loads read string into $t0



		#********************************************************************************************
		# This code strucure looks at the ASCII values of the first digit, to verify that it is legal,
		# by seeing the values from 0-9, a-f, and A-F, as valid, and exiting if it is not.
		#********************************************************************************************
	
       		lb $t1,($t0)         # load the ascii code of first digit in the string
		beq $t1, $t4, error2

		add   $t2, $t1, 0
		addi $t2, $t2, -48   # get the value of digit 0 
		bltz $t2, error1
	
		add   $t2, $t1, 0
		addi $t2, $t2, -57   # get the value of digit 0 
		blez $t2, integer_value
	
		add   $t2, $t1, 0
		addi $t2, $t2, -65   # get the value of digit 0 
		bltz $t2, error1
	
		add   $t2, $t1, 0
		addi $t2, $t2, -70   # get the value of digit 0 
		blez $t2, C_hex_value

		add   $t2, $t1, 0
		addi $t2, $t2, -97   # get the value of digit 0 
		bltz $t2, error1

		add   $t2, $t1, 0
		addi $t2, $t2, -102   # get the value of digit 0 
		blez $t2, hex_value	

		bgtz $t2, error1

		j end
	
		#*************************************************************************************
		#When the ASCII value is determined to be of valid character, the integer value is then 
		#calculated.
		#**************************************************************************************
 		integer_value:   addi $t1, $t1, -48   # get the value of digit 0 
       	 	 		 add $v1, $v1, $t1     # add to the total
				 add $t0,1
				 j next
	
		C_hex_value:   addi $t1, $t1, -55   # get the value of digit 0 
        			add $v1, $v1, $t1     # add to the total
				add $t0,1
				j next
	
	
		hex_value:   	addi $t1, $t1, -87   # get the value of digit 0 
        			add $v1, $v1, $t1     # add to the total
				add $t0,1
				j next




		#********************************************************************************************
		# This code strucure appears again, but this time in a loop, to make sure that all further digits in
		# the string is it's proper value. 
		#********************************************************************************************

 	next:   lb $t1, ($t0)        # load the ascii code of digit n 
	        beq $t1, $t4, end    # jumps to the end of the subprogram when the end of the string is reached
		
		
		add   $t2, $t1, 0
		addi $t2, $t2, -48   # get the value of digit 0 
		bltz $t2, error1
	
		add   $t2, $t1, 0
		addi $t2, $t2, -57   # get the value of digit 0 
		blez $t2, integer_value1
	
		add   $t2, $t1, 0
		addi $t2, $t2, -65   # get the value of digit 0 
		bltz $t2, error1

		add   $t2, $t1, 0
		addi $t2, $t2, -70   # get the value of digit 0 
		blez $t2, C_hex_value1

		add   $t2, $t1, 0
		addi $t2, $t2, -97   # get the value of digit 0 
		bltz $t2, error1

		add   $t2, $t1, 0
		addi $t2, $t2, -102   # get the value of digit 0 
		blez $t2, hex_value1	

		bgtz $t2, error1

		#*****************************************************************************************
		#As we have seen before, one we know that the ASCII value is valid, we then determine each 
		#character's integer value, and proceed calulate the integer value of the hexadecimal string.
		#*****************************************************************************************

 		integer_value1:  addi $t1, $t1, -48   # get the value of digit 0  #returns a number's (0-9) integer value
			 	 mul $v1, $v1, 16     # multiply Total by 16	
       	 		 	 add $v1, $v1, $t1    # add to the total
			 	 add $t0,1
			 	 j next
	
		C_hex_value1:   addi $t1, $t1, -55   # get the value of digit 0    #returns a capital hex character's integer value (A-F)
				mul $v1, $v1, 16     # multiply Total by 16
        			add $v1, $v1, $t1    # add to the total 
				add $t0,1
				j next
	
		hex_value1:     addi $t1, $t1, -87   # get the value of digit 0    #returns a common hex character's integer value (a-f)
				mul $v1, $v1, 16     # multiply Total by 16 
        			add $v1, $v1, $t1    # add to the total
				add $t0,1
				j next
	

	

		#********************************************************************************


	
   		error1:  add $t8, 0, -1	      #  returns error value if illegal digit is entered
			 sw $t8, 12($sp)
			 jr $ra	
			
	    	
   		error2:  add $t8, 0, -2	      #  returns error value if one of the fields are empty
			 sw $t8, 12($sp)
			 jr $ra	

  		 end:	la $a0, str5          #  TO SEE THE INTEGER VALUE OF ENTERED HEXADECIMAL,
			li $v0, 4	      #   UNCOMMENT THIS BLOCK OF CODE
			syscall 

			move $a0, $v1	 		
			li $v0, 1
			syscall
 			
			sw $v1, 12($sp)       #  Places the integer value into the stack
			
			la $a0, newline	      #  print the new line character 			
			li $v0, 4
			syscall 
		
	
			jr $ra		#retuns to hexcmp
		#*********************************************************************************





