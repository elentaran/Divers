

class NODELS
    @father
    @sons
    @val
    @dim
    @size
    @sumRes
    @nbVisit
    @new

    def initialize(val,size,dim,father)
        @father = father
        @sons = []
        @val = val
        @dim = dim
        @size = size
        @sumRes = 0
        @nbVisit = 0
        @new = TRUE
    end

    def to_s()
        if (@val != nil)
            return getAllVal().to_s + " : " + computeUCTval().to_s
        else
            return getAllVal().to_s 
        end
    end

    def isTerminal()
        vals = getAllVal()
        if (vals.size == @size)
            return TRUE
        else
            return FALSE
        end
    end

    def getVal()
        return @val
    end

    def getAllVal()
        if (@val != nil)
            res = @father.getAllVal()
        else
            return []
        end
        res.push(@val)
        return res
    end

    def tree_to_s(depth=0)
        res = ""
        for i in 1..depth
            res = res + "++"
        end
        res = res + to_s() + "\n"
        for i in 0...@sons.length
            res = res + @sons[i].tree_to_s(depth+1)
        end
        return res
    end

    def isNew()
        return @new
    end

    def getNbVisit()
        return @nbVisit
    end

    def update(val)
        if @new
            @new = FALSE
        end
        @sumRes = @sumRes + val
        @nbVisit = @nbVisit + 1
        if (@val != nil)
            @father.update(val)
        end
    end

    def selectNext()
        # progressive widening
        nbSonsWanted = computeProgWid()

        if (@sons.length >= nbSonsWanted)
            newNode = selectUCT()
        else
            newNode = createNewSon()
        end
        return newNode
    end

    def computeProgWid()
        return Math.sqrt(@nbVisit+1).to_i
    end

    def selectUCT()
        bestSon = 0
        bestUctVal = 0
        for i in 0...@sons.length
            curentVal = @sons[i].computeUCTval()
            if (curentVal > bestUctVal)
                bestSon = i
                bestUctVal = curentVal
            end
        end
        return @sons[bestSon]
    end

    def computeUCTval()
        coef = 0.5
        exploit = @sumRes / @nbVisit
        nbVisitFather = @father.getNbVisit()
        explor = Math.sqrt(Math.log(nbVisitFather)/@nbVisit)
        uctVal = (exploit + coef * explor)
        return uctVal
    end

    def createNewSon ()

        remainVal = getRemainVal()
        newPoint = []
        for i in 0...remainVal.length
            newPoint.push(selectRand(remainVal[i]))
        end

        # creation of the node
        newNode = NODELS.new(newPoint,@size,@dim,self)
        @sons.push(newNode)

        return newNode
    end


    def selectRand(list)
        prgn = Random.new(Random.new_seed)
        ind = prgn.rand(list.length)
        return list[ind]
    end

    def MonteCarlo()
        #puts "Monte Carlo for node: "+to_s
        currentVal = getAllVal()
        remainVal = getRemainVal()
        sequence = generateSeq(remainVal)
        listVals = currentVal + sequence

        tempLS = LS.new(listVals,@size,@dim)
        return tempLS #.computeMinDist()
    end

    def generateSeq(remainVal)
        for i in 0...remainVal.length
            remainVal[i].shuffle!
        end
        seq = remainVal[0].zip(*remainVal[1..-1])
        return seq
    end

    def getRemainVal()
        removeVals = getAllVal()
        remainVal = []
        for i in 1..@dim
            remainVal = remainVal.push((1..@size).to_a)
        end
        for i in 0...removeVals.length
            for j in 0...removeVals[i].length
                remainVal[j].delete(removeVals[i][j])
            end
        end
        return remainVal
    end

    def evaluate()
        ls = LS.new(@vals,@size,@dim)
        return ls.computeMinDist()
    end


end


class MCTS
    @initNode
    @endTime
    @size
    @dim
    @dist

    def initialize(size,dim,dist="l2",endTime=1)
        @size = size
        @dim = dim
        @dist = dist
        @initNode = NODELS.new(nil,@size,@dim,nil)
    end

    def launch(nbRun,mode="normal",testInc=10)

        if (mode == "test")
            listBestVal=[]
        end
        bestVal = 0
        bestLS = nil
        currentNode = @initNode
        i=1

        records = getReccord(@size,@dim,@dist)
        allBest = records[0]
        myBest = records[1]

        while (i<=nbRun)

            if (i%10 == 0 || i == nbRun)
                #printf("\r%i / %i",i,nbRun )
            end

            # do a descent
            while (!currentNode.isNew() && !currentNode.isTerminal())    # a new node is created with the status NEW
                currentNode = currentNode.selectNext()
            end

            # evaluate
            resLS = currentNode.MonteCarlo()
            resMCTS = resLS.computeSumMinDist()
            resVal = resLS.computeMinDist()
            #puts "eval: "+resVal.to_s + " / " + record.to_s

            # update
            currentNode.update(resMCTS)

            # keep Best
            if (resVal > bestVal)
                bestVal = resVal
                bestLS = resLS
                if (bestVal > myBest)
                    setReccord(bestVal,bestLS,@size,@dim,@dist)
                end
                #puts "\n"+bestVal.to_s + " / " + record.to_s
                #puts bestLS.to_s
            end
            if (mode == "test" && i%testInc == 0)
                listBestVal.push(bestVal)
            end

            i = i+1
            currentNode = @initNode
        end
        #puts ""

        #puts @initNode.tree_to_s
        #puts bestVal.to_s +  " / " + record.to_s
        #puts bestLS
        if (mode == "test")
            return listBestVal
        else
            return bestVal
        end
    end

end
