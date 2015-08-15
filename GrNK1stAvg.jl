#Graph for the first strategy Sharing Avg

using Winston


N=16
ntries=500


fIn=open("NK1stgAvg.dat","r")

avgFit=deserialize(fIn)

nE=size(avgFit,1)
nK=size(avgFit,2)
nT=size(avgFit,3)

yMean1=zeros(nK)
yStd1=zeros(nK)

yMean2=zeros(nK)
yStd2=zeros(nK)

yMean3=zeros(nK)
yStd3=zeros(nK)

yMean4=zeros(nK)
yStd4=zeros(nK)

yMean5=zeros(nK)
yStd5=zeros(nK)

yMean6=zeros(nK)
yStd6=zeros(nK)

f=FramedPlot(title="Effect of Performance Transparency \n - Platform - mean as benchmark -", xlabel="K 0 .. 15", ylabel="Fitness")

x=[1:N]
for k=1:nK
	yMean1[k]=mean(avgFit[1,k,:])
	yStd1[k]=std(avgFit[1,k,:])

	yMean2[k]=mean(avgFit[2,k,:])
	yStd2[k]=std(avgFit[2,k,:])

	yMean3[k]=mean(avgFit[3,k,:])
	yStd3[k]=std(avgFit[3,k,:])

	yMean4[k]=mean(avgFit[4,k,:])
	yStd4[k]=std(avgFit[4,k,:])

	yMean5[k]=mean(avgFit[5,k,:])
	yStd5[k]=std(avgFit[5,k,:])

	yMean6[k]=mean(avgFit[6,k,:])
	yStd6[k]=std(avgFit[6,k,:])

end

	c1=Curve(x,yMean1, color="black", kind="dashed")
#	p1=Points(x, yMean1, color="gray")
	
	setattr(c1,label="Unrestricted ")

	c2=Curve(x,yMean2, color="gray")
#	p2=Points(x, yMean2, color="gray")
	
	setattr(c2,label="No information")
	
	c3=Curve(x,yMean3)
	p3=Points(x, yMean3, color="blue", symbolkind="plus")

	setattr(p3,label="Mean of 5 agents")

	c4=Curve(x,yMean4)
	p4=Points(x, yMean4, color="green", symbolkind="circle")

	setattr(p4,label="Mean of 10 agents")
	
	c5=Curve(x,yMean5)
	p5=Points(x, yMean5, color="magenta", symbolkind="diamond")

	setattr(p5,label="Mean of 25 agents")
	
	c6=Curve(x,yMean6)
	p6=Points(x, yMean6, color="red", symbolkind="square")
	
	setattr(p6,label="Mean of 50 agents")

	
#	add(p,Curve(x,yMean1))
#	add(p,SymmetricErrorBarsY(x,yMean,yStd))
#	add(p, Points(x, yMean1, color="gray"))

#	add(p,Curve(x,yMean2))
#	add(p,SymmetricErrorBarsY(x,yMean,yStd))
#	add(p, Points(x, yMean2, color="blue"))

#	add(p,Curve(x,yMean3))
#	add(p,SymmetricErrorBarsY(x,yMean,yStd))
#	add(p, Points(x, yMean3, color="green"))

#	add(p,Curve(x,yMean4))
#	add(p,SymmetricErrorBarsY(x,yMean,yStd))
#	add(p, Points(x, yMean4, color="black"))

#	add(p,Curve(x,yMean5))
#	add(p,SymmetricErrorBarsY(x,yMean,yStd))
#	add(p, Points(x, yMean5, color="red"))

	l=Legend(.05,.35,{c1,c2,p3,p4,p5,p6})

	add(f,c1,c2,c3,p3,c4,p4,c5,p5,c6,p6,l)
	
setattr(f.x1,ticklabels=["1","3","5","7","9","11","13","15"])
display(f)

readline(STDIN)

	
