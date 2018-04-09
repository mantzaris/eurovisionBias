
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

function analyzeBiases(wAG)

    #get the total of the out and inward biases of every country for each time window as a total count
    countryDictTotalsOutIn = produceSingleWindowsOutIn(wAG)
    println(countryDictTotalsOutIn)
    #instead of getting an array, consistently deal with the dict
    #having a multidimensional array is order dependent and even if we do create it being dependent upon it instead of
    #dict dump data may not be long term wise as the searching is not always intuitive
    plotOutIn(countryDictTotalsOutIn,wAG["side"])

end

function plotOutIn(outInDict,side)
    
    # scatter(x,y,markersize=6,c=:orange)   scatter(x,y,markersize=6,c=:orange,leg=false)
    s1 = []
    ss = 0
    println(isempty(s1))
    for winKey in keys(outInDict)#time window keys
        println(winKey)
        winDict = outInDict[winKey]
        countriesWin = unique(vcat(collect(keys(winDict["out"])),collect(keys(winDict["in"]))))
        println(countriesWin)
        for cW in 1:length(countriesWin)
            outDeg = 0
            inDeg = 0 
            if(haskey(winDict["out"],countriesWin[cW]))
                outDeg = winDict["out"][countriesWin[cW]]
            end
            if(haskey(winDict["in"],countriesWin[cW]))
                inDeg = winDict["in"][countriesWin[cW]]
            end
            println([countriesWin[cW] outDeg inDeg])
            if( ss == 0 )
                ss += 1
                s1 =scatter([outDeg],[inDeg],markersize=7,c=:orange,leg=false)
                
            else
                scatter!([outDeg],[inDeg],markersize=7,c=:orange,leg=false)
            
            end
        end
        if(side == "Lower")
            scatter!(title=string("significant edges of neglect $(winKey)"))
        else
            scatter!(title=string("significant edges of preference $(winKey)"))
        end
        scatter!(titlefontsize=18,yguidefontsize=18,xguidefontsize=18,xlabel="outdegree", ylabel="in degree",xlabfont=font(20), xtickfont = font(14), ytickfont = font(16))#scatter!(xguide="x axis" , yguide="y axis")xlabel="outdegree"
        display(s1)
        
    end
        
    # scatter!(title="The neglect in or out")
        
end




#for each country produce an array/matrix for the total bias in/out
function produceSingleWindowsOutIn(wAG)
    #for each window the total in/out of each country
    countryDictTotalsOutIn = Dict()
    
    for kk in keys(wAG)
        if(kk[1] == '1')
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
