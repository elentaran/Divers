
class LS
    @dim
    @size
    @values

    def initialize(values,size=4,dim=2)
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

#        if (!isLS)
#            raise "this is not a Latin Square: " + self.to_s
#        end
    end


    def to_s ()
        return @values.to_s 
    end

    def isLS()
        for i in 0...@dim
            listVal=Array.new()
            @values.each do |point|
                listVal.push(point[i])
            end
            if (listVal.length != listVal.uniq.length)
                return FALSE
            end
        end

        return TRUE
    end

    def computeMinDist(dist="l2")
        case dist
        when "l1"
            funcdist = method(:computeDistL1)
        when "l2"
            funcdist = method(:computeDistL22)
        else
            raise "wrong distance :" + dist
        end

        min=funcdist.call(@values[0],@values[1])
        remainPoints = Array.new(@values)
        @values.each do |point|
            remainPoints.delete(point)
            remainPoints.each do |point2|
                dist=funcdist.call(point,point2)
                if (dist<min)
                    min=dist
                end
            end
        end

        return min
    end

    def computeSumMinDist(dist="l2")
        case dist
        when "l1"
            funcdist = method(:computeDistL1)
        when "l2"
            funcdist = method(:computeDistL22)
        else
            raise "wrong distance :" + dist
        end

        listMinDist = Array.new(@values.size,100000000)
        for i in 0...@values.size
            for j in (i+1)...@values.size
                point = @values[i]
                point2 = @values[j]
                dist=funcdist.call(point,point2)
                if (dist<listMinDist[i])
                    listMinDist[i]=dist
                end
                if (dist<listMinDist[j])
                    listMinDist[j]=dist
                end
            end
        end

        return (listMinDist.reduce(:+)).to_f
    end

    def computeDistL1(point1,point2)
        dist=0
        for i in 0...@dim
            dist+=(point1[i]-point2[i]).abs
        end
        return dist
    end

    def computeDistL22(point1,point2)
        dist=0
        for i in 0...@dim
            dist+=(point1[i]-point2[i])**2
        end
        return dist
    end


    def removePoint(rpoint)
        @values.delete(rpoint)
        @values.each do |point|
            for i in 0...dim
                if (point[i] > rpoint[i])
                    point[i] = point[i] - 1
                end
            end
        end
    end


end
