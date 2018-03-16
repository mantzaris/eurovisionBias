#Doing things another way, even if not better, not over thinking this, which is not what a programming mindset is supposed to do, but jumping in.


#Given the total time interval, and windowSize, produce a dictionary for each window
#Returned is a dictionary for the time windows
function windowsDictScoreAdjList(startYr = 1980, endYr = 1990, windowSize = 5)

    winDict = Dict()
    yr = stYr
    while( (yr+windowSize) <= endYr )
	winDict["$(yr)-$(yr+windowSize)"] = Dict()
	winDict["$(yr)-$(yr+windowSize)"]["countries"] =  subsetCountryNamesArray(stYr,endYr)
	winDict["$(yr)-$(yr+windowSize)"]["scoremat"] = []
	yr = yr + windowSize
    end

end



#look at the directory and load every year in the range of the .csv files, then produce a final matrix which is the countryFrom|countryTo|year|score for this 'subset'
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
    return unique(totalNames)
    
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
