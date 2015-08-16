include("ListStrategies.jl")
include("Fitness.jl")

function BestStrategy(strategy,ag,iN) 
# BestStrategy - Looks for the best possible strategy of the agents 
#Return 
#   newStg  ->  New Strategy to implement
#Inputs
#   strategy->  1)Incremental + greedy (max fitness)
#               2)Incremental + fitter (better fitness with fitness' prob.)
#               3)Pattern selection
#   ag      ->  Agent to be considered
#   iN       ->  Range of bits to consider e.g. beginning:end (depends if some components are fixed ...)

maxFit=Fitness(ag.stg)
newStg=ag.stg

#if (strategy == 1 || strategy == 2 || strategy==3 || strategy==4 || strategy==5)

	# Incremental + gready
    lStg=ListStrategies(ag.stg,iN,1)

    for lS=1:size(lStg)[1]
		if (Fitness(lStg[lS]) > maxFit)
        	newStg=lStg[lS]
            maxFit=Fitness(lStg[lS])
    	end
    end
#end
return newStg
end
