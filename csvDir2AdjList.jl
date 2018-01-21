
#look at the directory and load every .csv file, then produce a final matrix which is the countryFrom|countryTo|year|score
function processDir(dirName = 'dataTables')
    
    dirFiles = readdir("./dataTables/")
    #get the totalNames of every country listed in the CSVs
    namesDict = totalHeaderNames(dirFiles)
    
    
    
end


#search the directory for the complete set of countries having appeared
function totalHeaderNames(dirFiles)

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
