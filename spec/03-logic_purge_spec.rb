require_relative '../factory'
require_relative '../logic_storage'
require_relative '../logic_retrieval'
require_relative '../logic_purge'
require_relative '../reply'

factory = Factory.instance
logic_purge = LogicPurge.new
logic_storage = LogicStorage.new
logic_retrieval = LogicRetrieval.new

describe LogicPurge do 
    
    context "When testing the purge command" do
        it "should delete all the expired keys and return a message about all expired keys have been purged" do
            expect(logic_purge.purge_expired_keys.reply).to eq(PURGED_EXP_KEYS)
        end

        it "should add a new key, wait for the expiration time, delete all the expired keys, and return a message about the key is not found" do
            command = ["add", "ram", "5", "5", "5", "world"]
            logic_storage.add_logic(command)
            sleep 6
            expect(logic_purge.purge_expired_keys.reply).to eq(PURGED_EXP_KEYS)
            command_get = ["get", "ram"]
            expect(logic_retrieval.get_logic(command_get).reply).to eq(NO_KEY_FOUND)
        end

        it "should add two new keys, wait for the expiration time, delete all the expired keys, and return a message about one key is not found and the data from the another key" do
            command_1 = ["add", "rom", "5", "5", "5", "world"]
            logic_storage.add_logic(command_1)
            command_2 = ["set", "for", "5", "300", "4", "here"]
            logic_storage.set_logic(command_2)
            sleep 6
            expect(logic_purge.purge_expired_keys.reply).to eq(PURGED_EXP_KEYS)
            command_gets = ["get", "rom", "for"]
            expect(logic_retrieval.gets_logic(command_gets).reply).to eq(NO_KEY_FOUND + "VALUE " + "for" + " " + "5" + " " + "4" + " " + "12" + "\r\n" "here" + "\r\n" "END\r\n")
        end
        
    end
 end
