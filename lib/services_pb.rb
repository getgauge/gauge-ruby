# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: services.proto

require 'google/protobuf'

require 'messages_pb'


descriptor_data = "\n\x0eservices.proto\x12\x0egauge.messages\x1a\x0emessages.proto2\xe7\x12\n\x06Runner\x12Y\n\x0cValidateStep\x12#.gauge.messages.StepValidateRequest\x1a$.gauge.messages.StepValidateResponse\x12n\n\x18InitializeSuiteDataStore\x12).gauge.messages.SuiteDataStoreInitRequest\x1a\'.gauge.messages.ExecutionStatusResponse\x12\x63\n\x0eStartExecution\x12(.gauge.messages.ExecutionStartingRequest\x1a\'.gauge.messages.ExecutionStatusResponse\x12l\n\x17InitializeSpecDataStore\x12(.gauge.messages.SpecDataStoreInitRequest\x1a\'.gauge.messages.ExecutionStatusResponse\x12k\n\x12StartSpecExecution\x12,.gauge.messages.SpecExecutionStartingRequest\x1a\'.gauge.messages.ExecutionStatusResponse\x12t\n\x1bInitializeScenarioDataStore\x12,.gauge.messages.ScenarioDataStoreInitRequest\x1a\'.gauge.messages.ExecutionStatusResponse\x12s\n\x16StartScenarioExecution\x12\x30.gauge.messages.ScenarioExecutionStartingRequest\x1a\'.gauge.messages.ExecutionStatusResponse\x12k\n\x12StartStepExecution\x12,.gauge.messages.StepExecutionStartingRequest\x1a\'.gauge.messages.ExecutionStatusResponse\x12Z\n\x0b\x45xecuteStep\x12\".gauge.messages.ExecuteStepRequest\x1a\'.gauge.messages.ExecutionStatusResponse\x12j\n\x13\x46inishStepExecution\x12*.gauge.messages.StepExecutionEndingRequest\x1a\'.gauge.messages.ExecutionStatusResponse\x12r\n\x17\x46inishScenarioExecution\x12..gauge.messages.ScenarioExecutionEndingRequest\x1a\'.gauge.messages.ExecutionStatusResponse\x12j\n\x13\x46inishSpecExecution\x12*.gauge.messages.SpecExecutionEndingRequest\x1a\'.gauge.messages.ExecutionStatusResponse\x12\x62\n\x0f\x46inishExecution\x12&.gauge.messages.ExecutionEndingRequest\x1a\'.gauge.messages.ExecutionStatusResponse\x12\x44\n\tCacheFile\x12 .gauge.messages.CacheFileRequest\x1a\x15.gauge.messages.Empty\x12P\n\x0bGetStepName\x12\x1f.gauge.messages.StepNameRequest\x1a .gauge.messages.StepNameResponse\x12_\n\x0fGetGlobPatterns\x12\x15.gauge.messages.Empty\x1a\x35.gauge.messages.ImplementationFileGlobPatternResponse\x12S\n\x0cGetStepNames\x12 .gauge.messages.StepNamesRequest\x1a!.gauge.messages.StepNamesResponse\x12_\n\x10GetStepPositions\x12$.gauge.messages.StepPositionsRequest\x1a%.gauge.messages.StepPositionsResponse\x12_\n\x16GetImplementationFiles\x12\x15.gauge.messages.Empty\x1a..gauge.messages.ImplementationFileListResponse\x12X\n\rImplementStub\x12-.gauge.messages.StubImplementationCodeRequest\x1a\x18.gauge.messages.FileDiff\x12M\n\x08Refactor\x12\x1f.gauge.messages.RefactorRequest\x1a .gauge.messages.RefactorResponse\x12\x41\n\x04Kill\x12\".gauge.messages.KillProcessRequest\x1a\x15.gauge.messages.Empty\x12z\n\x1eNotifyConceptExecutionStarting\x12/.gauge.messages.ConceptExecutionStartingRequest\x1a\'.gauge.messages.ExecutionStatusResponse\x12v\n\x1cNotifyConceptExecutionEnding\x12-.gauge.messages.ConceptExecutionEndingRequest\x1a\'.gauge.messages.ExecutionStatusResponse2\xff\x08\n\x08Reporter\x12Z\n\x17NotifyExecutionStarting\x12(.gauge.messages.ExecutionStartingRequest\x1a\x15.gauge.messages.Empty\x12\x62\n\x1bNotifySpecExecutionStarting\x12,.gauge.messages.SpecExecutionStartingRequest\x1a\x15.gauge.messages.Empty\x12j\n\x1fNotifyScenarioExecutionStarting\x12\x30.gauge.messages.ScenarioExecutionStartingRequest\x1a\x15.gauge.messages.Empty\x12h\n\x1eNotifyConceptExecutionStarting\x12/.gauge.messages.ConceptExecutionStartingRequest\x1a\x15.gauge.messages.Empty\x12\x64\n\x1cNotifyConceptExecutionEnding\x12-.gauge.messages.ConceptExecutionEndingRequest\x1a\x15.gauge.messages.Empty\x12\x62\n\x1bNotifyStepExecutionStarting\x12,.gauge.messages.StepExecutionStartingRequest\x1a\x15.gauge.messages.Empty\x12^\n\x19NotifyStepExecutionEnding\x12*.gauge.messages.StepExecutionEndingRequest\x1a\x15.gauge.messages.Empty\x12\x66\n\x1dNotifyScenarioExecutionEnding\x12..gauge.messages.ScenarioExecutionEndingRequest\x1a\x15.gauge.messages.Empty\x12^\n\x19NotifySpecExecutionEnding\x12*.gauge.messages.SpecExecutionEndingRequest\x1a\x15.gauge.messages.Empty\x12V\n\x15NotifyExecutionEnding\x12&.gauge.messages.ExecutionEndingRequest\x1a\x15.gauge.messages.Empty\x12P\n\x11NotifySuiteResult\x12$.gauge.messages.SuiteExecutionResult\x1a\x15.gauge.messages.Empty\x12\x41\n\x04Kill\x12\".gauge.messages.KillProcessRequest\x1a\x15.gauge.messages.Empty2\x93\x01\n\nDocumenter\x12\x42\n\x0cGenerateDocs\x12\x1b.gauge.messages.SpecDetails\x1a\x15.gauge.messages.Empty\x12\x41\n\x04Kill\x12\".gauge.messages.KillProcessRequest\x1a\x15.gauge.messages.EmptyB\\\n\x16\x63om.thoughtworks.gaugeZ1github.com/getgauge/gauge-proto/go/gauge_messages\xaa\x02\x0eGauge.Messagesb\x06proto3"

pool = Google::Protobuf::DescriptorPool.generated_pool
pool.add_serialized_file(descriptor_data)

module Gauge
  module Messages
  end
end
