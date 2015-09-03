#Plot for the first strategy Sharing Max

using Winston


N=16
ntries=500


fIn=open("MaxP-CNP.dat","r")

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

#yMean7=zeros(nK)
#yStd7=zeros(nK)

f=FramedPlot(title="       Effect of Performance Transparency \n - Platform - 3 bits restriction - 250 pivots  -", 
	xlabel="Interdependency of the Solution Space", ylabel="Performance", yrange=(.7,1.01))


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

#	yMean7[k]=mean(avgFit[7,k,:])
#	yStd7[k]=std(avgFit[7,k,:])

end

	c1=Curve(x,yMean1, color="black", kind="dashed")
#	p1=Points(x, yMean1, color="gray")
	
	setattr(c1,label="Unrestricted")
	
	c2=Curve(x,yMean2, color="gray")
#	p2=Points(x, yMean2, color="gray")
	
	setattr(c2,label="No information")

	c3=Curve(x,yMean3)
	p3=Points(x, yMean3, color="cyan", symbolkind="plus")

	setattr(p3,label="Ratings of 5")

	c4=Curve(x,yMean4)
	p4=Points(x, yMean4, color="green", symbolkind="asterisk")

	setattr(p4,label="Ratings of 10 ")
	
	c5=Curve(x,yMean5)
	p5=Points(x, yMean5, color="blue", symbolkind="circle")

	setattr(p5,label="Ratings of 25 ")
	
	c6=Curve(x,yMean6)
	p6=Points(x, yMean6, color="magenta", symbolkind="diamond")
	
	setattr(p6,label="Ratings of 50")

#	c7=Curve(x,yMean7)
#	p7=Points(x, yMean7, color="red", symbolkind="square")
	
#	setattr(p7,label="Ratings of 100")


#	l=Legend(.07,.4,{c1,c2,p3,p4,p5,p6,p7})
	l=Legend(.07,.4,{c1,c2,p3,p4,p5,p6})

#	add(f,c1,c2,c3,p3,c4,p4,c5,p5,c6,p6,c7,p7,l)
	add(f,c1,c2,c3,p3,c4,p4,c5,p5,c6,p6,l)
	
setattr(f.x1,ticklabels=["1","3","5","7","9","11","13","15"])
display(f)

readline(STDIN)

	
