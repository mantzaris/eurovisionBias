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
#Window spans-> countries | thresholdSigAdjList | avgScoreAggregateAdjList | scoreAggregateAdjList
#make a function to start the graph
function graphAvoid(wAGLOW)

    wTmp = wAGLOW["1980-1985"]
#    println(wTmp)
    for kk in keys(wTmp)
        if(kk == "1980-1985"])
            #make it a digraph for bi directional edges
            #No label as it is hard to predict the relative size of the font for the final output imae
            networkInit = "digraph avoid {  "    

            #pass the dictionary to obtain the graphviz string for the node descriptions (attributes color etc)
            nodeDescriptions = countryNodeDescriptors(wTmp)
            networkInit = string(networkInit, nodeDescriptions)

            #buildup the edges and edge attributes
            sigStr = countryEdges(wTmp["thresholdSigAdjList"])
            networkInit = string(networkInit,sigStr)

            #finalize the network dscription by the final identifier
            networkInit = string(networkInit, "}")
            println(networkInit)

            #name for the dot file name and the network file name and output image
            writeGraphViz("networkTmp", networkInit)
        end        
    end
    
end


#construct the string of the country pairs and the edge attributes
#takes an AdjList
function countryEdges(sigAdjList)
    edges = ""
    for ii in 1:size(sigAdjList,1)
        if(sigAdjList[ii,3] > 0)
            cntry1 = sigAdjList[ii,1]
            cntry1 = fixBadChars(cntry1)
            cntry2 = sigAdjList[ii,2]
            cntry2 = fixBadChars(cntry2)
            edges = string(edges,cntry1,"->",cntry2," [ color=red penwidth=2];")
        end
        
    end
    
    println(sigAdjList)
    return edges#string("France","->","Greece"," [ color=red penwidth=3];")
        
end



#give the .dot file to graphviz and make the png file
function writeGraphViz(filename, networkInit)
    fileName = string("network1",".dot")
    print(fileName)
    filePNG = string("network1",".png")
    print(filePNG)
    writedlm(string("./",fileName), [networkInit])
    
    run(`dot $fileName -Tpng -o $filePNG`)
end


#add the components of the country names and the descriptors
function countryNodeDescriptors(dict_wAG)
    nodeDescriptor = ""
    countriesNamesTotal = dict_wAG["countries"]#dict_wAG["countriesNamesTotal"]
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


function fixBadChars(str_Pre)
       
    strPre = replace(str_Pre,"&","")
    strPre = replace(strPre,".","")
    strPre =  replace(strPre," ","")
        
    return strPre
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

