#graphviz is the tool to draw the graphs. This tool takes a single string with all the features of the graph to draw into a complete graph.


#have the init set up the arrays of the country region labels
southWest = ["Portugal","Spain","Malta","SanMarino","Andorra","Monaco","Morocco","Italy"]
    north = ["Iceland","Denmark","Norway","Sweden","Finland"]
    northWest = ["UnitedKingdom","Ireland","Belgium","France","Luxembourg"]
    central = ["Germany","Austria","TheNetherlands","Switzerland","Slovenia","CzechRepublic","Hungary"]
    southEast = ["Greece","Montenegro","Cyprus","Albania","Bulgaria","Croatia","BosniaHerzegovina","Turkey","FYRMacedonia","Romania","Serbia","Israel","Yugoslavia"]
east = ["Russia","Ukraine","Moldova","Belarus","Poland","Georgia","Armenia","Azerbaijan","Estonia","Lithuania","Latvia"]



#make a function to start the graph
function graphAvoid()

    #make it a digraph for bi directional edges
    #No label as it is hard to predict the relative size of the font for the final output imae
    networkInit = "digraph{ graph "
    
    
    
    println("ok..")
    tmp = regionNodeString("Russia")
    println(tmp)

end



#given a country string, it will check the region selection to return the node configuration needed for graphviz
function regionNodeString(countryInput)
    println("ok2")
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
        end
    return nodeStr
end

