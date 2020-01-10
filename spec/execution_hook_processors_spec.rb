describe "Execute Hook" do
  screenshot_dir = File.expand_path("./tmp_screenshots_dir")
  before(:all) {
    Dir.mkdir(screenshot_dir)
    ENV["gauge_screenshots_dir"] = screenshot_dir
  }
  before(:each) do |e|
    screenshot_instance = instance_double("Gauge::GaugeScreenshot")
    messages_instance = instance_double("Gauge::GaugeMessages")
    screenshot_klass = class_double("Gauge::GaugeScreenshot").as_stubbed_const
    messages_klass = class_double("Gauge::GaugeMessages").as_stubbed_const

    expect(screenshot_instance).to receive(:pending_screenshot).and_return(e.metadata[:screenshots_file])
    expect(screenshot_klass).to receive(:instance).and_return(screenshot_instance)

    expect(messages_instance).to receive(:pending_messages).and_return(e.metadata[:message])
    expect(messages_klass).to receive(:instance).and_return(messages_instance)
  end

  after(:all) {
    FileUtils.rm_rf(screenshot_dir)
    ENV["gauge_screenshots_dir"] = nil
  }
  context "before suite" do
    it "should add custom message and screenshots from before suite", {
         screenshots_file: ["before-suite.png"], message: ["before suite"],
       } do
      input = Gauge::Messages::ExecutionStartingRequest.new(:currentExecutionInfo => nil)
      response = Gauge::Processors.process_execution_start_request(input)
      expect(response.executionResult.message).to include "before suite"
      expect(response.executionResult.screenshotFiles).to match_array ["before-suite.png"]
    end
  end

  context "after suite" do
    it "should add custom message and screenshots from after suite", {
         screenshots_file: ["after-suite.png"], message: ["after suite"],
       } do
      input = Gauge::Messages::ExecutionEndingRequest.new(:currentExecutionInfo => nil)
      response = Gauge::Processors.process_execution_end_request(input)
      expect(response.executionResult.message).to include "after suite"
      expect(response.executionResult.screenshotFiles).to match_array ["after-suite.png"]
    end
  end

  context "before spec" do
    it "should add custom message and screenshots from before spec", {
      screenshots_file: ["before-spec.png"], message: ["before spec"],
    } do
      input = Gauge::Messages::SpecExecutionStartingRequest.new(:currentExecutionInfo => nil)
      response = Gauge::Processors.process_spec_execution_start_request(input)
      expect(response.executionResult.message).to include "before spec"
      expect(response.executionResult.screenshotFiles).to match_array ["before-spec.png"]
    end
  end

  context "after spec" do
    it "should add custom message and screenshots from after spec", {
      screenshots_file: ["after-spec.png"], message: ["after spec"],
    } do
      input = Gauge::Messages::SpecExecutionEndingRequest.new(:currentExecutionInfo => nil)
      response = Gauge::Processors.process_spec_execution_end_request(input)
      expect(response.executionResult.message).to include "after spec"
      expect(response.executionResult.screenshotFiles).to match_array ["after-spec.png"]
    end
  end

  context "before scenario" do
    it "should add custom message and screenshots from before scenario", {
      screenshots_file: ["before-scenario.png"], message: ["before scenario"],
    } do
      input = Gauge::Messages::ScenarioExecutionStartingRequest.new(:currentExecutionInfo => nil)
      response = Gauge::Processors.process_scenario_execution_start_request(input)
      expect(response.executionResult.message).to include "before scenario"
      expect(response.executionResult.screenshotFiles).to match_array ["before-scenario.png"]
    end
  end

  context "after scenario" do
    it "should add custom message and screenshots from after scenario", {
      screenshots_file: ["after-scenario.png"], message: ["after scenario"],
    } do
      input = Gauge::Messages::ScenarioExecutionEndingRequest.new(:currentExecutionInfo => nil)
      response = Gauge::Processors.process_scenario_execution_end_request(input)
      expect(response.executionResult.message).to include "after scenario"
      expect(response.executionResult.screenshotFiles).to match_array ["after-scenario.png"]
    end
  end

  context "before step" do
    it "should add custom message and screenshots from before step", {
      screenshots_file: ["before-step.png"], message: ["before step"],
    } do
      input = Gauge::Messages::StepExecutionStartingRequest.new(:currentExecutionInfo => nil)
      response = Gauge::Processors.process_step_execution_start_request(input)
      expect(response.executionResult.message).to include "before step"
      expect(response.executionResult.screenshotFiles).to match_array ["before-step.png"]
    end
  end

  context "after step" do
    it "should add custom message and screenshots from after step", {
      screenshots_file: ["after-step.png"], message: ["after step"],
    } do
      input = Gauge::Messages::StepExecutionEndingRequest.new(:currentExecutionInfo => nil)
      response = Gauge::Processors.process_step_execution_end_request(input)
      expect(response.executionResult.message).to include "after step"
      expect(response.executionResult.screenshotFiles).to match_array ["after-step.png"]
    end
  end
end
