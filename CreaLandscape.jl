#--------------------------------------------------------------------------
function CreaLandscape(N,K)
# CreaLandscape    Creates a landscape N-K (see Kauffman)
# Returns:
#       m_cs->max interactions
#       CS -> global variable that contains vector dependencies
#       CV -> global variable that contains random number used to build the
#       landscape
# Inputs:
#       N -> number of different components of the Strategy
#       K -> number of components of wich every single component depends on


#global landscape
#global cs
#global maxLand

dosaN=2^N
dosaK1=2^(K+1)

landscape=zeros(dosaN,1)

cs=zeros(Int,N,K+1)
cvx=rand(dosaK1,N)

#Random with repetition
for i=[1:N]
    tmp=[1:i-1,i+1:N]
    tmp1=randperm(N-1)
   	cs[i,:]=[i tmp[tmp1[1:K]]']
##   cs(i,:)=sort(cs(i,:))
end

maxval=0
minval=9

for i=[0:(dosaN-1)]
    valor=0;
    for j=[1:N]
        ind=0;
        for p=[1:(K+1)]
#            pm=int32(2^cs[j,p])
#            println(i," ",pm," ",i&pm," ",ind|pm)
            if (i & int32(2^(cs[j,p]-1))) >0
                ind=(ind | 2^(p-1))
            end
#            if (bitget(i,cs(j,p))==1)
#                ind=bitset(ind,p,1);
#            end
        end
        valor=valor+cvx[ind+1,j]
    end

    landscape[i+1]=valor/N
    if (landscape[i+1]>maxval)
        maxval=landscape[i+1]
        maxLand=i+1
    end
    if (landscape[i+1]<minval)
        minval=landscape[i+1]
    end
end

dif=maxval-minval
landscape=(landscape.-minval)/dif

return landscape
end