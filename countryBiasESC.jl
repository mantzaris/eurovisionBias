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

    #load data
    dataParse()
    
    #check params
    paramCheck(startYear, endYr)
    
end


#fn to iterate over the ESC datafiles
function dataParse()
    resultsFile = readdir("./dataTables/")
    yrMin = 100000
    yrMax = -1
    for rf in resultsFile
        
        
    end


end





#fn to accept the parameters and check for the validity
function paramCheck(startYear, endYr)
    if(startYear >= endYr)
        println("the start year needs to be before the end year")
        return -1
    end
    if((startYear+4) >= endYr)
        println("the start year needs to be at least 4 years prior the end year")
    end
    
    
end
