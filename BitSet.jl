function BitSet(i,nbit,val)
# BitSet    Returns i with nbit set to val  
# Returns:
#       i 	-> 	i with nbit set to val 
# Inputs:
#       i 		-> integer to consider
#		nbit	-> number of bit to consider
#		val		-> value to set (0,1)

i=int32(i)

if val==1
	i=i|2^(nbit-1)
else
	i=i&~(2^(nbit-1))
end

return i

end
