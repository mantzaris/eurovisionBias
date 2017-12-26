#GOALS
#1 examine biases over a set of years because many things change
#2 compare the biases and rank them
#3 look for consistency in the bias distribution
#4 plot the bias ranking for countries as they appear in time series
#5 plot percentage of accumulated score of bias
#6 look at the high ranking as well as the low ranking
#7 table for the symmetric ignoring



#MAIN<<
function biasesESC(startYear = 1980, endYr = 1990)

    #load data and get the dictionary for the country num per year
    countryYearsNum, yrMin, yrMax = dataCountryYearsNum()
    
    #check params
    paramCheck(startYear, endYr, yrMin, yrMax)
    println("$startYear, $endYr, $yrMin, $yrMax")
    println(countryYearsNum)
end


#get the years of the data provided and country number in each year
function dataCountryYearsNum()
    countryYearsNum = Dict{Integer,Integer}()
    resultsFile = readdir("./dataTables/")
    yrMin = 100000
    yrMax = -1
    for rf in resultsFile
        fileTmp = open(string("./dataTables/",rf))
        linesTmp = readlines(fileTmp)  #readfile lines
        yrTmp = parse(Int,((split(rf,"."))[1]))
        countryNumTmp = length(split(linesTmp[1],",")) - 1
        countryYearsNum[yrTmp] = countryNumTmp 
        close(fileTmp)
        if(yrTmp < yrMin)
            yrMin = yrTmp
        end
        if(yrTmp > yrMax)
            yrMax = yrTmp
        end
    end
        
    return countryYearsNum, yrMin, yrMax
end



#fn to accept the parameters and check for the validity
function paramCheck(startYr, endYr, yrMin, yrMax)
    if(startYr >= endYr)
        println("the start year needs to be before the end year")
        quit()
    end
    if((startYr+4) >= endYr)
        println("the start year needs to be at least 4 years prior the end year")
        quit()
    end
    #sanity check input years
    if( endYr < startYr || startYr < yrMin || endYr > yrMax )
        print(string("year range improperly set, for the analysis end year must be greater than start and the smallest year is $(yrMin) and largest $(yrMax) with smallest first"))
        quit()
    end
      
end
