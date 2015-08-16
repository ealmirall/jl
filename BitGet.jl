function BitGet(i,nbit)
# BitGet    Returns the value of a certain bit  
# Returns:
#       0,1 	-> value of the bit 
# Inputs:
#       i       -> integer to consider
#		nbit	-> number of bit to consider

i=int32(i)

if (i & int32(2^(nbit-1))) >0
	return 1
else
	return 0
end

end
