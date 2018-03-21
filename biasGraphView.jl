#graphviz is the tool to draw the graphs. This tool takes a single string with all the features of the graph to draw into a complete graph.


#have the init set up the arrays of the country region labels
southWest = ["Portugal","Spain","Malta","SanMarino","Andorra","Monaco","Morocco","Italy"]
    north = ["Iceland","Denmark","Norway","Sweden","Finland"]
    northWest = ["UnitedKingdom","Ireland","Belgium","France","Luxembourg"]
    central = ["Germany","Austria","TheNetherlands","Switzerland","Slovenia","CzechRepublic","Hungary"]
    southEast = ["Greece","Montenegro","Cyprus","Albania","Bulgaria","Croatia","BosniaHerzegovina","Turkey","FYRMacedonia","Romania","Serbia","Israel","Yugoslavia"]
east = ["Russia","Ukraine","Moldova","Belarus","Poland","Georgia","Armenia","Azerbaijan","Estonia","Lithuania","Latvia"]

#each dictionary has the keys
#countriesNamesTotal
#thresholdSignificantAdjListTOTAL
#Window spans
#make a function to start the graph
function graphAvoid(wAgUP,wAGLOW)

    #make it a digraph for bi directional edges
    #No label as it is hard to predict the relative size of the font for the final output imae
    networkInit = "digraph{ graph "    
    
    println("ok..")
    tmp = regionNodeString("Russia")
    
    countryNamesTotal = wAGLOW["countriesNamesTotal"]
    
    
    println(tmp)
end

#add the components of the country names and the descriptors
function countryNodeDescriptors(dict_wAG)
    nodeDescriptor = ""
    countriesNamesTotal = dict_wAG["countriesNamesTotal"]
    println(countriesNamesTotal)
    countriesNamesTotal = removeBadChars(countriesNamesTotal)
    for ii in 1:length(countriesNamesTotal)
        tmpCountry = countriesNamesTotal[ii]
        println(tmpCountry)
        nodeDescTmp = regionNodeString(tmpCountry)
        println(nodeDescTmp)
        nodeDescriptor = string(nodeDescriptor,tmpCountry,nodeDescTmp)
    end
    
    return nodeDescriptor
end

#take an array and return the fixed name
function removeBadChars(strs_Pre)
    
    for ii in 1:length(strs_Pre)
        strPre = strs_Pre[ii]
        strPre = replace(strPre,"&","")
        strPre = replace(strPre,".","")
        strPre =  replace(strPre," ","")
        strs_Pre[ii] = strPre
    end
    
    return strs_Pre
end

#given a country string, it will check the region selection to return the node configuration needed for graphviz
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
    else
        println("country to region not found")
    end
    
    return nodeStr
end

