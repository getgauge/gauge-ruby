describe Gauge::Processors do
  let(:message) {double('message')}
  let(:File) {double('File')}
  before(:each) {
    Gauge::MethodCache.clear
        ENV['GAUGE_PROJECT_ROOT'] = "/temp"
  }
  context '.process_cache_file_request' do
    context 'on Cache file request with OPENED status' do
      before {
        content = "step 'foo1' do\n\tputs 'hello'\nend\n"
        ast = Gauge::CodeParser.code_to_ast content
        Gauge::StaticLoader.load_steps '/temp/foo.rb', ast
        allow(message).to receive_message_chain(:cacheFileRequest, :filePath => '/temp/foo.rb')
        allow(message).to receive_message_chain(:cacheFileRequest, :status =>  :OPENED)
        allow(message).to receive_message_chain(:cacheFileRequest, :content => "step 'foo <vowels>' do |v|\nend")
        allow(message).to receive(:messageId) {1}
      }
      it 'should reload step cache from request' do
        subject.process_cache_file_request(message)
        expect(Gauge::MethodCache.valid_step? "foo1").to eq false
        expect(Gauge::MethodCache.valid_step? "foo {}").to eq true
      end
    end
    context 'on Cache file request with CHANGED status' do
      before {
        content = "step 'foo1' do\n\tputs 'hello'\nend\n"
        ast = Gauge::CodeParser.code_to_ast content
        Gauge::StaticLoader.load_steps '/temp/foo.rb', ast
        allow(message).to receive_message_chain(:cacheFileRequest, :filePath => '/temp/foo.rb')
        allow(message).to receive_message_chain(:cacheFileRequest, :status => :OPENED)
        allow(message).to receive_message_chain(:cacheFileRequest, :content => "step 'foo <vowels>' do |v|\nend")
        allow(message).to receive(:messageId) {1}
      }
      it 'should reload step cache from request' do
        subject.process_cache_file_request(message)
        expect(Gauge::MethodCache.valid_step? "foo1").to eq false
        expect(Gauge::MethodCache.valid_step? "foo {}").to eq true
      end
    end
    context 'on Cache file request with CREATED status' do
      before {
        content = "step 'foo' do\n\tputs 'hello'\nend\n"
        allow(File).to receive(:read).with('foo.rb').and_return(content)
        allow(message).to receive_message_chain(:cacheFileRequest, :filePath => 'foo.rb')
        allow(message).to receive_message_chain(:cacheFileRequest, :status => :CREATED)
        allow(message).to receive(:messageId) {1}
      }
      it 'should reload step cache from file system' do
        subject.process_cache_file_request(message)
        expect(Gauge::MethodCache.valid_step? "foo").to eq true
      end
    end
    context 'on Cache file request with CLOSED status' do
      before {
        ast = Gauge::CodeParser.code_to_ast "step 'foo' do\n\tputs 'hello'\nend\n"
        Gauge::StaticLoader.load_steps '/temp/foo.rb', ast
        allow(File).to receive(:file?).with('/temp/foo.rb').and_return(true)
        allow(File).to receive(:read).with('/temp/foo.rb').and_return("step 'foo <vowels>' do |v|\nend")
        allow(message).to receive_message_chain(:cacheFileRequest, :filePath => '/temp/foo.rb')
        allow(message).to receive_message_chain(:cacheFileRequest, :status => :CLOSED)
        allow(message).to receive(:messageId) {1}
      }
      it 'should reload step cache from file system' do
        subject.process_cache_file_request(message)
        expect(Gauge::MethodCache.valid_step? "foo").to eq false
        expect(Gauge::MethodCache.valid_step? "foo {}").to eq true
      end
    end
    context 'on Cache file request with DELETED status' do
      before {
        ast = Gauge::CodeParser.code_to_ast "step 'foo' do\n\tputs 'hello'\nend\n"
        Gauge::StaticLoader.load_steps '/temp/foo.rb', ast
        allow(message).to receive_message_chain(:cacheFileRequest, :filePath => '/temp/foo.rb')
        allow(message).to receive_message_chain(:cacheFileRequest, :status => :DELETED)
        allow(message).to receive(:messageId) {1}
      }
      it 'should reload step cache from file system' do
        subject.process_cache_file_request(message)
        expect(Gauge::MethodCache.valid_step? "foo").to eq false
      end
    end
  end
end
  