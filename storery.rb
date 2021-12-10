class Storery
    
    attr_accessor :flags, :exptime, :bytes, :data_block
    
    def initialize (flags, exptime, bytes, data_block)
        @flags = flags
        @exptime = exptime
        @bytes = bytes
        @data_block = data_block
        @cas_unique = cas_unique
    end

    def flags
        @flags
    end

    def exptime
        @exptime
    end

    def bytes
        @bytes
    end
    
    def data_block
       @data_block
    end

    def cas_unique
        @cas_unique
    end

    @@cas_incr = 0

    def cas_increment
        @@cas_incr = @@cas_incr + 1
        @cas_unique = @@cas_incr 
    end

end