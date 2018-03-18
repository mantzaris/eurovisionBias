#Doing things another way, even if not better, not over thinking this, which is not what a programming mindset is supposed to do, but jumping in.


#Given the total time interval, and windowSize, produce a dictionary for each window
#Returned is a dictionary for the time windows
#"countries" key is the unique list of country names for that window
#"scoreAggregateAdjList" key is the aggregate for the country pairs in each window
function windowsDictScoreAdjList(startYr = 1980, endYr = 1990, windowSize = 5)

    winDict = Dict()
    yr = startYr
    while( (yr+windowSize) <= endYr )
	winDict["$(yr)-$(yr+windowSize)"] = Dict()
	winDict["$(yr)-$(yr+windowSize)"]["countries"] = subsetCountryNamesArray(startYr,endYr)
        aggAdjList = aggregateAdjList(startYr,endYr)
	winDict["$(yr)-$(yr+windowSize)"]["scoreAggregateAdjList"] = aggAdjList
        #compute the average over the window for the scores
        avgAggAdjList = initCountryPairAdjList(startYr,endYr)
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