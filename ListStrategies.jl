function ListStrategies(stgO,iN,M)
# ListStrategies From a given strategy, lists all strategies that differ in M or less components 
# Returns:
# 	lStg -> vector with all possible strategies
# Inputs:
# 	stgO -> original strategy
# 	iN -> elements (bits) to be considered in the set
# 	M -> maximum number of components in wich strategies can differst=1;

xM=M

lStg=zeros(Int,1)

if (xM>size(iN,1))
	xM=size(iN,1)
end

for i=1:xM
	combi=collect(combinations(iN,i))
	n_combi=size(combi,1)
	s_combi=size(combi[1],2)
 
 	for j=1:n_combi
 		n_stg=stgO
 		for t=1:s_combi
	
			if (n_stg & 2^(combi[j,t][1]-1)) == 0
 			# if (bitget(n_stg,combi[j,t])==0)
				n_stg=(n_stg | 2^(combi[j,t][1]-1))
 				# n_stg=bitset(n_stg,combi[j,t]);
 			else
				n_stg=(n_stg $ 2^(combi[j,t][1]-1))
 				# n_stg=bitset(n_stg,combi[j,t],0);
 			end
 		end

		if i==1 && j==1	# first time
			lStg[1]=n_stg
		else
 			push!(lStg,n_stg)
		end
 	end
end

return lStg
end