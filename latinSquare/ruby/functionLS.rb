require 'net/http'
require 'uri'
require 'gnuplot'
require "./classLS.rb"

RepReccord = "reccord/"

def wgetLS(n=2,d=2,dist="l2",retBest=FALSE)
    nameSite = "http://www.spacefillingdesigns.nl/maximin/lhd"+dist+"nd.php?n="+n.to_s+"&m="+d.to_s
    # puts nameSite
    uri = URI.parse(nameSite)
    response = Net::HTTP.get_response(uri)
    if (!response.is_a?(Net::HTTPSuccess))
        puts "error while accessing web page"
        return
    end
    resBody = response.body 

    # get dist from the html code
    distMin = resBody.scan(/D.*= (\d*)/)[0][0].to_i   # the distMin is the first (and only) match

    # get the table from the html code
    table = resBody.scan(/<TABLE.*TABLE>/m).to_s
    table.gsub!(/.*\\n/,"").gsub!(/<\/TABLE.*/,"")   # remove useless first line and last TABLE tag
    table.gsub!(/<\/\w*>/,"")                        # remove closing tags
    table.gsub!(/^<TR>/,"")                          # remove first TR tag
    newTable = table.split("<TR>")
    res = []
    newTable.each do |line|
        line.gsub!(/^<TD>/,"")                       # remove first TD tag
        newLine = line.split("<TD>")
        res.push(newLine.map{|x| x.to_i})
    end
   # puts res.to_s

    resLS = LS.new(res,res.length,res[0].length)

    compDistMin = resLS.computeMinDist(dist)
   # puts distMin.to_s + " == " + compDistMin.to_s

    if (retBest)
        return distMin
    else
        return resLS
    end

end

def computeBestLS (dim=2,size=2,distfunc="l2")

    # one coordinate is fixed
    startt=Time.now
    listCoord=(0...size).to_a
    firstCoord=listCoord

    listPermCoord=listCoord.permutation.to_a
    listTemp = listPermCoord.repeated_combination((dim-1)).to_a
    listRemainingCoord = listTemp.map{ |x| x.transpose}

    listPoints = Array.new()

    listRemainingCoord.each do |remainCoord|
        point = Array.new()
        for i in 0...firstCoord.length do
            point[i] = [firstCoord[i]] + remainCoord[i]
        end
        listPoints.push(point)
    end

    #puts listPoints.to_s

    bestDist = 0
    bestLS = nil
    max=listPoints.length
    index=0
    listPoints.each do |values|
        a = LS.new(values,size,dim)
        dist = a.computeMinDist(distfunc)
        if (dist > bestDist)
            bestDist = dist
            bestLS = a
        end
        index = index + 1
        if (index%1000 == 0 || index == max)
            printf("\r%i / %i",index,max )
        end
    end
    puts ""
    endt=Time.now

    puts "best dist: " + bestDist.to_s
    puts "best LS: " + bestLS.to_s
    puts "time: " + (endt-startt).to_s

end

def meanArray(list)
    return (list.reduce(:+)).to_f / list.size 
end

# compute a mean list from several lists of the same size
def meanList(lists)
    return lists.transpose.map {|x| meanArray(x)}
end

def sdArray(list)
    m = meanArray(list)
    variance = list.inject(0) { |variance, x| variance += (x - m) ** 2 }
    return Math.sqrt(variance/(list.size-1))
end

def sdList(lists)
    return lists.transpose.map {|x| sdArray(x)}
end

# confidence interval 95%
def ciArray(list)
    s = sdArray(list)
    return 1.96*s/Math.sqrt(list.size)
end

def ciList(lists)
    return lists.transpose.map {|x| ciArray(x)}
end

#save true best and my best
def setReccord(val,ls,size,dim,dist="l2")
    nameFile = RepReccord + dist.to_s + "_" + dim.to_s + "_" + size.to_s + ".best"
    if (!File.exists?(nameFile))
        myFile = File.new(nameFile,"w")
        allBest = wgetLS(size,dim,dist,TRUE)
    else
        myFile = File.open(nameFile,"r+")
        allBest = myFile.readline.to_i
        myFile.rewind
    end

    puts "\n"
    puts "NEW RECCORD!!: " + val.to_s + " / " + allBest.to_s
    puts "\n"

    myFile.puts(allBest.to_s)
    myFile.puts(val.to_s)
    myFile.puts(ls.to_s)
    myFile.close

end

# first line: all Time reccord
# second line: my reccord
# third line: Latin Square
def getReccord(size,dim,dist="l2")
    nameFile = RepReccord + dist.to_s + "_" + dim.to_s + "_" + size.to_s + ".best"
    if (!File.exists?(nameFile))
        myFile = File.new(nameFile,"w")
        myBest = 0
        bestLS = []
        allBest = wgetLS(size,dim,dist,TRUE)
        myFile.puts(allBest.to_s)
        myFile.puts(myBest.to_s)
        myFile.puts(bestLS.to_s)
        myFile.close
    else
        myFile = File.open(nameFile)
        allBest = myFile.readline.to_i
        myBest = myFile.readline.to_i
        myFile.close
    end
    return allBest,myBest
end

def saveData(data,nameFile)
    if (!File.exists?(nameFile))
        myFile = File.new(nameFile,"w")
    else
        myFile = File.open(nameFile,"r+")
    end
    serializedData = Marshal.dump(data)
    myFile.puts(serializedData)
    myFile.close
end

def loadData(nameFile)
    if (!File.exists?(nameFile))
        raise("file doesn't exist")
    end
    serializedData = File.read(nameFile)
    data = Marshal.load(serializedData)
    return data
end


def plotData(val,sd=nil)
    Gnuplot.open do |gp|
        Gnuplot::Plot.new( gp ) do |plot|

            #plot.xrange "[0:1]"
            #plot.title  "Sin Wave Example"
            #plot.ylabel "x"
            #plot.xlabel "sin(x)"

            plot.data << Gnuplot::DataSet.new( val ) do |ds|
                ds.with = "lines"
                ds.linewidth = 2
            end

            if (sd != nil)
                a=(0...val.size).to_a
                plot.data << Gnuplot::DataSet.new([a,val,sd]) do |ds|
                    ds.with = "errorbars"
                    ds.linewidth = 1
                end
            end
        end
    end
end

def testFunction(func,nbMean,size,dim,nbTry,plot=FALSE)
    listRes=[]
    listTime=[]
    for i in 1..nbMean
        startt=Time.now
        case func
        when "MCTS"
            a=MCTS.new(size,dim)
            res=a.launch(nbTry,mode="test")
        when "rand"
            res = findBestLS(size,dim,nbTry,mode="test")
        end
        listRes.push(res)
        endt=Time.now
        listTime.push(endt-startt)
        printf("\r%i / %i",i,nbMean )
    end
    puts ""
    meanData = meanList(listRes)
    ciData = ciList(listRes)
    puts meanData.to_s + " +- " + ciData.to_s
    puts meanArray(listTime).to_s + " +- " + ciArray(listTime).to_s
    if (plot)
        plotData(meanData,ciData)
    end
    nameFile="save/"+func+"_"+dim.to_s+"_"+size.to_s+"_"+nbTry.to_s+"_"+nbMean.to_s+"_res.last"
    saveData(listRes,nameFile)
end
