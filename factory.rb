class Factory

    @instance = new

    private_class_method :new

    def self.instance
        @instance
        @callstorage = Storage.new
        @logic_storage = LogicStorage.new
        @logic_retrieval = LogicRetrieval.new
        @logic_purge = LogicPurge.new
    end

    def self.callstorage
        @callstorage
    end

    def self.logic_storage
        @logic_storage
    end

    def self.logic_retrieval
        @logic_retrieval
    end

    def self.logic_purge
        @logic_purge
    end
end