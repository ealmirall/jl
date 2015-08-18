include("../CreaLandscape.jl")
include("../BestStrategy.jl")
include("../Fitness.jl")
include("../Simula.jl")

global landscape, N, K

global _fixbits, _freebits,_fixval

global _dpivot

_dpivot=1	#probability to jump proportional to the distance to bench


N=16
K=0
nBestCases=1
maxPivots=10
_niter=0


nagents=100
ntries=500
strategy=4	# Strategy of the agents 3 cases
estrategy=1 # Strategy of the exploreres

#Fix bits and assign them a value
_nfixbits=0
_fixbits=randperm(N)
_freebits=_fixbits[1:end-_nfixbits]
_fixbits=_fixbits[end-(_nfixbits-1):end]

_fixval=int(zeros(_nfixbits))
for i in [1:_nfixbits]
	_fixval[i]=int(rand())
end 


ftime=time()

fOut=open("Static10-f"strftime("%Y-%m-%d %H:%S", ftime)".dat","w+")
fOutCsv=open("Static10-f"strftime("%Y-%m-%d %H:%S", ftime)".csv","w+")
fOutCsvD=open("StaticD10-f"strftime("%Y-%m-%d %H:%S", ftime)".csv","w+")

write(fOutCsv,"N.Iterations, #Explorers, K, #Simu, Mean Fitness, Std Fitness\n")
write(fOutCsvD,"N.Iterations, #Explorers, K, #Simu, #Agent, Fitness\n")


ne=7
avgFit=zeros(ne,N,ntries)

type agent
	stg::Int64
	tBCase::Int32
	mPivot::Int32
	nPivot::Int32
end

ag=Array(agent,nagents)
aFitness=zeros(nagents)

ne=1
for e=[-1 0 5 10 25 50 100]
#for e=[5 10 25 50 100]

	for K=0:N-1
		@printf("Explorers %2d NKtest K=%2d \n",e,K)
		flush(STDOUT)
		for t=1:ntries
#			@printf("Explorers %2d NKtest K=%2d Experiment %3d\n",e,K,t)

			#Create a landscape
			landscape=CreaLandscape(N,K)
			
			if strategy !=5
				#Put the explorers in the floor and get the avg peak 
				if e > 0
					ex=Array(agent,e)

					# Put the explorers on the floor 
					for i=1:e
						_ex=agent(int(rand()*(2^N-1)),0,0,0) # 0..2^N -1
						for j=1:length(_fixbits)
							_ex.stg=BitSet(_ex.stg,_fixbits[j],_fixval[j])
						end
						ex[i]=_ex
					end

					# Do the simulation
					estrategy=1 	#Hill Climbing
					ex, _niter=Simula(estrategy,ex)
				end
			else
				ex=randperm(nagents)
				ex=ex[1:e]
			end
			if (strategy==4 || strategy==5) && e!=0
				xe= e>nBestCases ? nBestCases : e 
			end
			
			# Put the agents on the floor 
			for i=1:nagents
				if e<0
					#Baseline without restricted bits
					ag[i]=agent(int(rand()*(2^N-1)),0,0,0) # 0..2^N -1
				else
					_ag=agent(int(rand()*(2^N-1)),0,0,0) # 0..2^N -1
					for j=1:length(_fixbits)
						_ag.stg=BitSet(_ag.stg,_fixbits[j],_fixval[j])
					end
					ag[i]=_ag
				end
				ag[i].mPivot=int32(rand()*(maxPivots-1)+1)
				ag[i].nPivot=int32(0)
				if (strategy==4 || strategy==5) && e>0
					#Assign a Best Case type to each agent
					ag[i].tBCase=int32(rand()*(xe-1)+1)					
				end
			end
					
			if e>0
				# Do the simulation
				for i=1:length(ex)
					@printf("Element %d, \n",i)
				end
				ag, _niter=Simula(strategy,ag,ex)
			else
				estrategy=e<0?0:1
				ag, _niter=Simula(estrategy,ag)
			end
						
			for i=1:nagents
				#	println(Fitness(ag[i].stg))
				aFit=Fitness(ag[i].stg)
				avgFit[ne,K+1,t]=avgFit[ne,K+1,t]+aFit
				aFitness[i]=aFit 
				writecsv(fOutCsvD,[_niter e K t i aFit])
			end
			avgFit[ne,K+1,t]=avgFit[ne,K+1,t]/nagents
			
			writecsv(fOutCsv,[_niter e K t mean(aFitness) std(aFitness)])
		
			#		println(avgFit[K+1,t])
		end
		@printf("N. of iterations %3d, Fitness %4f \n",_niter,mean(avgFit[ne,K+1,:]))
		flush(STDOUT)

	end
	ne=ne+1

end

serialize(fOut,avgFit)
close(fOut)
close(fOutCsv)
close(fOutCsvD)

#for i=1:2^16
#	@printf("Landscape %5d %7.3f  \n ",i,landscape[i])
#end

#@printf("Max landscape min landscape %7.3f %7.3f %7.3f\n",maximum(landscape),minimum(landscape),mean(landscape))


