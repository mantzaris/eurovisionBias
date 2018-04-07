
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

#for each country produce an array/matrix for the total bias in/out
function produceSingleWindowPref(wAG)
    #for each window the total in/out of each country
    countryDictTotalsOut = Dict()
    
    for kk in keys(wAG)
        if(kk[1] == '1')
            countryDictTotalsOut[kk] = Dict()#just putting the totals of each country
            countryDictTotalsOut[kk]["out"] = Dict()
            countryDictTotalsOut[kk]["in"] = Dict()
            sigAdjList = wAG[kk]["thresholdSigAdjList"]

            for ii in 1:size(sigAdjList,1)
                if(sigAdjList[ii,3] > 0)
                    cntry1 = sigAdjList[ii,1]
                    cntry1 = fixBadChars(cntry1)
                    cntry2 = sigAdjList[ii,2]
                    cntry2 = fixBadChars(cntry2)
                    #one country
                    if( isempty(countryDictTotalsOut[kk]["out"]) || !haskey(countryDictTotalsOut[kk]["out"],cntry1) )
                        countryDictTotalsOut[kk]["out"][cntry1] = 1
                    else
                        countryDictTotalsOut[kk]["out"][cntry1] += 1
                    end
                    if( isempty(countryDictTotalsOut[kk]["in"]) || !haskey(countryDictTotalsOut[kk]["in"],cntry2) )
                        countryDictTotalsOut[kk]["in"][cntry2] = 1
                    else
                        countryDictTotalsOut[kk]["in"][cntry2] += 1
                    end
                    
                end
            end
            
        end
        
    end           
    return countryDictTotalsOut
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
