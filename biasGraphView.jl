#graphviz is the tool to draw the graphs. This tool takes a single string with all the features of the graph to draw into a complete graph.


#have the init set up the arrays of the country region labels
southWest = ["Portugal","Spain","Malta","SanMarino","Andorra","Monaco","Morocco","Italy"]
north = ["Iceland","Denmark","Norway","Sweden","Finland"]
northWest = ["UnitedKingdom","Ireland","Belgium","France","Luxembourg"]
central = ["Germany","Austria","TheNetherlands","Switzerland","Slovenia","CzechRepublic","Hungary","Slovakia","Netherlands"]
southEast = ["Greece","Montenegro","Cyprus","Albania","Bulgaria","Croatia","BosniaHerzegovina","Turkey","FYRMacedonia","Romania","Serbia","Israel","Yugoslavia","SerbiaMontenegro"]
east = ["Russia","Ukraine","Moldova","Belarus","Poland","Georgia","Armenia","Azerbaijan","Estonia","Lithuania","Latvia"]
other = ["Australia"]
#each dictionary has the keys
#countriesNamesTotal
#thresholdSignificantAdjListTOTAL
#Window spans-> countries | thresholdSigAdjList | avgScoreAggregateAdjList | scoreAggregateAdjList
#make a function to start the graph
function graphAvoid(wAGLOW,wAGHIGH)
    #FIRST LOWER
    #produce the graph images from the one way avoid biases
    produceOneWayGraphs(wAGLOW)
    #produce the graph images from the total one way avoids
    produceTotalOneWayGraphs(wAGLOW)
    #produce the mutual Avoid/Neglect
    produceMutualTwoWayGraphs(wAGLOW)
    #produce the total mutual avoid count graph
    produceTotalMutualTwoWayGraphs(wAGLOW)
    #NOW HIGH / UPPER
    produceOneWayGraphs(wAGHIGH)
    produceTotalOneWayGraphs(wAGHIGH)
    produceMutualTwoWayGraphs(wAGHIGH)
    produceTotalMutualTwoWayGraphs(wAGHIGH)
end


#from the dictionary produce the one way Avoids for the TOTAL time windows in the dictionary keys
function produceTotalOneWayGraphs(wAGLOW)
  
    #make it a digraph for bi directional edges
    #No label as it is hard to predict the relative size of the font for the final output imae
    networkInit = "digraph avoid {  "    
    
    #pass the dictionary to obtain the graphviz string for the node descriptions (attributes color etc)
    nodeDescriptions = countryNodeDescriptorsTotalOneWay(wAGLOW)
    networkInit = string(networkInit, nodeDescriptions)
    println(networkInit)

    #buildup the edges and edge attributes
    sigStr = countryEdgesTotal(wAGLOW["thresholdSignificantAdjListTOTAL"],wAGLOW["side"])
    networkInit = string(networkInit,sigStr)
    println(networkInit)
    
    #finalize the network dscription by the final identifier
    networkInit = string(networkInit, "}")

    #name for the dot file name and the network file name and output image
    keys1 = [(if(kk[1]=='1' || kk[1] == '2'); kk;end)  for kk in keys(wAGLOW)]
    keys1 = keys1[keys1 .!= nothing]
    yearsWin = [split(k1,"-") for k1 in keys1]
    years = vcat(yearsWin)
    years = [j for i in years for j in i]    
    years = sort(years)
    yearMin = parse(Int,years[1])    
    yearMax = parse(Int,years[end])    
    #=if(length(years)>2)
        winYears = convert(Int, (yearMax - yearMin) / (length(years)-2))
    else
        winYears = (yearMax - yearMin)
    end=#
    winYears = wAGLOW["windowSize"]
    alpha = wAGLOW["alpha"]
    side = wAGLOW["side"]
    fileName = string("network",side,"TotalOneWay",yearMin,"to",yearMax,"win",winYears,"alpha",alpha)
    writeGraphViz(fileName, networkInit)

end


#construct the string of the country pairs and the edge attributes
#takes an AdjList from the total window set
function countryEdgesTotal(sigAdjList,side)
    edges = ""
    for ii in 1:size(sigAdjList,1)
        if(sigAdjList[ii,3] > 0)
            cntry1 = sigAdjList[ii,1]
            cntry1 = fixBadChars(cntry1)
            cntry2 = sigAdjList[ii,2]
            cntry2 = fixBadChars(cntry2)
            weight = sigAdjList[ii,3]
            if(side == "Lower")
                edges = string(edges,cntry1,"->",cntry2," [ color=red penwidth=$(weight)];")
            else
                edges = string(edges,cntry1,"->",cntry2," [ color=blue penwidth=$(weight)];")
            end
            
        end
        
    end
    
    #println(sigAdjList)
    return edges#string("France","->","Greece"," [ color=red penwidth=3];")
        
end



#from the dictionary produce the one way Avoids for the time windows in the dictionary keys
function produceOneWayGraphs(wAGLOW)
    for kk in keys(wAGLOW)
        if(kk[1] == '1' || kk[1] == '2')
            #No label as it is hard to predict the relative size of the font for the final output imae
            networkInit = "digraph avoid {  "    

            #pass the dictionary to obtain the graphviz string for the node descriptions (attributes color etc)
            nodeDescriptions = countryNodeDescriptorsOneWay(wAGLOW[kk])
            networkInit = string(networkInit, nodeDescriptions)

            #buildup the edges and edge attributes
            sigStr = countryEdges(wAGLOW[kk]["thresholdSigAdjList"],wAGLOW["side"])
            networkInit = string(networkInit,sigStr)

            #finalize the network dscription by the final identifier
            networkInit = string(networkInit, "}")

            alpha = wAGLOW["alpha"]
            #name for the dot file name and the network file name and output image
            side = wAGLOW["side"]
            fileName = string("network",side,"OneWay",kk,"alpha",alpha)
            writeGraphViz(fileName, networkInit)
        end
        println(kk)
    end    
end

#add the components of the country names and the descriptors for the one-way
#remove the non-participants
function countryNodeDescriptorsOneWay(dict_wAG)
    nodeDescriptor = ""
    countriesNamesTotal = dict_wAG["countries"]#dict_wAG["countriesNamesTotal"]
    println(countriesNamesTotal)

    sigAdj = dict_wAG["thresholdSigAdjList"]
    
    countriesNamesTotal = removeBadChars(countriesNamesTotal)
    for ii in 1:length(countriesNamesTotal)
       
        tmpCountry = countriesNamesTotal[ii]       
        for sigRow in 1:size(sigAdj,1)
            if(fixBadChars(sigAdj[sigRow,1]) == tmpCountry && sigAdj[sigRow,3] > 0)               
                nodeDescTmp = regionNodeString(tmpCountry)               
                nodeDescriptor = string(nodeDescriptor,tmpCountry,nodeDescTmp)                
                break
            elseif(fixBadChars(sigAdj[sigRow,2]) == tmpCountry && sigAdj[sigRow,3] > 0)               
                nodeDescTmp = regionNodeString(tmpCountry)               
                nodeDescriptor = string(nodeDescriptor,tmpCountry,nodeDescTmp)               
                break
            end            
       end
    end
    
    return nodeDescriptor
end
#=
cntry1 = sigAdjList[ii,1]
cntry1 = fixBadChars(cntry1)
if( (count(seen[:] .== cntry1) == 0) )
nodeTmp1 = regionNodeString(cntry1)                                
nodes = string(nodes,cntry1,nodeTmp1)
seen = vcat(seen,cntry1)
end
=#


#construct the string of the country pairs and the edge attributes
#takes an AdjList
function countryEdges(sigAdjList,side)
    edges = ""
    for ii in 1:size(sigAdjList,1)
        if(sigAdjList[ii,3] > 0)
            cntry1 = sigAdjList[ii,1]
            cntry1 = fixBadChars(cntry1)
            cntry2 = sigAdjList[ii,2]
            cntry2 = fixBadChars(cntry2)
            if(side == "Lower")
                edges = string(edges,cntry1,"->",cntry2," [ color=red penwidth=1];")
            else
                edges = string(edges,cntry1,"->",cntry2," [ color=blue penwidth=1];")
            end
            
        end
        
    end
    
    #println(sigAdjList)
    return edges#string("France","->","Greece"," [ color=red penwidth=3];")
        
end



#give the .dot file to graphviz and make the png file AND NOW PDF as well
function writeGraphViz(filename, networkInit)
    fileNameDot = string(filename,".dot")
    
    filePNG = string(filename,".png")
    filePDF = string(filename,".pdf")
    
    writedlm(string(fileNameDot), [networkInit])
    
    #filePNGrel = string("./graphs/",filePNG)
    #println(filePNGrel)
    run(`dot $fileNameDot -Tpng -o $filePNG`)
    run(`mv $filePNG ./graphs/`)
    #run(`mv $fileNameDot ./graphs/`)

    run(`dot $fileNameDot -Tpdf -o $filePDF`)
    run(`mv $filePDF ./graphs/`)
    #move after use
    run(`mv $fileNameDot ./graphs/`)
end


#add the components of the country names and the descriptors
function countryNodeDescriptors(dict_wAG)
    nodeDescriptor = ""
    countriesNamesTotal = dict_wAG["countries"]#dict_wAG["countriesNamesTotal"]
    println(countriesNamesTotal)
    
    countriesNamesTotal = removeBadChars(countriesNamesTotal)
    for ii in 1:length(countriesNamesTotal)
        tmpCountry = countriesNamesTotal[ii]
        #println(tmpCountry)
        nodeDescTmp = regionNodeString(tmpCountry)
        #println(nodeDescTmp)
        nodeDescriptor = string(nodeDescriptor,tmpCountry,nodeDescTmp)
    end
    
    return nodeDescriptor
end


#add the components of the country names and the descriptors
#produceTotalOneWayGraphs(wAGLOW)!!!
function countryNodeDescriptorsTotalOneWay(wAGLOW)
    nodeDescriptor = ""
    nodes = ""
    seen = []    
    #countriesNamesTotal = wAGLOW["countriesNamesTotal"]#dict_wAG["countriesNamesTotal"]
    for kk in keys(wAGLOW)
        if(kk[1] == '1' || kk[1] == '2')
            (wAGLOW[kk]["thresholdSigAdjList"])
            
            sigAdjList = wAGLOW[kk]["thresholdSigAdjList"]
            
            for ii in 1:size(sigAdjList,1)
                if(sigAdjList[ii,3] > 0)         
                    cntry1 = sigAdjList[ii,1]
                    cntry1 = fixBadChars(cntry1)
                    if( (count(seen[:] .== cntry1) == 0) )
                        nodeTmp1 = regionNodeString(cntry1)                                
                        nodes = string(nodes,cntry1,nodeTmp1)
                        seen = vcat(seen,cntry1)
                    end
                    #if only receive
                    cntry2 = sigAdjList[ii,2]
                    cntry2 = fixBadChars(cntry2)
                    if( (count(seen[:] .== cntry2) == 0) )
                        nodeTmp2 = regionNodeString(cntry2)                                
                        nodes = string(nodes,cntry2,nodeTmp2)
                        seen = vcat(seen,cntry2)
                    end

                end
                                
            end    
        end
    end
    return nodes#nodeDescriptor
end


function fixBadChars(str_Pre)
       
    strPre = replace(str_Pre,"&"=>"")
    strPre = replace(strPre,"."=>"")
    strPre =  replace(strPre," "=>"")
        
    return strPre
end


#take an array and return the fixed name
function removeBadChars(strs_Pre)
    
    for ii in 1:length(strs_Pre)
        strPre = strs_Pre[ii]
        strPre = replace(strPre,"&"=>"")
        strPre = replace(strPre,"."=>"")
        strPre =  replace(strPre," "=>"")
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
    elseif(countryInput in other)        
        nodeStr = " [style=filled,fillcolor=whitesmoke]; "
    else
        nodeStr = " [style=filled,fillcolor=whitesmoke]; "
        print("country to region not found: ")
        println(countryInput)
    end
    
    return nodeStr
end


#NOW FOR THE MUTUAL ONE WAY

#from the dictionary produce the Mutual Avoids for the time windows in the dictionary keys
function produceMutualTwoWayGraphs(wAGLOW)
    for kk in keys(wAGLOW)
        if(kk[1] == '1' || kk[1] == '2')
            #make it a digraph for bi directional edges
            networkInit = "digraph avoid {  "    

            #pass the dictionary to obtain the graphviz string for the node descriptions (attributes color etc)
            nodeDescriptions = countryNodeDescriptorsMutualAvoid(wAGLOW[kk]["thresholdSigAdjList"])
            networkInit = string(networkInit, nodeDescriptions)

            #buildup the edges and edge attributes
            sigStr = countryEdgesMutual(wAGLOW[kk]["thresholdSigAdjList"],wAGLOW["side"])
            networkInit = string(networkInit,sigStr)

            #finalize the network dscription by the final identifier
            networkInit = string(networkInit, "}")
            alpha = wAGLOW["alpha"]
            #name for the dot file name and the network file name and output image
            side = wAGLOW["side"]
            
            fileName = string("network",side,"TwoWay",kk,"alpha",alpha)
            writeGraphViz(fileName, networkInit)
        end
        println(kk)
    end    
end

function countryNodeDescriptorsMutualAvoid(sigAdjList)
    nodes = ""
    for ii in 1:size(sigAdjList,1)
        if(sigAdjList[ii,3] > 0)         
            for jj in ii+1:size(sigAdjList,1)
                if( (sigAdjList[ii,1]==sigAdjList[jj,2]) && (sigAdjList[ii,2]==sigAdjList[jj,1]) && (sigAdjList[jj,3] > 0))
                    cntry1 = sigAdjList[ii,1]
                    cntry1 = fixBadChars(cntry1)
                    cntry2 = sigAdjList[ii,2]
                    cntry2 = fixBadChars(cntry2)
                    nodeTmp1 = regionNodeString(cntry1)
                    nodeTmp2 = regionNodeString(cntry2)
                    nodes = string(nodes,cntry1,nodeTmp1,cntry2,nodeTmp2)
                end
            end
            
        end        
    end
    return nodes
end



#construct the string of the country pairs and the edge attributes
#takes an AdjList
function countryEdgesMutual(sigAdjList,side)
    edges = ""
    for ii in 1:size(sigAdjList,1)
        if(sigAdjList[ii,3] > 0)
            
            for jj in ii+1:size(sigAdjList,1)
                if( (sigAdjList[ii,1]==sigAdjList[jj,2]) && (sigAdjList[ii,2]==sigAdjList[jj,1]) && (sigAdjList[jj,3] > 0))
                    cntry1 = sigAdjList[ii,1]
                    cntry1 = fixBadChars(cntry1)
                    cntry2 = sigAdjList[ii,2]
                    cntry2 = fixBadChars(cntry2)
                    if(side == "Lower")
                        edges = string(edges,cntry1,"->",cntry2," [dir=both color=red penwidth=1];")
                    else
                        edges = string(edges,cntry1,"->",cntry2," [dir=both color=blue penwidth=1];")
                    end
                    
                end
            end
            
        end
        
    end
    
    #println(sigAdjList)
    return edges#string("France","->","Greece"," [ color=red penwidth=3];")
        
end


#total mutual avoid graphs for the two ways to produce the weighted edge graph
#this only counts the years where the significance was aligned as a threshold
function produceTotalMutualTwoWayGraphs(wAGLOW)
    #start the network .dot file
    networkInit = "digraph avoid {  "    
    
    nodeDescriptions = countryNodeDescriptorsTotalMutualAvoid(wAGLOW)
    networkInit = string(networkInit, nodeDescriptions)

    #buildup the edges and edge attributes
    sigStr = countryMutualEdgesTotal(wAGLOW)
    networkInit = string(networkInit,sigStr)
    
    #finalize the network dscription by the final identifier
    networkInit = string(networkInit, "}")
    
    #name for the dot file name and the network file name and output image
    keys1 = [(if(kk[1]=='1' || kk[1] == '2'); kk;end)  for kk in keys(wAGLOW)]
    keys1 = keys1[keys1 .!= nothing]
    yearsWin = [split(k1,"-") for k1 in keys1]
    years = vcat(yearsWin)
    years = [j for i in years for j in i]    
    years = sort(years)
    yearMin = parse(Int,years[1])    
    yearMax = parse(Int,years[end])    
    
    #=if(length(years)>2)
        winYears = convert(Int, (yearMax - yearMin) / (length(years)-2))
    else
        winYears = (yearMax - yearMin)
    end=#
    winYears = wAGLOW["windowSize"]
    
    alpha = wAGLOW["alpha"]
    side = wAGLOW["side"]
    
    fileName = string("networkMutual",side,"Total",yearMin,"to",yearMax,"win",winYears,"alpha",alpha)
    writeGraphViz(fileName, networkInit)
    
    
    println(networkInit)
    
end

#the total mutual avoid country name set 
function countryNodeDescriptorsTotalMutualAvoid(wAGLOW)
    nodes = ""
    seen = []
    for kk in keys(wAGLOW)
        if(kk[1] == '1' || kk[1] == '2')

            #get the window
            sigAdjList = wAGLOW[kk]["thresholdSigAdjList"]

            for ii in 1:size(sigAdjList,1)
                if(sigAdjList[ii,3] > 0)         
                    for jj in ii+1:size(sigAdjList,1)
                        if( (sigAdjList[ii,1]==sigAdjList[jj,2]) && (sigAdjList[ii,2]==sigAdjList[jj,1]) && (sigAdjList[jj,3] > 0))
                            cntry1 = sigAdjList[ii,1]
                            cntry1 = fixBadChars(cntry1)
                            cntry2 = sigAdjList[ii,2]
                            cntry2 = fixBadChars(cntry2)
                            if( (count(seen[:] .== cntry1) == 0) && (count(seen[:] .== cntry2) == 0) )
                                nodeTmp1 = regionNodeString(cntry1)
                                nodeTmp2 = regionNodeString(cntry2)
                                nodes = string(nodes,cntry1,nodeTmp1,cntry2,nodeTmp2)
                                seen = vcat(seen,cntry1)
                                seen = vcat(seen,cntry2)
                            elseif( (count(seen[:] .== cntry1) == 0) )
                                nodeTmp1 = regionNodeString(cntry1)                                
                                nodes = string(nodes,cntry1,nodeTmp1)
                                seen = vcat(seen,cntry1)
                            elseif( (count(seen[:] .== cntry2) == 0) )
                                nodeTmp2 = regionNodeString(cntry2)                                
                                nodes = string(nodes,cntry2,nodeTmp2)
                                seen = vcat(seen,cntry2)
                            end
                        end
                    end
                    
                end        
            end
        end
    end    
    return nodes
end


#look not for the total edges between, but the times the mutual avoid coincided
function countryMutualEdgesTotal(wAGLOW)
    edges = ""
    #store in an adj list the country pairings, I will add the edges in incrementally in a stack like adjlist
    #their order
    mutualAdjList = []
    for kk in keys(wAGLOW)
        if(kk[1] == '1' || kk[1] == '2')
            sigAdjList = wAGLOW[kk]["thresholdSigAdjList"]#every time window there will be at most 1 mutual edge
            
            for ii in 1:size(sigAdjList,1)
                if(sigAdjList[ii,3] > 0)            
                    for jj in ii+1:size(sigAdjList,1)
                        if( (sigAdjList[ii,1]==sigAdjList[jj,2]) && (sigAdjList[ii,2]==sigAdjList[jj,1]) && (sigAdjList[jj,3] > 0))
                            cntry1 = sigAdjList[ii,1]
                            cntry1 = fixBadChars(cntry1)
                            cntry2 = sigAdjList[ii,2]
                            cntry2 = fixBadChars(cntry2)
                            #must only add a row if it is not already in there
                            #permuted possible orderings as a concatenation
                            #println(mutualAdjList)
                            if( isempty(mutualAdjList) )
                                #println(size(mutualAdjList))
                                
                                mutualAdjList = vcat([cntry1 cntry2 cntry1*cntry2 cntry2*cntry1 1])
                                #println("in if for isempty")
                                #println([cntry1 cntry2 cntry1*cntry2 cntry2*cntry1 1])
                            elseif( count(mutualAdjList[:,3] .== cntry1*cntry2) > 0 )
                                ind = findall(mutualAdjList[:,3] .== cntry1*cntry2)
                                mutualAdjList[ind,5] .+= 1
                                #println("in elseif for cntry1*cntry2")
                                #println(mutualAdjList[ind,:])
                            elseif( count(mutualAdjList[:,3] .== cntry2*cntry1) > 0 )
                                ind = findall(mutualAdjList[:,3] .== cntry2*cntry1)
                                mutualAdjList[ind,5] .+= 1
                                #println("in elseif for cntry2*cntry1")
                                #println(mutualAdjList[ind,:])
                            else 
                                mutualAdjList = vcat(mutualAdjList,[cntry1 cntry2 cntry1*cntry2 cntry2*cntry1 1])
                                #println("in else new row addition")
                                #println([cntry1 cntry2 cntry1*cntry2 cntry2*cntry1 1])
                            end
                        end
                    end
                end            
            end        
        end
    end    
    #look at every first occurance and burn the downstream similar ones counting their contribution
    #and pass over the first so that the end of the down stream jj loop has the edge added in 
    side = wAGLOW["side"]
    for ii in 1:size(mutualAdjList,1)
        cntry1 = mutualAdjList[ii,1]
        cntry2 = mutualAdjList[ii,2]
        weight = mutualAdjList[ii,5]
        weight = weight + 1.5*(weight-1)
        if(side == "Lower")
            edges = string(edges,cntry1,"->",cntry2," [dir=both color=red penwidth=$(weight)];")
        else
            edges = string(edges,cntry1,"->",cntry2," [dir=both color=blue penwidth=$(weight)];")
        end
        
    end    
    println(mutualAdjList)                               
    #edges = string(edges,cntry1,"->",cntry2," [ color=red penwidth=$(weight)];")
    return edges#string("France","->","Greece"," [ color=red penwidth=3];")        
end




#=
countriesNamesTotal = removeBadChars(countriesNamesTotal)
for ii in 1:length(countriesNamesTotal)
tmpCountry = countriesNamesTotal[ii]
nodeDescTmp = regionNodeString(tmpCountry)
nodeDescriptor = string(nodeDescriptor,tmpCountry,nodeDescTmp)
end
=#    
