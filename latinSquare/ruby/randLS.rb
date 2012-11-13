def generateRandLS(size,dim)
    #prgn = Random.new(0)
    prgn = Random.new(Random.new_seed)
    allVal = []
    for i in 1..dim
        allVal = allVal.push((1..size).to_a)
    end

    for i in 0...allVal.length
        allVal[i].shuffle!
    end
    valLS = allVal[0].zip(*allVal[1..-1])

    res = LS.new(valLS,size,dim)
    return res
end

def findBestLS(size,dim,nbTry=100,mode="normal", testInc=10,dist="l2")
    if (mode == "test")
        listBestVal=[]
    end
    minMax = 0
    bestLS = nil
    records = getReccord(size,dim,dist)
    allBest = records[0]
    myBest = records[1]
    for i in 1..nbTry
        if (i%1000 == 0 || i == nbTry)
            #printf("\r%i / %i",i,nbTry )
        end
        a = generateRandLS(size,dim)
        distMin = a.computeMinDist
        if (distMin > minMax)
            minMax = distMin
            bestLS = a
            if (minMax > myBest)
                setReccord(minMax,bestLS,size,dim,dist)
            end
            #puts "\n"+minMax.to_s + " / " + record.to_s
            #puts bestLS.to_s
        end
        if (mode == "test" && i%testInc == 0)
            listBestVal.push(minMax)
        end

    end
    #puts ""
    if (mode == "test")
        return listBestVal
    else
        return minMax
    end
end
