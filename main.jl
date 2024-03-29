#just run this script to execute most of the functions

include("demo.jl")
include("countryBiasESC.jl")
include("biasAnalysis.jl")
include("biasGraphView.jl")
#eg. main(1980,1990,5,0.05)
function main(startYr = 1980, endYr = 1990, windowSize = 5, alpha = 0.05)

    try
        mkdir("./plots")      
    catch
        println("dirs exist")
    end
    try
        mkdir("./graphs/")      
    catch
        println("dirs exist")
    end
    try
        mkdir("./biasAssociationPlots")      
    catch
        println("dirs exist")
    end
    

    


    #produces the plots for collusion 1 and 2 way
    
    demo(startYr,endYr,windowSize)

    #calls csvDir2AdjList.jl and returns 2 element array with the upper and lower which are the high score pairings and lower score pairings (collusion vs neglect)
    
    biasESC_uppper_lower = biasesESC(startYr,endYr,windowSize,alpha)

    #generate the plots for the overall associations and trends
    
    analyzeBiases(biasESC_uppper_lower[1],biasESC_uppper_lower[2])
    
    #produce the graphs of both analysis
    
    graphAvoid(biasESC_uppper_lower[1],biasESC_uppper_lower[2])



    ############################
    try
        mkdir("./results")
    catch
        println("dirs exist")
    end
    try
        mkdir("./results/graphs")
    catch
        println("dirs exist")
    end
    try
        mkdir("./results/plots")
    catch
        println("dirs exist")
    end

    try
        cp("./plots/","./results/plots",force=true)
    catch
        println("can't mv to results")
    end
    try
        cp("./graphs","./results/graphs",force=true)
    catch
        println("can't mv to results")
    end
    
    
end
