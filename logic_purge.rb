require_relative 'validator'
require_relative 'storage'
require_relative 'constants'
require 'time'

class LogicPurge
    
    # "purge" means "delete all the expired keys"
    def purge_expired_keys
        Factory.callstorage.purge_expired_keys
        reply = Reply.new(true, PURGED_EXP_KEYS)
        return reply
    end
    
end
