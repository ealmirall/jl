function Fitness(stg)
# Fitness    Returns the fitness of an strategy  
# Returns:
#       fit -> fitness corresponding to the strategy of the agent
#				corresponds to the strategy of the agent + 1 into the landscape
# Inputs:
#       stg       -> strategy of the agent

global landscape

fit=landscape[stg+1]

return fit

end
