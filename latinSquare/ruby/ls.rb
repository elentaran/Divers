
def computeBestLS (dim=2,size=4)


    return dim.to_s + " " + size.to_s

end


class LS
    @dim
    @size
    @values

    def initialize(values,dim=2,size=4)
        @dim=dim
        @size=size
        @values=values
        if (@size < 2)
            raise "size must be at least 2"
        end
        if (@values.length != @size)
            raise "values must have size dimension"
        end
        @values.each do |point|
            if (point.length != @dim)
                raise "each point in values must have dim coordinates"
            end
        end
    end


    def to_s ()
        return "coucou " + @dim.to_s + " " + @size.to_s + "\n"
    end

    def isLS()

        return TRUE
    end

    def computeMinDist()
        min=computeDist(@values[0],@values[1])
        @values.each do |point|
            list = @values - [point]
            list.each do |point2|
                dist=computeDist(point,point2)
                if (dist<min)
                    min=dist
                end
            end
        end

        return min
    end

    def computeDist(point1,point2)
        dist=0
        for i in 0...@dim
            dist+=(point1[i]-point2[i]).abs
        end
        return dist
    end

end

test=LS.new([[1,1],[2,2],[3,3],[4,4]])
#test=LS.new([[2,2],[3,3],[4,4]])
print test.to_s
print test.isLS.to_s + "\n"
print test.computeMinDist.to_s + "\n"
