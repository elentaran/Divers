require './classLS.rb'
require './functionLS.rb'
require './randLS.rb'
require './MCTS_LS.rb'

if (ARGV.length > 0)
    size = ARGV[0].to_i
else
    size = 4
end
if (ARGV.length > 1)
    dim = ARGV[1].to_i
else
    dim = 2
end
if (ARGV.length > 2)
    nbTry = ARGV[2].to_i
else
    nbTry = 10
end
if (ARGV.length > 3)
    mode = ARGV[3].to_s
else
    mode = "MCTS"
end

if (mode == "MCTS")
    puts "MCTS"
    a=MCTS.new(size,dim)
    res=a.launch(nbTry)
    exit
end

if (mode == "rand")
    res = findBestLS(size,dim,nbTry)
    exit
end

if (mode == "test")
    if (ARGV.length > 4)
        nbMean = ARGV[4].to_i
    else
        nbMean = 100
    end

    if (ARGV.length > 5)
        func = ARGV[5].to_s
    else
        func = "MCTS"
    end
    testFunction(func,nbMean,size,dim,nbTry)
    exit
end


