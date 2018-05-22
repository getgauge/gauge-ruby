describe 'Execute Hook' do

  before(:each) {
    Gauge::Util.stub(:get_step_implementation_dir)
    Gauge::Executor.stub(:load_steps)
    execution_status_response = Gauge::Messages::ExecutionStatusResponse.new(:executionResult => Gauge::Messages::ProtoExecutionResult.new(:failed => false, :executionTime => 1))
    message = Gauge::Messages::Message.new(:messageType => :ExecutionStatusResponse, :messageId => 2, :executionStatusResponse => execution_status_response)
    Gauge::Processors.stub(:handle_hooks_execution) { message }
  }

  context 'before suite' do
    it 'should add custom message from before suite' do
      input = Gauge::Messages::Message.new(:executionStartingRequest => Gauge::Messages::ExecutionStartingRequest.new(:currentExecutionInfo => nil))
      Gauge::GaugeMessages.instance.write('before suite')
      response = Gauge::Processors.process_execution_start_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'before suite'
    end
  end

  context 'after suite' do
    it 'should add custom message from after suite' do
      input = Gauge::Messages::Message.new(:executionEndingRequest => Gauge::Messages::ExecutionEndingRequest.new(:currentExecutionInfo => nil))
      Gauge::GaugeMessages.instance.write('after suite')
      response = Gauge::Processors.process_execution_end_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'after suite'
    end
  end

  context 'before spec' do
    it 'should add custom message from before spec' do
      input = Gauge::Messages::Message.new(:specExecutionStartingRequest => Gauge::Messages::SpecExecutionStartingRequest.new(:currentExecutionInfo => nil))
      Gauge::GaugeMessages.instance.write('before spec')
      response = Gauge::Processors.process_spec_execution_start_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'before spec'
    end
  end

  context 'after spec' do
    it 'should add custom message from after spec' do
      input = Gauge::Messages::Message.new(:specExecutionEndingRequest => Gauge::Messages::SpecExecutionEndingRequest.new(:currentExecutionInfo => nil))
      Gauge::GaugeMessages.instance.write('after spec')
      response = Gauge::Processors.process_spec_execution_end_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'after spec'
    end
  end

  context 'before scenario' do
    it 'should add custom message from before scenario' do
      input = Gauge::Messages::Message.new(:scenarioExecutionStartingRequest => Gauge::Messages::ScenarioExecutionStartingRequest.new(:currentExecutionInfo => nil))
      Gauge::GaugeMessages.instance.write('before scenario')
      response = Gauge::Processors.process_scenario_execution_start_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'before scenario'
    end
  end

  context 'after scenario' do
    it 'should add custom message from after scenario' do
      input = Gauge::Messages::Message.new(:scenarioExecutionEndingRequest => Gauge::Messages::ScenarioExecutionEndingRequest.new(:currentExecutionInfo => nil))
      Gauge::GaugeMessages.instance.write('after scenario')
      response = Gauge::Processors.process_scenario_execution_end_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'after scenario'
    end
  end

  context 'before step' do
    it 'should add custom message from before step' do
      input = Gauge::Messages::Message.new(:stepExecutionStartingRequest => Gauge::Messages::StepExecutionStartingRequest.new(:currentExecutionInfo => nil))
      Gauge::GaugeMessages.instance.write('before step')
      response = Gauge::Processors.process_step_execution_start_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'before step'
    end
  end

  context 'after step' do
    it 'should add custom message from after step' do
      input = Gauge::Messages::Message.new(:stepExecutionEndingRequest => Gauge::Messages::StepExecutionEndingRequest.new(:currentExecutionInfo => nil))
      Gauge::GaugeMessages.instance.write('after step')
      response = Gauge::Processors.process_step_execution_end_request(input)
      expect(response.executionStatusResponse.executionResult.message).to include 'after step'
    end
  end

  after(:each) {
    Gauge::GaugeMessages.instance.clear()
  }
end