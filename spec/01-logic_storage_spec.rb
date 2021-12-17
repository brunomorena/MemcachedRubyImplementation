require_relative '../factory'
require_relative '../logic_storage'
require_relative '../logic_retrieval'
require_relative '../logic_purge'
require_relative '../reply'

factory = Factory.instance
logic_storage = LogicStorage.new

describe LogicStorage do 
    
    context "When testing the set command" do
        it "should store the data and return a success message" do
            command = ["set", "foo", "3", "300", "5", "hello"]
            expect(logic_storage.set_logic(command).reply).to eq(STORED)
        end
        it "should not store the data and return an error message about arguments number" do
            command = ["set", "foo", "3", "300", "hello"]
            expect(logic_storage.set_logic(command).reply).to eq(ARGUMENTS_NUMBER)
        end
        it "should not store the data and return an error message about arguments type" do
            command = ["set", "foo", "3e", "300", "5t", "hello"]
            expect(logic_storage.set_logic(command).reply).to eq(ARGUMENTS_TYPE)
        end
        it "should not store the data and return an error message about bytes asigned" do
            command = ["set", "foo", "3", "300", "5", "hello world"]

            expect(logic_storage.set_logic(command).reply).to eq(BYTES_NOT_MATCH)
        end
        it "should not store the data and return an error message about expiration time" do
            command = ["set", "foo", "3", "2592001", "5", "hello"]
            expect(logic_storage.set_logic(command).reply).to eq(MAX_EXPTIME)
        end
    end

    context "When testing the add command" do
        it "should store the data and return a success message" do
            command = ["add", "bar", "5", "400", "5", "world"]
            expect(logic_storage.add_logic(command).reply).to eq(STORED)
        end

        it "should not store the data and return an error message about arguments number" do
            command = ["add", "bar", "5", "300", "5", "2", "1", "world"]
            expect(logic_storage.add_logic(command).reply).to eq(ARGUMENTS_NUMBER)
        end

        it "should not store the data and return an error message about arguments type" do
            command = ["add", "bar", "six", "30O", "5", "world"]
            expect(logic_storage.add_logic(command).reply).to eq(ARGUMENTS_TYPE)
        end

        it "should not store the data and return an error message about bytes asigned" do
            command = ["add", "bar", "5", "400", "2", "world"]
            expect(logic_storage.add_logic(command).reply).to eq(BYTES_NOT_MATCH)
        end

        it "should not store the data and return an error message about expiration time" do
            command = ["add", "bar", "5",  "2592001", "5", "world"]
            expect(logic_storage.add_logic(command).reply).to eq(MAX_EXPTIME)
        end

        it "should not store the data and return an error message about the key is already stored" do
            command = ["add", "foo", "5", "400", "5", "world"]
            expect(logic_storage.add_logic(command).reply).to eq(KEY_ALREADY_STORED)
        end    
    end

    context "When testing the replace command" do
        it "should replace the data and return a success message" do
            command = ["replace", "foo", "7", "400", "3", "bye"]
            expect(logic_storage.replace_logic(command).reply).to eq(STORED)
        end

        it "should not replace the data and return an error message about arguments number" do
            command = ["replace", "foo", "400", "3", "bye"]
            expect(logic_storage.replace_logic(command).reply).to eq(ARGUMENTS_NUMBER)
        end

        it "should not replace the data and return an error message about arguments type" do
            command = ["replace", "foo", "7", "4OO", "l1", "bye"]
            expect(logic_storage.replace_logic(command).reply).to eq(ARGUMENTS_TYPE)
        end

        it "should not replace the data and return an error message about the key is not stored" do
            command = ["replace", "buu", "7", "400", "3", "bye"]
            expect(logic_storage.replace_logic(command).reply).to eq(NO_KEY_STORED)
        end
        
        it "should not replace the data and return an error message about the key is not stored" do
            command_set = ["set", "buz", "7", "-1", "3", "exp"] #key immediately expired
            logic_storage.set_logic(command_set)
            command = ["replace", "buz", "7", "400", "3", "bye"]
            expect(logic_storage.replace_logic(command).reply).to eq(EXPIRED_KEY)
        end
    end

    context "When testing the append command" do
        it "should add the data to an existing key after existing data and return a success message" do
            command = ["append", "foo", "0", "800", "6", "-after"]
            expect(logic_storage.append_logic(command).reply).to eq(STORED)
        end

        it "should not add the data to an existing key after existing data and return a message about arguments number" do
            command = ["append", "foo", "0", "6", "-after"]
            expect(logic_storage.append_logic(command).reply).to eq(ARGUMENTS_NUMBER)
        end

        it "should not add the data to an existing key after existing data and return a message about arguments type" do
            command = ["append", "foo", "0", "500s", "6", "-after"]
            expect(logic_storage.append_logic(command).reply).to eq(ARGUMENTS_TYPE)
        end

        it "should not add the data to an existing key after existing data and return a message about the key is not stored" do
            command = ["append", "fof", "0", "800", "6", "-after"]
            expect(logic_storage.append_logic(command).reply).to eq(NO_KEY_STORED)
        end
    end

    context "When testing the prepend command" do
        it "should add the data an existing key before existing data and return a success message" do
            command = ["append", "foo", "0", "900", "7", "before-"]
            expect(logic_storage.prepend_logic(command).reply).to eq(STORED)
        end

        it "should not add the data an existing key before existing data and return a message about arguments number" do
            command = ["append", "foo", "7", "before-"]
            expect(logic_storage.prepend_logic(command).reply).to eq(ARGUMENTS_NUMBER)
        end

        it "should not add the data an existing key before existing data and return a message about arguments type" do
            command = ["append", "foo", "cero", "900s", "7", "before-"]
            expect(logic_storage.prepend_logic(command).reply).to eq(ARGUMENTS_TYPE)
        end

        it "should not add the data to an existing key after existing data and return a message about the key is not stored" do
            command = ["append", "fof", "0", "900", "7", "before-"]
            expect(logic_storage.prepend_logic(command).reply).to eq(NO_KEY_STORED)
        end
    end

    context "When testing the cas command" do
        it "should check and store the data only if no one else has updated since the time last fetched it, and return a success message" do
            command = ["cas", "bar", "8", "600", "11", "2", "checkandset"]
            expect(logic_storage.cas_logic(command).reply).to eq(STORED)
        end

        it "should check and not store the data, and return an error message about arguments number" do
            command = ["cas", "bar", "8", "600", "11", "checkandset"]
            expect(logic_storage.cas_logic(command).reply).to eq(ARGUMENTS_NUMBER)
        end

        it "should check and not store the data, and return an error message about arguments type" do
            command = ["cas", "bar", "8", "600s", "11", "two", "checkandset"]
            expect(logic_storage.cas_logic(command).reply).to eq(ARGUMENTS_TYPE)
        end

        it "should check and not store the data, and return an error message about the key is not stored" do
            command = ["cas", "bat", "8", "600", "11", "2", "checkandset"]
            expect(logic_storage.cas_logic(command).reply).to eq(NO_KEY_STORED)
        end

        it "should check and not store the data, and return an error message about that the item you are trying to store has been modified since you last fetched it" do
            command = ["cas", "foo", "8", "600", "11", "1", "checkandset"]
            expect(logic_storage.cas_logic(command).reply).to eq(EXISTS)
        end

    end
 end