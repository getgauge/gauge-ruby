module ExecutionHandler
  def handle_hooks_execution(hooks, message, currentExecutionInfo)
    start_time= Time.now
    execution_error = execute_hooks(hooks, currentExecutionInfo)
    if execution_error == nil
      return handle_pass message, time_elapsed_since(start_time)
    else
      return handle_failure message, execution_error, time_elapsed_since(start_time)
    end
  end

  def handle_pass(message, execution_time)
    execution_status_response = Gauge::Messages::ExecutionStatusResponse.new(:executionResult => Gauge::Messages::ProtoExecutionResult.new(:failed => false, :executionTime => execution_time))
    Gauge::Messages::Message.new(:messageType => Gauge::Messages::Message::MessageType::ExecutionStatusResponse, :messageId => message.messageId, :executionStatusResponse => execution_status_response)
  end

  def handle_failure(message, exception, execution_time)
    execution_status_response = 
      Gauge::Messages::ExecutionStatusResponse.new(
        :executionResult => Gauge::Messages::ProtoExecutionResult.new(:failed => true,
         :recoverableError => false,
         :errorMessage => exception.message,
         :stackTrace => exception.backtrace.join("\n")+"\n",
         :executionTime => execution_time,
         :screenShot => screenshot_bytes))
    Gauge::Messages::Message.new(:messageType => Gauge::Messages::Message::MessageType::ExecutionStatusResponse,
      :messageId => message.messageId, :executionStatusResponse => execution_status_response)
  end

  def screenshot_bytes
    return nil if (ENV['screenshot_enabled'] || "").downcase == "false"
    # todo: make it platform independent
    if (OS.mac?)
      file = File.open("#{Dir.tmpdir}/screenshot.png", "w+")
      `screencapture #{file.path}`
      file_content = File.binread(file.path)
      File.delete file
      return file_content
    end
    return nil
  end

  def time_elapsed_since(start_time)
    ((Time.now-start_time) * 1000).round
  end

  def create_param_values parameters
    params = []
    parameters.each do |param|
      if ((param.parameterType == Gauge::Messages::Parameter::ParameterType::Table) ||(param.parameterType == Gauge::Messages::Parameter::ParameterType::Special_Table))
        gtable = GaugeTable.new(param.table)
        params.push gtable
      else
        params.push param.value
      end
    end
    return params
  end  
end