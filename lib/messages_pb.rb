# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: messages.proto

require 'google/protobuf'

require 'spec_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("messages.proto", :syntax => :proto3) do
    add_message "gauge.messages.KillProcessRequest" do
    end
    add_message "gauge.messages.ExecutionStatusResponse" do
      optional :executionResult, :message, 1, "gauge.messages.ProtoExecutionResult"
    end
    add_message "gauge.messages.ExecutionStartingRequest" do
      optional :currentExecutionInfo, :message, 1, "gauge.messages.ExecutionInfo"
      optional :suiteResult, :message, 2, "gauge.messages.ProtoSuiteResult"
    end
    add_message "gauge.messages.ExecutionEndingRequest" do
      optional :currentExecutionInfo, :message, 1, "gauge.messages.ExecutionInfo"
      optional :suiteResult, :message, 2, "gauge.messages.ProtoSuiteResult"
    end
    add_message "gauge.messages.SpecExecutionStartingRequest" do
      optional :currentExecutionInfo, :message, 1, "gauge.messages.ExecutionInfo"
      optional :specResult, :message, 2, "gauge.messages.ProtoSpecResult"
    end
    add_message "gauge.messages.SpecExecutionEndingRequest" do
      optional :currentExecutionInfo, :message, 1, "gauge.messages.ExecutionInfo"
      optional :specResult, :message, 2, "gauge.messages.ProtoSpecResult"
    end
    add_message "gauge.messages.ScenarioExecutionStartingRequest" do
      optional :currentExecutionInfo, :message, 1, "gauge.messages.ExecutionInfo"
      optional :scenarioResult, :message, 2, "gauge.messages.ProtoScenarioResult"
    end
    add_message "gauge.messages.ScenarioExecutionEndingRequest" do
      optional :currentExecutionInfo, :message, 1, "gauge.messages.ExecutionInfo"
      optional :scenarioResult, :message, 2, "gauge.messages.ProtoScenarioResult"
    end
    add_message "gauge.messages.StepExecutionStartingRequest" do
      optional :currentExecutionInfo, :message, 1, "gauge.messages.ExecutionInfo"
      optional :stepResult, :message, 2, "gauge.messages.ProtoStepResult"
    end
    add_message "gauge.messages.StepExecutionEndingRequest" do
      optional :currentExecutionInfo, :message, 1, "gauge.messages.ExecutionInfo"
      optional :stepResult, :message, 2, "gauge.messages.ProtoStepResult"
    end
    add_message "gauge.messages.ExecutionArg" do
      optional :flagName, :string, 1
      repeated :flagValue, :string, 2
    end
    add_message "gauge.messages.ExecutionInfo" do
      optional :currentSpec, :message, 1, "gauge.messages.SpecInfo"
      optional :currentScenario, :message, 2, "gauge.messages.ScenarioInfo"
      optional :currentStep, :message, 3, "gauge.messages.StepInfo"
      optional :stacktrace, :string, 4
      optional :projectName, :string, 5
      repeated :ExecutionArgs, :message, 6, "gauge.messages.ExecutionArg"
      optional :numberOfExecutionStreams, :int32, 7
      optional :runnerId, :int32, 8
    end
    add_message "gauge.messages.SpecInfo" do
      optional :name, :string, 1
      optional :fileName, :string, 2
      optional :isFailed, :bool, 3
      repeated :tags, :string, 4
    end
    add_message "gauge.messages.ScenarioInfo" do
      optional :name, :string, 1
      optional :isFailed, :bool, 2
      repeated :tags, :string, 3
    end
    add_message "gauge.messages.StepInfo" do
      optional :step, :message, 1, "gauge.messages.ExecuteStepRequest"
      optional :isFailed, :bool, 2
      optional :stackTrace, :string, 3
      optional :errorMessage, :string, 4
    end
    add_message "gauge.messages.ExecuteStepRequest" do
      optional :actualStepText, :string, 1
      optional :parsedStepText, :string, 2
      optional :scenarioFailing, :bool, 3
      repeated :parameters, :message, 4, "gauge.messages.Parameter"
    end
    add_message "gauge.messages.StepValidateRequest" do
      optional :stepText, :string, 1
      optional :numberOfParameters, :int32, 2
      optional :stepValue, :message, 3, "gauge.messages.ProtoStepValue"
    end
    add_message "gauge.messages.StepValidateResponse" do
      optional :isValid, :bool, 1
      optional :errorMessage, :string, 2
      optional :errorType, :enum, 3, "gauge.messages.StepValidateResponse.ErrorType"
      optional :suggestion, :string, 4
    end
    add_enum "gauge.messages.StepValidateResponse.ErrorType" do
      value :STEP_IMPLEMENTATION_NOT_FOUND, 0
      value :DUPLICATE_STEP_IMPLEMENTATION, 1
    end
    add_message "gauge.messages.SuiteExecutionResult" do
      optional :suiteResult, :message, 1, "gauge.messages.ProtoSuiteResult"
    end
    add_message "gauge.messages.SuiteExecutionResultItem" do
      optional :resultItem, :message, 1, "gauge.messages.ProtoItem"
    end
    add_message "gauge.messages.StepNamesRequest" do
    end
    add_message "gauge.messages.StepNamesResponse" do
      repeated :steps, :string, 1
    end
    add_message "gauge.messages.ScenarioDataStoreInitRequest" do
    end
    add_message "gauge.messages.SpecDataStoreInitRequest" do
    end
    add_message "gauge.messages.SuiteDataStoreInitRequest" do
    end
    add_message "gauge.messages.ParameterPosition" do
      optional :oldPosition, :int32, 1
      optional :newPosition, :int32, 2
    end
    add_message "gauge.messages.RefactorRequest" do
      optional :oldStepValue, :message, 1, "gauge.messages.ProtoStepValue"
      optional :newStepValue, :message, 2, "gauge.messages.ProtoStepValue"
      repeated :paramPositions, :message, 3, "gauge.messages.ParameterPosition"
      optional :saveChanges, :bool, 4
    end
    add_message "gauge.messages.FileChanges" do
      optional :fileName, :string, 1
      optional :fileContent, :string, 2
      repeated :diffs, :message, 3, "gauge.messages.TextDiff"
    end
    add_message "gauge.messages.RefactorResponse" do
      optional :success, :bool, 1
      optional :error, :string, 2
      repeated :filesChanged, :string, 3
      repeated :fileChanges, :message, 4, "gauge.messages.FileChanges"
    end
    add_message "gauge.messages.StepNameRequest" do
      optional :stepValue, :string, 1
    end
    add_message "gauge.messages.StepNameResponse" do
      optional :isStepPresent, :bool, 1
      repeated :stepName, :string, 2
      optional :hasAlias, :bool, 3
      optional :fileName, :string, 4
      optional :span, :message, 5, "gauge.messages.Span"
    end
    add_message "gauge.messages.UnsupportedMessageResponse" do
      optional :message, :string, 1
    end
    add_message "gauge.messages.CacheFileRequest" do
      optional :content, :string, 1
      optional :filePath, :string, 2
      optional :isClosed, :bool, 3
      optional :status, :enum, 4, "gauge.messages.CacheFileRequest.FileStatus"
    end
    add_enum "gauge.messages.CacheFileRequest.FileStatus" do
      value :CHANGED, 0
      value :CLOSED, 1
      value :CREATED, 2
      value :DELETED, 3
      value :OPENED, 4
    end
    add_message "gauge.messages.StepPositionsRequest" do
      optional :filePath, :string, 1
    end
    add_message "gauge.messages.StepPositionsResponse" do
      repeated :stepPositions, :message, 1, "gauge.messages.StepPositionsResponse.StepPosition"
      optional :error, :string, 2
    end
    add_message "gauge.messages.StepPositionsResponse.StepPosition" do
      optional :stepValue, :string, 1
      optional :span, :message, 2, "gauge.messages.Span"
    end
    add_message "gauge.messages.ImplementationFileGlobPatternRequest" do
    end
    add_message "gauge.messages.ImplementationFileGlobPatternResponse" do
      repeated :globPatterns, :string, 1
    end
    add_message "gauge.messages.ImplementationFileListRequest" do
    end
    add_message "gauge.messages.ImplementationFileListResponse" do
      repeated :implementationFilePaths, :string, 1
    end
    add_message "gauge.messages.StubImplementationCodeRequest" do
      optional :implementationFilePath, :string, 1
      repeated :codes, :string, 2
    end
    add_message "gauge.messages.TextDiff" do
      optional :span, :message, 1, "gauge.messages.Span"
      optional :content, :string, 2
    end
    add_message "gauge.messages.FileDiff" do
      optional :filePath, :string, 1
      repeated :textDiffs, :message, 2, "gauge.messages.TextDiff"
    end
    add_message "gauge.messages.KeepAlive" do
      optional :pluginId, :string, 1
    end
    add_message "gauge.messages.Empty" do
    end
    add_message "gauge.messages.Message" do
      optional :messageType, :enum, 1, "gauge.messages.Message.MessageType"
      optional :messageId, :int64, 2
      optional :executionStartingRequest, :message, 3, "gauge.messages.ExecutionStartingRequest"
      optional :specExecutionStartingRequest, :message, 4, "gauge.messages.SpecExecutionStartingRequest"
      optional :specExecutionEndingRequest, :message, 5, "gauge.messages.SpecExecutionEndingRequest"
      optional :scenarioExecutionStartingRequest, :message, 6, "gauge.messages.ScenarioExecutionStartingRequest"
      optional :scenarioExecutionEndingRequest, :message, 7, "gauge.messages.ScenarioExecutionEndingRequest"
      optional :stepExecutionStartingRequest, :message, 8, "gauge.messages.StepExecutionStartingRequest"
      optional :stepExecutionEndingRequest, :message, 9, "gauge.messages.StepExecutionEndingRequest"
      optional :executeStepRequest, :message, 10, "gauge.messages.ExecuteStepRequest"
      optional :executionEndingRequest, :message, 11, "gauge.messages.ExecutionEndingRequest"
      optional :stepValidateRequest, :message, 12, "gauge.messages.StepValidateRequest"
      optional :stepValidateResponse, :message, 13, "gauge.messages.StepValidateResponse"
      optional :executionStatusResponse, :message, 14, "gauge.messages.ExecutionStatusResponse"
      optional :stepNamesRequest, :message, 15, "gauge.messages.StepNamesRequest"
      optional :stepNamesResponse, :message, 16, "gauge.messages.StepNamesResponse"
      optional :suiteExecutionResult, :message, 17, "gauge.messages.SuiteExecutionResult"
      optional :killProcessRequest, :message, 18, "gauge.messages.KillProcessRequest"
      optional :scenarioDataStoreInitRequest, :message, 19, "gauge.messages.ScenarioDataStoreInitRequest"
      optional :specDataStoreInitRequest, :message, 20, "gauge.messages.SpecDataStoreInitRequest"
      optional :suiteDataStoreInitRequest, :message, 21, "gauge.messages.SuiteDataStoreInitRequest"
      optional :stepNameRequest, :message, 22, "gauge.messages.StepNameRequest"
      optional :stepNameResponse, :message, 23, "gauge.messages.StepNameResponse"
      optional :refactorRequest, :message, 24, "gauge.messages.RefactorRequest"
      optional :refactorResponse, :message, 25, "gauge.messages.RefactorResponse"
      optional :unsupportedMessageResponse, :message, 26, "gauge.messages.UnsupportedMessageResponse"
      optional :cacheFileRequest, :message, 27, "gauge.messages.CacheFileRequest"
      optional :stepPositionsRequest, :message, 28, "gauge.messages.StepPositionsRequest"
      optional :stepPositionsResponse, :message, 29, "gauge.messages.StepPositionsResponse"
      optional :implementationFileListRequest, :message, 30, "gauge.messages.ImplementationFileListRequest"
      optional :implementationFileListResponse, :message, 31, "gauge.messages.ImplementationFileListResponse"
      optional :stubImplementationCodeRequest, :message, 32, "gauge.messages.StubImplementationCodeRequest"
      optional :fileDiff, :message, 33, "gauge.messages.FileDiff"
      optional :implementationFileGlobPatternRequest, :message, 34, "gauge.messages.ImplementationFileGlobPatternRequest"
      optional :implementationFileGlobPatternResponse, :message, 35, "gauge.messages.ImplementationFileGlobPatternResponse"
      optional :suiteExecutionResultItem, :message, 36, "gauge.messages.SuiteExecutionResultItem"
      optional :keepAlive, :message, 37, "gauge.messages.KeepAlive"
    end
    add_enum "gauge.messages.Message.MessageType" do
      value :ExecutionStarting, 0
      value :SpecExecutionStarting, 1
      value :SpecExecutionEnding, 2
      value :ScenarioExecutionStarting, 3
      value :ScenarioExecutionEnding, 4
      value :StepExecutionStarting, 5
      value :StepExecutionEnding, 6
      value :ExecuteStep, 7
      value :ExecutionEnding, 8
      value :StepValidateRequest, 9
      value :StepValidateResponse, 10
      value :ExecutionStatusResponse, 11
      value :StepNamesRequest, 12
      value :StepNamesResponse, 13
      value :KillProcessRequest, 14
      value :SuiteExecutionResult, 15
      value :ScenarioDataStoreInit, 16
      value :SpecDataStoreInit, 17
      value :SuiteDataStoreInit, 18
      value :StepNameRequest, 19
      value :StepNameResponse, 20
      value :RefactorRequest, 21
      value :RefactorResponse, 22
      value :UnsupportedMessageResponse, 23
      value :CacheFileRequest, 24
      value :StepPositionsRequest, 25
      value :StepPositionsResponse, 26
      value :ImplementationFileListRequest, 27
      value :ImplementationFileListResponse, 28
      value :StubImplementationCodeRequest, 29
      value :FileDiff, 30
      value :ImplementationFileGlobPatternRequest, 31
      value :ImplementationFileGlobPatternResponse, 32
      value :SuiteExecutionResultItem, 33
      value :KeepAlive, 34
    end
  end
end

module Gauge
  module Messages
    KillProcessRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.KillProcessRequest").msgclass
    ExecutionStatusResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ExecutionStatusResponse").msgclass
    ExecutionStartingRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ExecutionStartingRequest").msgclass
    ExecutionEndingRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ExecutionEndingRequest").msgclass
    SpecExecutionStartingRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.SpecExecutionStartingRequest").msgclass
    SpecExecutionEndingRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.SpecExecutionEndingRequest").msgclass
    ScenarioExecutionStartingRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ScenarioExecutionStartingRequest").msgclass
    ScenarioExecutionEndingRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ScenarioExecutionEndingRequest").msgclass
    StepExecutionStartingRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StepExecutionStartingRequest").msgclass
    StepExecutionEndingRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StepExecutionEndingRequest").msgclass
    ExecutionArg = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ExecutionArg").msgclass
    ExecutionInfo = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ExecutionInfo").msgclass
    SpecInfo = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.SpecInfo").msgclass
    ScenarioInfo = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ScenarioInfo").msgclass
    StepInfo = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StepInfo").msgclass
    ExecuteStepRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ExecuteStepRequest").msgclass
    StepValidateRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StepValidateRequest").msgclass
    StepValidateResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StepValidateResponse").msgclass
    StepValidateResponse::ErrorType = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StepValidateResponse.ErrorType").enummodule
    SuiteExecutionResult = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.SuiteExecutionResult").msgclass
    SuiteExecutionResultItem = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.SuiteExecutionResultItem").msgclass
    StepNamesRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StepNamesRequest").msgclass
    StepNamesResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StepNamesResponse").msgclass
    ScenarioDataStoreInitRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ScenarioDataStoreInitRequest").msgclass
    SpecDataStoreInitRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.SpecDataStoreInitRequest").msgclass
    SuiteDataStoreInitRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.SuiteDataStoreInitRequest").msgclass
    ParameterPosition = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ParameterPosition").msgclass
    RefactorRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.RefactorRequest").msgclass
    FileChanges = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.FileChanges").msgclass
    RefactorResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.RefactorResponse").msgclass
    StepNameRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StepNameRequest").msgclass
    StepNameResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StepNameResponse").msgclass
    UnsupportedMessageResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.UnsupportedMessageResponse").msgclass
    CacheFileRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.CacheFileRequest").msgclass
    CacheFileRequest::FileStatus = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.CacheFileRequest.FileStatus").enummodule
    StepPositionsRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StepPositionsRequest").msgclass
    StepPositionsResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StepPositionsResponse").msgclass
    StepPositionsResponse::StepPosition = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StepPositionsResponse.StepPosition").msgclass
    ImplementationFileGlobPatternRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ImplementationFileGlobPatternRequest").msgclass
    ImplementationFileGlobPatternResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ImplementationFileGlobPatternResponse").msgclass
    ImplementationFileListRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ImplementationFileListRequest").msgclass
    ImplementationFileListResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.ImplementationFileListResponse").msgclass
    StubImplementationCodeRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.StubImplementationCodeRequest").msgclass
    TextDiff = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.TextDiff").msgclass
    FileDiff = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.FileDiff").msgclass
    KeepAlive = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.KeepAlive").msgclass
    Empty = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.Empty").msgclass
    Message = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.Message").msgclass
    Message::MessageType = Google::Protobuf::DescriptorPool.generated_pool.lookup("gauge.messages.Message.MessageType").enummodule
  end
end
