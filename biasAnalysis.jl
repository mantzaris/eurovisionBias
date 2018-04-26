
#we want the coloring of the nodes to be the same as the graphs to make it an easy look up
#have the init set up the arrays of the country region labels
southWest = ["Portugal","Spain","Malta","SanMarino","Andorra","Monaco","Morocco","Italy"]
north = ["Iceland","Denmark","Norway","Sweden","Finland"]
northWest = ["UnitedKingdom","Ireland","Belgium","France","Luxembourg"]
central = ["Germany","Austria","TheNetherlands","Switzerland","Slovenia","CzechRepublic","Hungary","Slovakia"]
southEast = ["Greece","Montenegro","Cyprus","Albania","Bulgaria","Croatia","BosniaHerzegovina","Turkey","FYRMacedonia","Romania","Serbia","Israel","Yugoslavia","SerbiaMontenegro"]
east = ["Russia","Ukraine","Moldova","Belarus","Poland","Georgia","Armenia","Azerbaijan","Estonia","Lithuania","Latvia"]
other = ["Australia"]


#so I am going to put in a dictionary pair tuple, for the low and high/upper. this will first look at a single window and count the NEGLECT total and then the PREFERENCE significance. printout the total for NEGLECT AND PREFERENCE : (RECEIVE AND PRODUCE)
#this function will need the aggregate neglect/avoid and the aggregate prefer biases
#before we needed the network connectivity and now we need aggregate for each country label

#needed for the plots
using Plots
#use pyplot()
pyplot()
#StatsBase (for Kendall Tau)
using StatsBase
#To get the cdf of the student t distribution
using Distributions

function analyzeBiases(wAGupper,wAGlower)

    #get the total of the out and inward biases of every country for each time window as a total count
    countryDictTotalsOutIn = produceSingleWindowsOutIn(wAGupper)
    #for each window look at the out/in for the upper lower (pref neg)
    plotOutIn(countryDictTotalsOutIn,wAGupper["side"],wAGupper["windowSize"],wAGupper["alpha"])
    #the scatter plot for the countries for the full year set overlap/overlay
    plotOutInAgg(wAGupper,countryDictTotalsOutIn,wAGupper["side"],wAGupper["windowSize"],wAGupper["alpha"])
    #the scatter plot from the thresholdSignificantAdjListTOTAL
    #the total in/out for the countries over all the time windows
    totalTimeInOutScatter(wAGupper)

    #now for the lower
    countryDictTotalsOutIn = produceSingleWindowsOutIn(wAGlower)    
    plotOutIn(countryDictTotalsOutIn,wAGlower["side"],wAGlower["windowSize"],wAGlower["alpha"])
    plotOutInAgg(wAGlower,countryDictTotalsOutIn,wAGlower["side"],wAGlower["windowSize"],wAGlower["alpha"])
    totalTimeInOutScatter(wAGlower)


    #now for the upper and lower comparisons
    totalTimeInOutScatterNegPref(wAGupper,wAGlower)

    #the total score received VS how much significant neglect edges inwards counted
    totalTimeScoreNeglectScatter(wAGupper,wAGlower)
end



#now a plot for the total (score VS neglect) for the years in all time windows
function totalTimeScoreNeglectScatter(wAGupper,wAGlower)
    alpha = wAGupper["alpha"]
    winSize = wAGupper["windowSize"]    
    totalsUpper = wAGupper["thresholdSignificantAdjListTOTAL"]#n by 3 array
    totalsLower = wAGlower["thresholdSignificantAdjListTOTAL"]#n by 3 array    
    cntryAr = unique(vcat(totalsUpper[:,1],totalsLower[:,1]))

    s1 = scatter(titlefontsize=18,yguidefontsize=18,xguidefontsize=18,xlabel="score received", ylabel="in neglect",xlabfont=font(20), xtickfont = font(14), ytickfont = font(16),overwrite_figure=false)
    xtmp = Int[]
    ytmp = Int[]
    for cInd in 1:length(cntryAr)
        cntryTmp = cntryAr[cInd]
        indsNeg = (totalsLower[:,2] .== cntryTmp)           
        
        negTotalTmp = sum(totalsLower[indsNeg,3])
        println(cntryTmp)
        totalScoreTmp = totalCountryScoreReceive(wAGupper,cntryTmp)
        println(totalScoreTmp)
        s1 = scatter!([totalScoreTmp],[negTotalTmp],markersize=8,c=:black,leg=false)
        push!(xtmp,totalScoreTmp)
        push!(ytmp,negTotalTmp)
    end
    tau = corkendall(xtmp,ytmp)
    tau = round(tau,4)
    yearMin,yearMax = getYearsMinMax(wAGupper)#will be identical for both upper/lower windows
    scatter!(title=string("Total Neglect In ", yearMin,"-",yearMax,"\n window size=$(winSize), \u03C4=$(tau)"))
    display(s1)
    filename = string("scatter","ScoreVSneglectIn",yearMin,"-",yearMax,"win",winSize,"alpha",alpha,".png")
    savefig("./plots/$filename")

    #pref in VS score
    s2 = scatter(titlefontsize=18,yguidefontsize=18,xguidefontsize=18,xlabel="score received", ylabel="in preference",xlabfont=font(20), xtickfont = font(14), ytickfont = font(16),overwrite_figure=false)
    xtmp = Int[]
    ytmp = Int[]
    for cInd in 1:length(cntryAr)
        cntryTmp = cntryAr[cInd]
        indsPref = (totalsUpper[:,2] .== cntryTmp)           
        
        prefTotalTmp = sum(totalsUpper[indsPref,3])
        totalScoreTmp = totalCountryScoreReceive(wAGupper,cntryTmp)
        s2 = scatter!([totalScoreTmp],[prefTotalTmp],markersize=8,c=:black,leg=false)
        push!(xtmp,totalScoreTmp)
        push!(ytmp,prefTotalTmp)
    end
    tau = corkendall(xtmp,ytmp)
    tau = round(tau,4)
    scatter!(title=string("Total Preference In ",yearMin,"-",yearMax,"\n window size=$(winSize), \u03C4=$(tau)"))
    display(s2)
    filename = string("scatter","ScoreVSpreferenceIn",yearMin,"-",yearMax,"win",winSize,"alpha",alpha,".png")
    savefig("./plots/$filename")

    
    #(pref in - neg in) VS score
    s3 = scatter(titlefontsize=18,yguidefontsize=18,xguidefontsize=18,xlabel="score received", ylabel="in preference-neglect",xlabfont=font(20), xtickfont = font(14), ytickfont = font(16),overwrite_figure=false)
    xtmp = Int[]
    ytmp = Int[]
    for cInd in 1:length(cntryAr)
        cntryTmp = cntryAr[cInd]
        indsPref = (totalsUpper[:,2] .== cntryTmp)           
        indsNeg = (totalsLower[:,2] .== cntryTmp)           
        
        negTotalTmp = sum(totalsLower[indsNeg,3])
        prefTotalTmp = sum(totalsUpper[indsPref,3])
        totalScoreTmp = totalCountryScoreReceive(wAGupper,cntryTmp)
        s3 = scatter!([totalScoreTmp],[prefTotalTmp-negTotalTmp],markersize=8,c=:black,leg=false)
        push!(xtmp,totalScoreTmp)
        push!(ytmp,prefTotalTmp-negTotalTmp)
    end
    tau = corkendall(xtmp,ytmp)
    tau = round(tau,4)
    scatter!(title=string("Total Preference-Neglect In ",yearMin,"-",yearMax,"\n window size=$(winSize), \u03C4=$(tau)"))
    display(s3)
    filename = string("scatter","ScoreVSprefMinusNegIn",yearMin,"-",yearMax,"win",winSize,"alpha",alpha,".png")
    savefig("./plots/$filename")


    #(pref out) VS score
    s4 = scatter(titlefontsize=18,yguidefontsize=18,xguidefontsize=18,xlabel="score received", ylabel="out preference",xlabfont=font(20), xtickfont = font(14), ytickfont = font(16),overwrite_figure=false)
    xtmp = Int[]
    ytmp = Int[]
    for cInd in 1:length(cntryAr)
        cntryTmp = cntryAr[cInd]
        indsPref = (totalsUpper[:,1] .== cntryTmp)           
        indsNeg = (totalsLower[:,2] .== cntryTmp)           
        
        negTotalTmp = sum(totalsLower[indsNeg,3])
        prefTotalTmp = sum(totalsUpper[indsPref,3])
        totalScoreTmp = totalCountryScoreReceive(wAGupper,cntryTmp)
        s4 = scatter!([totalScoreTmp],[prefTotalTmp],markersize=8,c=:black,leg=false)
        push!(xtmp,totalScoreTmp)
        push!(ytmp,prefTotalTmp)
    end
    tau = corkendall(xtmp,ytmp)
    tau = round(tau,4)
    scatter!(title=string("Total Preference Out ",yearMin,"-",yearMax,"\n window size=$(winSize), \u03C4=$(tau)"))
    display(s4)
    filename = string("scatter","ScoreVSprefOut",yearMin,"-",yearMax,"win",winSize,"alpha",alpha,".png")
    savefig("./plots/$filename")

    #(neg out) VS score
    s5 = scatter(titlefontsize=18,yguidefontsize=18,xguidefontsize=18,xlabel="score received", ylabel="out neglect",xlabfont=font(20), xtickfont = font(14), ytickfont = font(16),overwrite_figure=false)
    xtmp = Int[]
    ytmp = Int[]
    for cInd in 1:length(cntryAr)
        cntryTmp = cntryAr[cInd]
        indsPref = (totalsUpper[:,1] .== cntryTmp)           
        indsNeg = (totalsLower[:,1] .== cntryTmp)           
        
        negTotalTmp = sum(totalsLower[indsNeg,3])
        prefTotalTmp = sum(totalsUpper[indsPref,3])
        totalScoreTmp = totalCountryScoreReceive(wAGupper,cntryTmp)
        s5 = scatter!([totalScoreTmp],[negTotalTmp],markersize=8,c=:black,leg=false)
        push!(xtmp,totalScoreTmp)
        push!(ytmp,negTotalTmp)
    end
tau = corkendall(xtmp,ytmp)
tau = round(tau,4)
scatter!(title=string("Total Neglect Out ",yearMin,"-",yearMax,"\n window size=$(winSize), \u03C4=$(tau)"))
    display(s5)
    filename = string("scatter","ScoreVSNegOut",yearMin,"-",yearMax,"win",winSize,"alpha",alpha,".png")
    savefig("./plots/$filename")

end



#return for a country the total scores/points received (not significance but raw scores)
function totalCountryScoreReceive(wAGupper,cntryTmp)
    total = 0
    for kk in keys(wAGupper)
        if(kk[1] == '1' || kk[1] == '2')
            totalsUpper = wAGupper[kk]["scoreAggregateAdjList"]
            indsScores = (totalsUpper[:,2] .== cntryTmp)
            #println(indsScores)
            if(count(indsScores) > 0)
                scoreTmp = sum(totalsUpper[indsScores,3])
                total += scoreTmp
            end
            
        end
    end    
    return total
end



#now plot the total neglect out VS the total pref out
#
function totalTimeInOutScatterNegPref(wAGupper,wAGlower)
    alpha = wAGupper["alpha"]
    winSize = wAGupper["windowSize"]    
    totalsUpper = wAGupper["thresholdSignificantAdjListTOTAL"]#n by 3 array
    totalsLower = wAGlower["thresholdSignificantAdjListTOTAL"]#n by 3 array
    
    cntryAr = unique(vcat(totalsUpper[:,1],totalsLower[:,1]))
    println(cntryAr)
    
    s1 = scatter(titlefontsize=18,yguidefontsize=18,xguidefontsize=18,xlabel="out preference", ylabel="out neglect",xlabfont=font(20), xtickfont = font(14), ytickfont = font(16),overwrite_figure=false)
    xtmp = Int[]
    ytmp = Int[]
    for cInd in 1:length(cntryAr)
        cntryTmp = cntryAr[cInd]
        indsNeg = (totalsLower[:,1] .== cntryTmp)           
        indsPref = (totalsUpper[:,1] .== cntryTmp)
        negTotalTmp = sum(totalsLower[indsNeg,3])
        prefTotalTmp = sum(totalsUpper[indsPref,3])
        s1 = scatter!([prefTotalTmp],[negTotalTmp],markersize=8,c=:black,leg=false)
        push!(xtmp,prefTotalTmp)
        push!(ytmp,negTotalTmp)
    end
    tau = corkendall(xtmp,ytmp)
    tau = round(tau,4)
    yearMin,yearMax = getYearsMinMax(wAGupper)#will be identical for both upper/lower windows

    scatter!(title=string(yearMin,"-",yearMax,"\n window size=$(winSize), \u03C4=$(tau)"))
    display(s1)
    filename = string("scatter","TotalYearsOutPrefNeg",yearMin,"-",yearMax,"win",winSize,"alpha",alpha,".png")
    savefig("./plots/$filename")

    #now for inwards
    s2 = scatter(titlefontsize=18,yguidefontsize=18,xguidefontsize=18,xlabel="in preference", ylabel="in neglect",xlabfont=font(20), xtickfont = font(14), ytickfont = font(16),overwrite_figure=false)
    xtmp = Int[]
    ytmp = Int[]
    for cInd in 1:length(cntryAr)
        cntryTmp = cntryAr[cInd]
        indsNeg = (totalsLower[:,2] .== cntryTmp)           
        indsPref = (totalsUpper[:,2] .== cntryTmp)
        negTotalTmp = sum(totalsLower[indsNeg,3])
        prefTotalTmp = sum(totalsUpper[indsPref,3])
        s2 = scatter!([prefTotalTmp],[negTotalTmp],markersize=8,c=:black,leg=false)
        push!(xtmp,prefTotalTmp)
        push!(ytmp,negTotalTmp)
    end           
    tau = corkendall(xtmp,ytmp)
    tau = round(tau,4)
    scatter!(title=string(yearMin,"-",yearMax,"\n window size=$(winSize), \u03C4=$(tau)"))
    display(s2)
    filename = string("scatter","TotalYearsInPrefNeg",yearMin,"-",yearMax,"win",winSize,"alpha",alpha,".png")
    savefig("./plots/$filename")
        
end








function plotOutIn(outInDict,side,windowSize,alpha)
            
    for winKey in keys(outInDict)#time window keys
        
        winDict = outInDict[winKey]
        countriesWin = unique(vcat(collect(keys(winDict["out"])),collect(keys(winDict["in"]))))
        scatter(markersize=8,c=:black,leg=false,overwrite_figure=false)
        xtmp = Int[]
        ytmp = Int[]
        for cW in 1:length(countriesWin)
            outDeg = 0
            inDeg = 0 
            if(haskey(winDict["out"],countriesWin[cW]))
                outDeg = winDict["out"][countriesWin[cW]]
            end
            if(haskey(winDict["in"],countriesWin[cW]))
                inDeg = winDict["in"][countriesWin[cW]]
            end                        
            scatter!([outDeg],[inDeg],markersize=8,c=:black,leg=false)
            push!(xtmp,outDeg)
            push!(ytmp,inDeg)
        end
        tau = corkendall(xtmp,ytmp)
        tau = round(tau,4)
        if(side == "Lower")
            scatter!(title=string("Neglect $(winKey), \u03C4=$(tau)"))
        else
            scatter!(title=string("Preference $(winKey), \u03C4=$(tau)"))
        end
        scatter!(titlefontsize=18,yguidefontsize=18,xguidefontsize=18,xlabel="out degree", ylabel="in degree",xlabfont=font(20), xtickfont = font(14), ytickfont = font(16))
        tmp = ""
        side == "Lower" ? tmp="Neglect":tmp="Preference"
        filename = string("scatter",tmp,"SingleWin",winKey,"win",windowSize,"alpha",alpha,".png")
        savefig("./plots/$filename")
        ss = 0
    end                    
end




#for each country produce an array/matrix for the total bias in/out
function produceSingleWindowsOutIn(wAG)
    #for each window the total in/out of each country
    countryDictTotalsOutIn = Dict()
    
    for kk in keys(wAG)
        if(kk[1] == '1' || kk[1] == '2')
            countryDictTotalsOutIn[kk] = Dict()#just putting the totals of each country
            countryDictTotalsOutIn[kk]["out"] = Dict()
            countryDictTotalsOutIn[kk]["in"] = Dict()
            sigAdjList = wAG[kk]["thresholdSigAdjList"]
            
            for ii in 1:size(sigAdjList,1)
                if(sigAdjList[ii,3] > 0)
                    cntry1 = sigAdjList[ii,1]
                    cntry1 = fixBadChars(cntry1)
                    cntry2 = sigAdjList[ii,2]
                    cntry2 = fixBadChars(cntry2)
                    #one country
                    if( isempty(countryDictTotalsOutIn[kk]["out"]) || !haskey(countryDictTotalsOutIn[kk]["out"],cntry1) )
                        countryDictTotalsOutIn[kk]["out"][cntry1] = 1
                    else
                        countryDictTotalsOutIn[kk]["out"][cntry1] += 1
                    end
                    if( isempty(countryDictTotalsOutIn[kk]["in"]) || !haskey(countryDictTotalsOutIn[kk]["in"],cntry2) )
                        countryDictTotalsOutIn[kk]["in"][cntry2] = 1
                    else
                        countryDictTotalsOutIn[kk]["in"][cntry2] += 1
                    end
                    
                end
            end
            
        end
        
    end           
    return countryDictTotalsOutIn
end



function fixBadChars(str_Pre)
       
    strPre = replace(str_Pre,"&","")
    strPre = replace(strPre,".","")
    strPre =  replace(strPre," ","")
        
    return strPre
end



#given a country string, it will check the region selection to return the node configuration color
function regionNodeString(countryInput)

    if(countryInput in east)
        nodeStr = " [style=filled,fillcolor=olivedrab3]; "
    elseif(countryInput in southWest)
        nodeStr = " [style=filled,fillcolor=indianred1]; "
    elseif(countryInput in north)
        nodeStr = " [style=filled,fillcolor=dodgerblue]; "
    elseif(countryInput in northWest)
        nodeStr = " [style=filled,fillcolor=darkslategray2]; "
    elseif(countryInput in central)
        nodeStr = " [style=filled,fillcolor=gray]; "
    elseif(countryInput in southEast)
        nodeStr = " [style=filled,fillcolor=darkgoldenrod1]; "    
    elseif(countryInput in other)        
        nodeStr = " [style=filled,fillcolor=whitesmoke]; "
    else
        
        print("country to region not found: ")
        println(countryInput)
    end
    
    return nodeStr
end


#have a scatter accumulation of the countries not as a total but OVERLAY
#each point encountered in the different windows is put independently on a scatter
function plotOutInAgg(wAG,outInDict,side,windowSize,alpha)
    ss = 0
    s1 = []    
    println(isempty(s1))
    xtmp = Int[]
    ytmp = Int[]
    for winKey in keys(outInDict)#time window keys            
        winDict = outInDict[winKey]
        countriesWin = unique(vcat(collect(keys(winDict["out"])),collect(keys(winDict["in"]))))
        
        for cW in 1:length(countriesWin)
            outDeg = 0
            inDeg = 0 
            if(haskey(winDict["out"],countriesWin[cW]))
                outDeg = winDict["out"][countriesWin[cW]]
            end
            if(haskey(winDict["in"],countriesWin[cW]))
                inDeg = winDict["in"][countriesWin[cW]]
            end       
            if( ss == 0 )
                ss += 1
                s1 =scatter([outDeg],[inDeg],markersize=8,c=:black,leg=false,overwrite_figure=false) 
            else
                scatter!([outDeg],[inDeg],markersize=8,c=:black,leg=false) 
            end
            push!(xtmp,outDeg)
            push!(ytmp,inDeg)
        end                
    end
    yearMin,yearMax = getYearsMinMax(wAG)
    tau = corkendall(xtmp,ytmp)
    tau = round(tau,4)
    if(side == "Lower")
        scatter!(title=string("Overlapping Neglect $(yearMin)-$(yearMax) \n window size=$(windowSize), \u03C4=$(tau)"))
    else
        scatter!(title=string("Overlapping Preference $(yearMin)-$(yearMax) \n window size=$(windowSize), \u03C4=$(tau)"))
    end
    scatter!(titlefontsize=18,yguidefontsize=18,xguidefontsize=18,xlabel="out degree", ylabel="in degree",xlabfont=font(20), xtickfont = font(14), ytickfont = font(16))
    #display(s1)
    tmp = ""
    side == "Lower" ? tmp="Neglect":tmp="Preference"
    filename = string("scatter",tmp,"OverlapWindows",yearMin,"to",yearMax,"win",windowSize,"alpha",alpha,".png")
    savefig("./plots/$filename")
    #ss = 0#one fig only
end






#shows: HOW MANY EDGES IN AN OUT FOR EACH COUNTRY OVER ALL WINDOW PERIODS
function totalTimeInOutScatter(wAG)
    alpha = wAG["alpha"]
    winSize = wAG["windowSize"]
    side = wAG["side"]
    totals = wAG["thresholdSignificantAdjListTOTAL"]#n by 3 array
    
    cntryAr = unique(totals[:,1])
    xtmp = Int[]
    ytmp = Int[]
    s1 = scatter(titlefontsize=18,yguidefontsize=18,xguidefontsize=18,xlabel="out degree", ylabel="in degree",xlabfont=font(20), xtickfont = font(14), ytickfont = font(16),overwrite_figure=false)
    for cInd in 1:length(cntryAr)
        cntryTmp = cntryAr[cInd]
        indsOut = (totals[:,1] .== cntryTmp)           
        indsIn = (totals[:,2] .== cntryTmp)
        inTotalTmp = sum(totals[indsIn,3])
        outTotalTmp = sum(totals[indsOut,3])
        s1 = scatter!([outTotalTmp],[inTotalTmp],markersize=8,c=:black,leg=false)
        push!(xtmp,outTotalTmp)
        push!(ytmp,inTotalTmp)
    end
    tau = corkendall(xtmp,ytmp)
    tau = round(tau,4)
    yearMin,yearMax = getYearsMinMax(wAG)
    tmp = ""
    side == "Lower" ? tmp="Neglect":tmp="Preference"
    scatter!(title=string("Total ",tmp," ",yearMin,"-",yearMax,"\n window size=$(winSize), \u03C4=$(tau)"))
    display(s1)
    filename = string("scatter",tmp,"TotalYearsOutIn",yearMin,"-",yearMax,"win",winSize,"alpha",alpha,".png")
    savefig("./plots/$filename")
    
end


function getYearsMinMax(wAG)
    keys1 = [(if(kk[1]=='1' || kk[1] == '2'); kk;end)  for kk in keys(wAG)]
    keys1 = keys1[keys1 .!= nothing]
    yearsWin = [split(k1,"-") for k1 in keys1]
    years = vcat(yearsWin)
    years = [j for i in years for j in i]    
    years = sort(years)
    yearMin = parse(Int,years[1])    
    yearMax = parse(Int,years[end])
    return yearMin,yearMax
end



#from the spearman rho value get the student t-distribution val
function spearmanTval(r,n,alpha)
    tval = r * ( sqrt( (n-2) / (1-(r^2)) ) )
    #println(r);println(tval)
    return tsignificance(n,tval,alpha)
end

function tsignificance(degfree,tval,alpha)
    #println(degfree);println(tval);println(alpha);
    pval = cdf(TDist(degfree),tval)
    #println(pval)
    if(pval < alpha || pval > (1-alpha))
        return "significant"
    else
        return "not significant"
    end
end



#=

x=[1,2,3,4,5,6,7,8,9,10];
y=[1,2,3,4,5,7,10,-11,1,10];
r=corspearman(x,y)
tt(r,n) = r*(sqrt((n-2)/(1-r^2)))
t=tt(r,length(x))
cdf(TDist(10),8)
=#









#=
#plotOutInTotal(countryDictTotalsOutIn,wAG["side"],wAG["windowSize"],wAG["alpha"])

#look at the total key set and produce an aggregate scatter plot, don't over complicate auto-amigo
function plotOutInTotal(outInDict,side,windowSize,alpha)
    
    s1 = []
    ss = 0
    countriesTotal = []
    for winKey in keys(outInDict)#time window keys, prior making single windows, now just not new?
        
        println(winKey)
        winDict = outInDict[winKey]
        countriesTotal = append!(countriesTotal,unique(vcat(collect(keys(winDict["out"])),collect(keys(winDict["in"])))))
        println(countriesTotal)
        println(typeof(countriesTotal))
        
    end
    countriesTotal = unique(countriesTotal)
    println(countriesTotal)
    
    #now with total country set, we iterate over them, for each country then inside each key time window
    #we aggregate and add to the plot of the temp total
    for cTmp in countriesTotal
        println(cTmp)
        outDegT = 0
        inDegT = 0 
        for winKey in keys(outInDict)#time window keys, prior making single windows, now just not new?
            if(haskey(outInDict[winKey]["in"],cTmp))
                outDegT += outInDict[winKey]["in"][cTmp]
                println(outInDict[winKey]["in"][cTmp])                
            end
            if(haskey(outInDict[winKey]["out"],cTmp))
                inDegT += outInDict[winKey]["out"][cTmp]
                println(outInDict[winKey]["out"][cTmp])                
            end
            println(winKey)
        end
        println([outDegT, inDegT])
        if( ss == 0 )
            ss += 1
            s1 =scatter([outDegT],[inDegT],markersize=8,c=:black,leg=false,overwrite_figure=false) 
        else
            scatter!([outDegT],[inDegT],markersize=8,c=:black,leg=false)            
        end
    end
    

    keys1 = [(if(kk[1]=='1' || kk[1] == '2'); kk;end)  for kk in keys(outInDict)]
    keys1 = keys1[keys1 .!= nothing]
    yearsWin = [split(k1,"-") for k1 in keys1]
    years = vcat(yearsWin)
    years = [j for i in years for j in i]    
    years = sort(years)
    yearMin = parse(Int,years[1])    
    yearMax = parse(Int,years[end])


    if(side == "Lower")
        scatter!(title=string("significant Total neglect $yearMin to $yearMax"))
    else
        scatter!(title=string("significant Total preference $yearMin to $yearMax"))
    end
    
    scatter!(titlefontsize=18,yguidefontsize=18,xguidefontsize=18,xlabel="out degree", ylabel="in degree",xlabfont=font(20), xtickfont = font(14), ytickfont = font(16))#scatter!(xguide="x axis" , yguide="y axis")xlabel="outdegree"
    #display(s1)


    tmp = ""
    side == "Lower" ? tmp="Neglect":tmp="Prefer"
    filename = string("scatter",tmp,"TotalWin",yearMin,"to",yearMax,"win",windowSize,"alpha",alpha,".png")
    savefig("./plots/$filename")



end
=#
