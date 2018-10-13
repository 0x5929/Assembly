#!/usr/bin/python


# Purpose: 
#		1. To reverse a given string
#		2. to encode the reversed string in hex
#		3. to count string in hex and in character
#		4. to print out hex representation for every 4 bytes or 8 hex characters




import sys


input_string = sys.argv[1]				# grab input 


print 'String length : ' + str(len(input_string))	# print input string length



string_list = []

for i in range(0, len(input_string), 8):		# divide input string up to 8 characters at a time, instead of 4 like in 32 bit
	string_list.append(input_string[i:i+8])


for item in string_list[::-1]:				# to reverse each of the string_list and the entire list itself
	print item[::-1] + ' : ' + str(item[::-1].encode('hex'))
