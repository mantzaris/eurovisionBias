#Doing things another way, even if not better, not over thinking this, which is not what a programming mindset is supposed to do, but jumping in.


#produce a key which counts the total number of significant counts for each pair across the windows were found
function dictTotalThresholdsAdjListWindowCount(winAggDict,startYr,endYr,windowSize)
    #a new dictionary which is non-windows
    #winDictTotal = Dict()
    
    #create the structure of the adjacency list where we will add the counts found to for each pair
    #produce an initialized country pairing adjacency list for the threshold passings, the window interval is not used, as we need the full country pairings, not the window subset
    thresholdSignificantAdjListTOTAL = initCountryPairAdjList(startYr,endYr)
    
    #loop through the keys of the Dict to add the significant pairs to the 
    yr = startYr
    while( (yr+windowSize) <= endYr )
        
        threshSigAdjListTMP = winAggDict["$(yr)-$(yr+windowSize)"]["thresholdSigAdjList"]
        for rowIndWin in 1:size(threshSigAdjListTMP,1)#look through every pairing in this window
            for rowIndTotal in 1:size(thresholdSignificantAdjListTOTAL,1)
                if((thresholdSignificantAdjListTOTAL[rowIndTotal,1] == threshSigAdjListTMP[rowIndWin,1]) && (thresholdSignificantAdjListTOTAL[rowIndTotal,2] == threshSigAdjListTMP[rowIndWin,2]))
                    thresholdSignificantAdjListTOTAL[rowIndTotal,3] += threshSigAdjListTMP[rowIndWin,3]
                end
                
            end
            
        end
        
    	yr = yr + windowSize
    end      
    
    #add the accumulated significance total to the dictionary
    winAggDict["thresholdSignificantAdjListTOTAL"] = thresholdSignificantAdjListTOTAL

    #also add the full total country pairing name list for the window set
    winAggDict["countriesNamesTotal"] = subsetCountryNamesArray(startYr,endYr)

    return winAggDict
end


#use the windowConf dictionary which has the threshold values for significance of the average values to determine for each window which country pairings were significant in a new window key 'thresholdSignificantAdjList'
function windowsDictThresholdsAdjList(windowConf, startYr = 1980, endYr = 1990, windowSize = 5)
    #from the csv data build the dictionary for the basic information on the country pair lists, aggregate scores and average of the aggregate scores
    winAggDict = windowsDictScoreAdjList(startYr, endYr, windowSize)
    #println(keys(winAggDict["1980-1985"]))#["1980-1985"]["countries"])
    #println(winAggDict["1980-1985"]["avgScoreAggregateAdjList"])
    #windowConf is a dictionary with the window keys as winDicts here, and each window has a particular threshold
    #extract the threshold, extract the average score matrix, produce an init country pairing adjacency matrix and then put it as a threshold passings component to the dictionary
    yr = startYr
    while( (yr+windowSize) <= endYr )
        #get the threshold value (float)
        thresholdTmp = windowConf["$(yr)-$(yr+windowSize)"]
        #extract the average of the aggregate (adjacency list of country pairs)
        avgAggAdjList = winAggDict["$(yr)-$(yr+windowSize)"]["avgScoreAggregateAdjList"]
        #produce an initialized country pairing adjacency list for the threshold passings
        thresholdSignificantAdjList = initCountryPairAdjList(yr,yr+windowSize)#(startYr,endYr)#!!!!!XXXX
        #now set the pairs of country rows for each significant pair to 1 from 0
        #HERE we do the THRESHOLD COMPARISON
        if(windowConf["tailSide"]=="upper" || windowConf["tailSide"]=="right")
            #println("upper")
            for rowInd in 1:size(avgAggAdjList,1)
                if(avgAggAdjList[rowInd,3] >= thresholdTmp)
                    thresholdSignificantAdjList[rowInd,3] = 1
                end            
            end
        else
            #println("lower")
            for rowInd in 1:size(avgAggAdjList,1)
                if(avgAggAdjList[rowInd,3] <= thresholdTmp)
                    thresholdSignificantAdjList[rowInd,3] = 1
                end            
            end
        end
        #=
        for rowInd in 1:size(avgAggAdjList,1)
            if(avgAggAdjList[rowInd,3] >= thresholdTmp)
                thresholdSignificantAdjList[rowInd,3] = 1
            end            
        end
        =#
        winAggDict["$(yr)-$(yr+windowSize)"]["thresholdSigAdjList"] = thresholdSignificantAdjList
	yr = yr + windowSize
    end  
    return winAggDict
        
end




#Given the total time interval, and windowSize, produce a dictionary for each window
#Returned is a dictionary for the time windows
#"countries" key is the unique list of country names for that window
#"scoreAggregateAdjList" key is the aggregate for the country pairs in each window
function windowsDictScoreAdjList(startYr = 1980, endYr = 1990, windowSize = 5)

    winDict = Dict()
    yr = startYr
    while( (yr+windowSize) <= endYr )
	winDict["$(yr)-$(yr+windowSize)"] = Dict()
	winDict["$(yr)-$(yr+windowSize)"]["countries"] = subsetCountryNamesArray(yr,yr+windowSize)#(startYr,endYr)
        aggAdjList = aggregateAdjList(yr,yr+windowSize)#(startYr,endYr)
	winDict["$(yr)-$(yr+windowSize)"]["scoreAggregateAdjList"] = aggAdjList
        #compute the average over the window for the scores
        avgAggAdjList = initCountryPairAdjList(yr,yr+windowSize)#(startYr,endYr)
        avgAggAdjList[:,3] = aggAdjList[:,3].*(1/(windowSize+1))
        winDict["$(yr)-$(yr+windowSize)"]["avgScoreAggregateAdjList"] = avgAggAdjList
        
	yr = yr + windowSize
    end  
    return winDict
end


#create and return an adjacency country pair list with initially zero for the scores
function initCountryPairAdjList(startYr = 1980, endYr = 1990)

    adjList = yearsScoreAdjList(startYr, endYr)
    cntryNames = subsetCountryNamesArray(startYr,endYr)
    countryNum = length(cntryNames)
    aggregateAdjList = Array{Any}(countryNum^2 - countryNum, 3)
    #INIT: fill the names and initial aggregate scores
    tmpRow = 1
    for ii in 1:length(cntryNames) #over each first cycle of countries
        for jj in 1:length(cntryNames) #over second cycle of countries
            if(ii != jj)                
                aggregateAdjList[tmpRow,:] = [cntryNames[ii] cntryNames[jj] 0]
                tmpRow = tmpRow + 1
            end                    
        end        
    end
    return aggregateAdjList
end




#produce the aggregate score for the 'to-and-from' from the adjacency list so that we have the unique pairings and total scores
function aggregateAdjList(startYr = 1980, endYr = 1990)

    adjList = yearsScoreAdjList(startYr, endYr)
    cntryNames = subsetCountryNamesArray(startYr,endYr)
    countryNum = length(cntryNames)
    aggregateAdjList = Array{Any}(countryNum^2 - countryNum, 3)
    #INIT: fill the names and initial aggregate scores
    tmpRow = 1
    for ii in 1:length(cntryNames) #over each first cycle of countries
        for jj in 1:length(cntryNames) #over second cycle of countries
            if(ii != jj)                
                aggregateAdjList[tmpRow,:] = [cntryNames[ii] cntryNames[jj] 0]
                tmpRow = tmpRow + 1
            end                    
        end        
    end
    #FILL: the scores for the AdjList
    adjListTotal = yearsScoreAdjList(startYr, endYr)
    for ii in 1:size(aggregateAdjList,1)#look at every country pair        
        for rowInd in 1:size(adjListTotal,1)            
            if((aggregateAdjList[ii,1]==adjListTotal[rowInd,1]) && (aggregateAdjList[ii,2]==adjListTotal[rowInd,2]))
                aggregateAdjList[ii,3] = aggregateAdjList[ii,3] + adjListTotal[rowInd,4]
            end                            
        end       
    end
    return aggregateAdjList
end




#look at the directory and load every year in the range of the .csv files, then produce a final matrix(adjacency list) which is every year in the countryFrom|countryTo|year|score for this 'subset'
function yearsScoreAdjList(startYr = 1980, endYr = 1990)
    dirFiles = readdir("./dataTables/")
    adjMatScore = []
    for dF in dirFiles
        yrTmp = parse(Int,((split(dF,"."))[1]))
        if(yrTmp < startYr || yrTmp > endYr)
            continue
        end
        fileTmp = open(string("./dataTables/",dF))
        linesTmp = readlines(fileTmp)#read each file lines
        origColNames = split(linesTmp[1],r",|\n",keep=false)#get line1 into components      
        for ii=2:length(linesTmp)#get the names on the rows
            rowTmp = split(linesTmp[ii],r",|\n",keep=false)
            for jj=2:length(origColNames)
                if(ii!=jj)
                    #print("$(rowTmp[1])->$(origColNames[jj])=$(rowTmp[jj]),")
                    if(isempty(adjMatScore) == true)
                        adjMatScore = Array{Any}(1,4)
                        adjMatScore[1,:] = [rowTmp[1],origColNames[jj],yrTmp,parse(Int,rowTmp[jj])]
                    else
                        #println([rowTmp[1],origColNames[jj],yrTmp,parse(Int,rowTmp[jj])])
                        adjMatScore = vcat(adjMatScore , [rowTmp[1] origColNames[jj] yrTmp parse(Int,rowTmp[jj])])
                    end                    
                end                
            end            
        end
       
    end
    return adjMatScore   
end






#look at the directory and load every .csv file, then produce a final matrix which is the countryFrom|countryTo|year|score
function totalScoreAdjList()   
    dirFiles = readdir("./dataTables/")
    adjMatScore = []
    ind = 1
    for dF in dirFiles
        yrTmp = parse(Int,((split(dF,"."))[1]))
        
        fileTmp = open(string("./dataTables/",dF))
        linesTmp = readlines(fileTmp)#read each file lines
        origColNames = split(linesTmp[1],r",|\n",keep=false)#get line1 into components      
        for ii=2:length(linesTmp)#get the names on the rows
            rowTmp = split(linesTmp[ii],r",|\n",keep=false)
            for jj=2:length(origColNames)
                if(ii!=jj)
                    #print("$(rowTmp[1])->$(origColNames[jj])=$(rowTmp[jj]),")
                    if(isempty(adjMatScore) == true)
                        adjMatScore = Array{Any}(1,4)
                        adjMatScore[1,:] = [rowTmp[1],origColNames[jj],yrTmp,parse(Int,rowTmp[jj])]
                    else
                        #println([rowTmp[1],origColNames[jj],yrTmp,parse(Int,rowTmp[jj])])
                        adjMatScore = vcat(adjMatScore , [rowTmp[1] origColNames[jj] yrTmp parse(Int,rowTmp[jj])])
                    end                    
                end                
            end            
        end
       
    end
    return adjMatScore   
end



#return an array of unique country names for the time period
function subsetCountryNamesArray(stYr,endYr)
    #get the dictionary of the year and names
    countryNamesYrDict = subsetHeaderNames(stYr,endYr)
    totalNames = []
    for yearTmp in keys(countryNamesYrDict)
        totalNamesTmp = countryNamesYrDict[yearTmp]
        append!(totalNames,totalNamesTmp)
    end
    return sort(unique(totalNames))
    
end


#search the directory for the countries in the specific years listed; return dictionary of the year to names of countries
function subsetHeaderNames(stYr,endYr)
    dirFiles = readdir("./dataTables/")
    namesDict = Dict()
    
    for dF in dirFiles
        yrTmp = parse(Int,((split(dF,"."))[1]))
        if(stYr <= yrTmp <= endYr)            
            fileTmp = open(string("./dataTables/",dF))
            linesTmp = readlines(fileTmp)#read each file lines
            origColNames = split(linesTmp[1],r",|\n",keep=false)#get line1 into components
            splice!(origColNames,1)#get rid of topleft corner
            rowNAMES = []#temp store
            for ii=2:length(linesTmp)#get the names on the rows
                rowNAMEStmp = split(linesTmp[ii],r",|\n",keep=false)
                append!(rowNAMES, [rowNAMEStmp[1]])
            end
            totalNamesYr = sort(unique(append!(rowNAMES,origColNames)))#for yrTmp names
            namesDict[yrTmp] = totalNamesYr#
        end
    end
    return namesDict
end



#search the directory for the complete set of countries having appeared
function totalHeaderNames()
    dirFiles = readdir("./dataTables/")
    namesDict = Dict()
    
    for dF in dirFiles
        yrTmp = parse(Int,((split(dF,"."))[1]))
        fileTmp = open(string("./dataTables/",dF))
      	linesTmp = readlines(fileTmp)#read each file lines
        origColNames = split(linesTmp[1],r",|\n",keep=false)#get line1 into components
        splice!(origColNames,1)#get rid of topleft corner
        rowNAMES = []#temp store
        for ii=2:length(linesTmp)#get the names on the rows
            rowNAMEStmp = split(linesTmp[ii],r",|\n",keep=false)
            append!(rowNAMES, [rowNAMEStmp[1]])
        end
        totalNamesYr = sort(unique(append!(rowNAMES,origColNames)))#for yrTmp names
        namesDict[yrTmp] = totalNamesYr#
        
    end
    return namesDict
end
