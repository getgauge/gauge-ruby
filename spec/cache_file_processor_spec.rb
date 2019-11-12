describe Gauge::Processors do
  let(:cache_file_request) { double("cache_file_request") }
  let(:File) { double("File") }
  before(:each) {
    Gauge::MethodCache.clear
    ENV["GAUGE_PROJECT_ROOT"] = "/temp"
  }
  context ".process_cache_file_request" do
    context "on Cache file request with OPENED status" do
      before {
        content = "step 'foo1' do\n\tputs 'hello'\nend\n"
        ast = Gauge::CodeParser.code_to_ast content
        Gauge::StaticLoader.load_steps "/temp/foo.rb", ast
        allow(cache_file_request).to receive_messages(
          :filePath => "/temp/foo.rb",
          :status => :OPENED,
          :content => "step 'foo <vowels>' do |v|\nend",
        )
      }
      it "should reload step cache from request" do
        subject.process_cache_file_request(cache_file_request)
        expect(Gauge::MethodCache.valid_step? "foo1").to eq false
        expect(Gauge::MethodCache.valid_step? "foo {}").to eq true
      end
    end
    context "on Cache file request with CHANGED status" do
      before {
        content = "step 'foo1' do\n\tputs 'hello'\nend\n"
        ast = Gauge::CodeParser.code_to_ast content
        Gauge::StaticLoader.load_steps "/temp/foo.rb", ast
        allow(cache_file_request).to receive_messages(
          :filePath => "/temp/foo.rb",
          :status => :CHANGED,
          :content => "step 'foo <vowels>' do |v|\nend",
        )
      }
      it "should reload step cache from request" do
        subject.process_cache_file_request(cache_file_request)
        expect(Gauge::MethodCache.valid_step? "foo1").to eq false
        expect(Gauge::MethodCache.valid_step? "foo {}").to eq true
      end
    end
    context "on Cache file request with CREATED status" do
      before {
        content = "step 'foo' do\n\tputs 'hello'\nend\n"
        allow(File).to receive(:read).with("foo.rb").and_return(content)
        allow(cache_file_request).to receive_messages(
          :filePath => "foo.rb",
          :status => :CREATED
        )
      }
      it "should reload step cache from file system" do
        subject.process_cache_file_request(cache_file_request)
        expect(Gauge::MethodCache.valid_step? "foo").to eq true
      end
    end
    context "on Cache file request with CREATED status when file is already cached" do
      before {
        ast = Gauge::CodeParser.code_to_ast "step 'foo' do\n\tputs 'hello'\nend\n"
        Gauge::StaticLoader.load_steps "/temp/foo.rb", ast
        allow(File).to receive(:file?).with("/temp/foo.rb").and_return(true)
        allow(File).to receive(:read).with("/temp/foo.rb").and_return("")
        allow(cache_file_request).to receive_messages(:filePath => "/temp/foo.rb",:status => :CREATED)
      }
      it "should reload step cache from file system" do
        subject.process_cache_file_request(cache_file_request)
        expect(Gauge::MethodCache.valid_step? "foo").to eq true
      end
    end
    context "on Cache file request with CLOSED status" do
      before {
        ast = Gauge::CodeParser.code_to_ast "step 'foo' do\n\tputs 'hello'\nend\n"
        Gauge::StaticLoader.load_steps "/temp/foo.rb", ast
        allow(File).to receive(:file?).with("/temp/foo.rb").and_return(true)
        allow(File).to receive(:read).with("/temp/foo.rb").and_return("step 'foo <vowels>' do |v|\nend")
        allow(cache_file_request).to receive_messages(:filePath => "/temp/foo.rb", :status => :CLOSED)
      }
      it "should reload step cache from file system" do
        subject.process_cache_file_request(cache_file_request)
        expect(Gauge::MethodCache.valid_step? "foo").to eq false
        expect(Gauge::MethodCache.valid_step? "foo {}").to eq true
      end
    end
    context "on Cache file request with DELETED status" do
      before {
        ast = Gauge::CodeParser.code_to_ast "step 'foo' do\n\tputs 'hello'\nend\n"
        Gauge::StaticLoader.load_steps "/temp/foo.rb", ast
        allow(cache_file_request).to receive_messages(:filePath => "/temp/foo.rb", :status => :DELETED)
      }
      it "should reload step cache from file system" do
        subject.process_cache_file_request(cache_file_request)
        expect(Gauge::MethodCache.valid_step? "foo").to eq false
      end
    end
  end
end
