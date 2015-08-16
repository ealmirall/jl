include("BestStrategy.jl")
include("Fitness.jl")
include("BitGet.jl")
include("BitSet.jl")

#--------------------------------------------------------------------------
function Simula(strategy,ag,aex...)
# Simula    Performs a simulation depending on the Strategy
#				-> strategy=1 - Hill Climbing
# 				-> strategy=2 - Hill Climbing with info about avg Fitness of the Landscape
# Returns:
#       ag 			->	strucutre of agents
#		bestCases	->  final benchmark
# Inputs:
#		strategy	->	0= Hill Clmibing - used as a baseline
#						1= Hill Climbing with restricted bits
#						2= Hill Climbing with explorers using max fitness found w restricted bits
#						3= Hill Climbing with explorers using avg fitness found w restricted bits
#						4= Hill Climbing using Best Cases from explorers
#						5= Hill Climbing from Best Cases extracted from the agents themselves
#		ag			->	structure of agents
#		aex			->	structure of the explorers or number of array of agents to consider for Best Cases

#		required global variables
#			landscape 	-> the vector representing the landscape
#       	N 			-> number of different components of the Strategy
#       	K 			-> number of components of wich every single component depends on


global landscape
global N, K

global nBestCases

global _fixbits, _freebits,_fixval
global _dpivot

dosaN=2^N
dosaK1=2^(K+1)

nagents=size(ag,1)


if strategy==1 || strategy==0
	# Do Hill Climbing 
	canvi=true

	while canvi
		canvi=false
		for i=1:nagents
			if strategy==0
				newStg=BestStrategy(strategy, ag[i],[1:N])
			else
				newStg=BestStrategy(strategy, ag[i], _freebits)
			end
			if newStg != ag[i].stg
				ag[i].stg=newStg
				canvi=true
			end
		end
	end
	return ag
end

if (strategy==2 || strategy==3 || strategy==4)
	# Do Hill Climbing with Explorers with the max fitness found by the explorers
	ex=aex[1]
	e=size(ex,1)
	if (strategy==2 || strategy==3)
		avgEx=0
		for i=1:e
			if strategy==2
				if Fitness(ex[i].stg)>avgEx
					avgEx=Fitness(ex[i].stg)
				end
			else			
				avgEx=avgEx+Fitness(ex[i].stg)
			end
		end
		if strategy==3
			avgEx=avgEx/e
		end
#		@printf("avgEx %4f\n",avgEx)
	else
		#Select the best cases found by explorers
		bestCases=zeros(e)
		for i=1:e
			bestCases[i]=Fitness(ex[i].stg)
		end
		bestCases=sort(bestCases,rev=true)
	end
			
	canvi=true

	while canvi
		canvi=false
		if _dpivot>0
			#find minimum fitness
			_minfit=9.0
			for i=1:nagents
				if Fitness(ag[i].stg)<_minfit
					_minfit=Fitness(ag[i].stg)
				end
			end
		end 
		for i=1:nagents
			if ag[i].nPivot<ag[i].mPivot	
				newStg=BestStrategy(strategy, ag[i], _freebits)
				if newStg != ag[i].stg
					ag[i].stg=newStg
					canvi=true
					ag[i].nPivot=ag[i].nPivot+1
				else
#					@printf("agent %2d tBCase %2d nPivot %2d mPivot %2d \n",i,ag[i].tBCase,ag[i].nPivot,ag[i].mPivot)
					if ((strategy== 2 || strategy==3) && avgEx-Fitness(newStg)>eps()) ||
						( strategy==4 && Fitness(newStg)<bestCases[ag[i].tBCase] ) 
#						@printf("Old strategy %7f New strategy %7f",ag[i].stg,newStg)
#						@printf("Aixo no hauria de passar Fitness(newStg) %7f avgEx %7f dif %7f \n",Fitness(newStg),avgEx,avgEx-Fitness(newStg))
						# Jump
						_jump=false
						if _dpivot==0
							#greedy
							_jump=true
						else 
							#only 1 proportional negative is considered
							if (strategy==2 || strategy ==3)
								_p=(Fitness(ag[i].stg)-_minfit)/(avgEx-_minfit)
							else 
								_p=(Fitness(ag[i].stg)-_minfit)/(bestCases[ag[i].tBCase]-_minfit)
							end 
							_p=1-_p
							if rand()<=_p 
								_jump=true
							end
						end
						if _jump==true
							btC=int(rand()*4)+2	#bt 2..6 bits
							for j=1:btC
								bC=int(rand()*(length(_freebits)-1))+1 
								if BitGet(ag[i].stg,_freebits[bC])==0	# Flip
									ag[i].stg=BitSet(ag[i].stg,_freebits[bC],1)
								else
									ag[i].stg=BitSet(ag[i].stg,_freebits[bC],0)
								end
							end
							canvi=true
							ag[i].nPivot=ag[i].nPivot+1
						end
					end
				end
			end
		end
	end
	return ag
end

if (strategy==5)
	# Do Hill Climbing using Best Cases crowdsourced from the agents themselves
	ex=aex[1]
	e=size(ex,1)
	bestCases=zeros(e)
	for i=1:e
		bestCases[i]=Fitness(ag[ex[i]].stg)
	end
	bestCases=sort(bestCases,rev=true)

	
#	for i=1:length(bestCases)
#		@printf("Best Case %2d %2.5f \n",i,bestCases[i])
#	end	
	
	avgF=0
	for i=1:nagents
		avgF=avgF+Fitness(ag[i].stg) 
	end
	avgF=avgF/nagents
#	 @printf("Init %3d Average fitness of Best Cases %2.5f Agents %2.5f\n",e,mean(bestCases[1:5]),avgF)
			
	canvi=true
	njump=0

	while canvi
		canvi=false
		if _dpivot>0
			#find minimum fitness
			_minfit=9.0
			for i=1:nagents
				if Fitness(ag[i].stg)<_minfit
					_minfit=Fitness(ag[i].stg)
				end
			end
		end 
#		@printf("We have _minfit \n")

		for i=1:nagents
			if ag[i].nPivot<ag[i].mPivot	
				newStg=BestStrategy(strategy, ag[i], _freebits)
				if newStg != ag[i].stg
					ag[i].stg=newStg
					canvi=true
				else
#					@printf("Are we going to jump? Fitness(newStg) %5f bestCases[ag[i].tBCase] %5f \n",Fitness(newStg),bestCases[ag[i].tBCase])
					if Fitness(newStg)<bestCases[ag[i].tBCase]
#					@printf("Are we going to jump 2?\n")	
#					@printf("agent %2d tBCase %2d nPivot %2d mPivot %2d \n",i,ag[i].tBCase,ag[i].nPivot,ag[i].mPivot)
#					@printf("Fitness(newStg) %4f bestCases[ag[i].tBCase] %4f \n",Fitness(newStg),bestCases[ag[i].tBCase])
						# Jump
						_jump=false
						if _dpivot==0
							#greedy
							_jump=true
						else 
							#only 1 proportional negative is considered
							_p=(Fitness(ag[i].stg)-_minfit)/(bestCases[ag[i].tBCase]-_minfit)
						end 
						_p=1-_p
						if rand()<=_p 
							_jump=true
						end
						if _jump==true
							btC=int(rand()*4)+2	#bt 2..6 bits
							for j=1:btC
								bC=int(rand()*(length(_freebits)-1))+1 
								if BitGet(ag[i].stg,_freebits[bC])==0	# Flip
									ag[i].stg=BitSet(ag[i].stg,_freebits[bC],1)
								else
									ag[i].stg=BitSet(ag[i].stg,_freebits[bC],0)
								end
							end
							canvi=true
							ag[i].nPivot=ag[i].nPivot+1
							njump=njump+1
						end 
					end
				end
			end 
		end

		bestCases=zeros(e)
		for i=1:e
			bestCases[i]=Fitness(ag[ex[i]].stg)
		end
		bestCases=sort(bestCases,rev=true)

	end
#	avgF=0	
#	for i=1:nagents
#		avgF=avgF+Fitness(ag[i].stg) 
#	end
#	avgF=avgF/nagents
	# @printf(" ...     Average fitness of Best Cases %2.5f Agents %2.5f jumps %4d\n",mean(bestCases[1:5]),avgF,njump)
#	for i=1:nagents
#		if Fitness(ag[i].stg)<bestCases[ag[i].tBCase]
			#tobat
#			@printf(">>> agent %3d fitness %2.4f tBCase %2d fitness Best Case %2.4f nPivots %3d maxPivots %3d \n",
#			i,Fitness(ag[i].stg),ag[i].tBCase,bestCases[ag[i].tBCase],ag[i].nPivot,ag[i].mPivot)
#		end
#	end

#	return ag, bestCases[1:nBestCases]
	return ag

end

end