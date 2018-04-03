
#we want the coloring of the nodes to be the same as the graphs to make it an easy look up
#have the init set up the arrays of the country region labels
southWest = ["Portugal","Spain","Malta","SanMarino","Andorra","Monaco","Morocco","Italy"]
north = ["Iceland","Denmark","Norway","Sweden","Finland"]
northWest = ["UnitedKingdom","Ireland","Belgium","France","Luxembourg"]
central = ["Germany","Austria","TheNetherlands","Switzerland","Slovenia","CzechRepublic","Hungary","Slovakia"]
southEast = ["Greece","Montenegro","Cyprus","Albania","Bulgaria","Croatia","BosniaHerzegovina","Turkey","FYRMacedonia","Romania","Serbia","Israel","Yugoslavia","SerbiaMontenegro"]
east = ["Russia","Ukraine","Moldova","Belarus","Poland","Georgia","Armenia","Azerbaijan","Estonia","Lithuania","Latvia"]
other = ["Australia"]


#so I am going to put in a dictionary pair tuple, for the low and high/upper. this will first look at a single window and count the NEGLECT total and then the PREFERENCE significance. printout the total for NEGLECT AND PREFERENCE : (RECEIVE AND PRODUCE)






#given a country string, it will check the region selection to return the node configuration color
function regionNodeString(countryInput)

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
    elseif(countryInput in other)        
        nodeStr = " [style=filled,fillcolor=whitesmoke]; "
    else
        
        print("country to region not found: ")
        println(countryInput)
    end
    
    return nodeStr
end
