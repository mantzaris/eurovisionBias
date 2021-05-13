#just run this script to execute most of the functions

#eg. main(1980,1990,5,0.05)
function main(startYr = 1980, endYr = 1990, windowSize = 5, alpha = 0.05)
    #produces the plots for collusion 1 and 2 way
    include("demo.jl")
    demo(startYr,endYr,windowSize)

    #calls csvDir2AdjList.jl and returns 2 element array with the upper and lower which are the high score pairings and lower score pairings (collusion vs neglect)
    include("countryBiasESC.jl")
    biasESC_uppper_lower = biasesESC(startYr,endYr,windowSize,alpha)

    #generate the plots for the overall associations and trends
    include("biasAnalysis.jl")
    analyzeBiases(biasESC_uppper_lower[1],biasESC_uppper_lower[2])
    
    #produce the graphs of both analysis
    include("biasGraphView.jl")
    graphAvoid(biasESC_uppper_lower[1],biasESC_uppper_lower[2])

end
