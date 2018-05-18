describe 'Execute Hook' do

  let(:input) { {executionStartingRequest: {currentExecutionInfo: " "}} }

  before(:each) {
    Gauge::Util.stub(:get_step_implementation_dir)
    Gauge::Executor.stub(:load_steps)
    execution_status_response = Gauge::Messages::ExecutionStatusResponse.new(:executionResult => Gauge::Messages::ProtoExecutionResult.new(:failed => false, :executionTime => 1))
    message = Gauge::Messages::Message.new(:messageType => :ExecutionStatusResponse, :messageId => 2, :executionStatusResponse => execution_status_response)
    Gauge::Processors.stub(:handle_hooks_execution) { message }
  }

  context 'before suite' do
    it 'should add custom message from before suite' do
      Gauge::GaugeMessages.instance.write('before suite')
      response = Gauge::Processors.process_execution_start_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'before suite'
    end
  end

  context 'after suite' do
    it 'should add custom message from after suite' do
      Gauge::GaugeMessages.instance.write('after suite')
      response = Gauge::Processors.process_execution_end_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'after suite'
    end
  end

  context 'before spec' do
    it 'should add custom message from before spec' do
      Gauge::GaugeMessages.instance.write('before spec')
      response = Gauge::Processors.process_spec_execution_start_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'before spec'
    end
  end

  context 'after spec' do
    it 'should add custom message from after spec' do
      Gauge::GaugeMessages.instance.write('after spec')
      response = Gauge::Processors.process_spec_execution_end_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'after spec'
    end
  end

  context 'before scenario' do
    it 'should add custom message from before scenario' do
      Gauge::GaugeMessages.instance.write('before scenario')
      response = Gauge::Processors.process_scenario_execution_start_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'before scenario'
    end
  end

  context 'after scenario' do
    it 'should add custom message from after scenario' do
      Gauge::GaugeMessages.instance.write('after scenario')
      response = Gauge::Processors.process_scenario_execution_end_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'after scenario'
    end
  end

  context 'before step' do
    it 'should add custom message from before step' do
      Gauge::GaugeMessages.instance.write('before step')
      response = Gauge::Processors.process_step_execution_start_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'before step'
    end
  end

  context 'after step' do
    it 'should add custom message from after step' do
      Gauge::GaugeMessages.instance.write('after step')
      response = Gauge::Processors.process_step_execution_end_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'after step'
    end
  end

  after(:each) {
    Gauge::GaugeMessages.instance.clear()
  }
end