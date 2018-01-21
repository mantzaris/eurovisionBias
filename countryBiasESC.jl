#GOALS
#1 examine biases over a set of years because many things change
#2 compare the biases and rank them
#3 look for consistency in the bias distribution
#4 plot the bias ranking for countries as they appear in time series
#5 plot percentage of accumulated score of bias
#6 look at the high ranking as well as the low ranking
#7 table for the symmetric ignoring



#>>MAIN<<
function biasesESC(startYr = 1980, endYr = 1990, windowSize = 5, tailSide = "upper", alpha = 0.05)

    #load data and get the dictionary for the country num per year
    countryYearsNum, yrMin, yrMax = dataCountryYearsNum()
    
    #check params
    paramCheck(startYr, endYr, windowSize, yrMin, yrMax,tailSide)

    #simulate scores to create a distribution
    windowDist = scoreSimDist(startYr, endYr, windowSize, countryYearsNum)
    println(windowDist)
    #get confidence intervals for the lower or upper end
    windowConf = windowConfValues(startYr, endYr, windowSize, windowDist, tailSide, alpha)
    
    #We need to have the CSV data read
end


#return the year windows' confidence interval values specified
function windowConfValues(startYr, endYr, windowSize, windowDist, tailSide, alpha)

    if(tailSide == "upper" || tailSide == "right")
        alpha = 1 - alpha
    end
    
    windowConf = Dict() #hold the distribution of the scores
    yr = startYr
    while( (yr+windowSize) <= endYr )
        #each window is a null dist unique due to the voting schemes
        #simulate the scores for the dist
        distTmp = windowDist[string(yr,"-",yr+windowSize)]
        sampleSize = length(distTmp)
        confIndAlpha =  max(1,floor(Int,alpha*sampleSize))
        confalpha = distTmp[confIndAlpha]
       
        windowConf[string(yr,"-",yr+windowSize)] = confalpha
        yr = yr + windowSize
    end
    
    return windowConf
    
end



#return the year windows of distributions for scores
function scoreSimDist(startYr, endYr, windowSize, countryYearsNum)

    #Generate NULL distribution for each set of years in the windows
    windowDist = Dict() #hold the distribution of the scores
    yr = startYr
    while( (yr+windowSize) <= endYr )
        #each window is a null dist unique due to the voting schemes
        #simulate the scores for the dist
        distTmp = scoreSim(yr,yr+windowSize,countryYearsNum)     
        windowDist[string(yr,"-",yr+windowSize)] = distTmp
        yr = yr + windowSize
    end
    
    return windowDist
end


#simulate the score distribution for each window span provided
function scoreSim(startYr,endYr,countryYearsNum)
    AVG_SIMULATION = []
    iterNum = 2000
    for ii = 1:iterNum
        ONE_SIMULATION = []
        for yr = startYr:endYr
            NUM = countryYearsNum[yr]
	    if(yr >= 1975 || yr == 1963 || yr == 1962)       
                score = Allocated(yr,NUM);

            elseif( (1964<=yr<= 1966) || yr==1974 || (1967<=yr<=1970) || (1957<=yr<=1961))
                score = Sequential(yr,NUM)
            elseif(1971<=yr<=1973)
                score = Rated(yr,NUM)
            else
                score = Allocated(-1,NUM)
            end
            append!(ONE_SIMULATION,score);

        end
        avgSim = mean(ONE_SIMULATION);
        append!(AVG_SIMULATION,avgSim);
    end
    sortedAVG_SIMULATION = sort(AVG_SIMULATION,rev=false)#returns low to high

    return sortedAVG_SIMULATION
end 



#here each country can receive a set of scores with consecutive points awarded
#in sequence for that year it has an equal chance of receiving each score
function Sequential(yr,NUM)
    SCORES1 = [5,3,1]
    SCORES2 = ones(Int,1,10)
    score = 0    
    if(1964 <= yr <= 1966)
        for ii=1:length(SCORES1)         
            position = ceil.(rand(1,1)*NUM)
            if((Int.(position))[1] == 1)               
                score = SCORES1[ii] + score            
            end                                        
        end
    elseif(yr==1974 || (1967<=yr<=1970) || (1957<=yr<=1961))
        for ii=1:length(SCORES2)
            position = ceil.(rand(1,1)*NUM)
            if((Int.(position))[1] == 1)
                score = SCORES2[ii] + score
            end                                        
        end
    end
    return score
    
end

function Allocated(yr,NUM)
    SCORES1 = [3,2,1]
    SCORES2 = [5,4,3,2,1]
    SCORES3 = [12,10,8,7,6,5,4,3,2,1]
    position = ceil.(rand(1,1)*NUM)
    if(yr >= 1975 && yr <= 2016)
        SCORES = SCORES3
    elseif(yr == 1962)
        SCORES = SCORES1
    elseif(yr == 1963)
        SCORES = SCORES2
    else
        SCORES = SCORES3
    end    
    if(position[1] <= length(SCORES))
        score = SCORES[Int.(position)]	       
    else
        score = 0
    end
    return score
end

function Rated(yr,NUM)
    SCORES1 = [5,4,3,2,1]
    if(1971<=yr<=1973)
        X1 = SCORES1[rand(1:end)]
        X2 = SCORES1[rand(1:end)]
    else
        return -1
    end
    score = X1 + X2
    return score
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
function paramCheck(startYr, endYr, windowSize, yrMin, yrMax, tailSide)
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
    if( (startYr+windowSize) > endYr)
        print("not enough years between start and end for analysis due to window size")
        quit()
    end
    println(tailSide)
    if(!(tailSide != "upper" || tailSide != "right" || tailSide != "lower" || tailSide != "left"))
        println("define the tailside with either \"upper\" / \"lower\" / \"right\" / \"left\" ")
        exit()
    end
    
end
