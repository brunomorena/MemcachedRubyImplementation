require_relative '../factory'
require_relative '../logic_storage'
require_relative '../logic_retrieval'
require_relative '../logic_purge'
require_relative '../reply'

factory = Factory.instance
logic_retrieval = LogicRetrieval.new
logic_storage = LogicStorage.new

describe LogicRetrieval do 
    
    context "When testing the get command" do
        it "should return a text line followed by a data block and an end message" do
            set_command = ["set", "foo", "3", "300", "5", "hello"]
            logic_storage.set_logic(set_command)
            command = ["get", "foo"]
            expect(logic_retrieval.get_logic(command).reply).to eq("VALUE " + "foo" + " " + "3" + " " + "5" + "\r\n" + "hello" + "\r\n" + "END\r\n")
        end

        it "should return an error message about that arguments number" do
            command = ["get", "foo", "bar"]
            expect(logic_retrieval.get_logic(command).reply).to eq(GET_ARGUMENTS_NUMBER)
        end

        it "should return an message about that the key is not found" do
            command = ["get", "none"]
            expect(logic_retrieval.get_logic(command).reply).to eq(NO_KEY_FOUND)
        end

    end

    context "When testing the gets command" do
        it "should return a text line followed by a data block per each key entered and an end message" do
            set_command = ["set", "bar", "5", "400", "5", "world"]
            logic_storage.set_logic(set_command)
            command = ["gets", "foo", "bar"]
            expect(logic_retrieval.gets_logic(command).reply).to eq("VALUE " + "foo" + " " + "3" + " " + "5" + " " +  "8" + "\r\n" + "hello" + "\r\n" + "VALUE " + "bar" + " " + "5" + " " + "5" + " " + "9" + "\r\n" + "world" + "\r\n" + "END\r\n")
        end

        it "should return a text line followed by a data block for an existing key entered, a message about that the key is not found and an end message" do
            command = ["gets", "foo", "none"]
            expect(logic_retrieval.gets_logic(command).reply).to eq("VALUE " + "foo" + " " + "3" + " " + "5" + " " +  "8" + "\r\n" + "hello" + "\r\n" + NO_KEY_FOUND + "END\r\n")
        end

        it "should return a message about that the key is not found and an end message" do
            command = ["gets", "none"]
            expect(logic_retrieval.gets_logic(command).reply).to eq(NO_KEY_FOUND + "END\r\n")
        end

        it "should return an end message" do
            command = ["gets"]
            expect(logic_retrieval.gets_logic(command).reply).to eq("END\r\n")
        end

    end

 end