-- status: correct
-- teardown_command: rm -rf tlmbuses-lua/
-- linux: yes
-- mingw: yes
-- win: no
-- mac: no

oms_setCommandLineOption("--suppressPath=true")
oms_setTempDirectory("./tlmbuses-lua/")

function printStatus(status, expected)
  cmp = ""
  if status == expected then
    cmp = "correct"
  else
    cmp = "wrong"
  end

  if 0 == status then
    status = "ok"
  elseif 1 == status then
    status = "warning"
  elseif 3 == status then
    status = "error"
  end
  print("status:  [" .. cmp .. "] " .. status)
end

oms_newModel("model")
oms_addSystem("model.tlm", oms_system_tlm)
oms_setTLMSocketData("model.tlm", "127.0.1.1", 11111, 11121)
oms_addSystem("model.tlm.wc1", oms_system_wc)
oms_addConnector("model.tlm.wc1.y", oms_causality_output, oms_signal_type_real)
oms_addConnector("model.tlm.wc1.x", oms_causality_output, oms_signal_type_real)
oms_addConnector("model.tlm.wc1.v", oms_causality_output, oms_signal_type_real)
oms_addConnector("model.tlm.wc1.f", oms_causality_input, oms_signal_type_real)

oms_addSystem("model.tlm.wc2", oms_system_wc)
oms_addConnector("model.tlm.wc2.y", oms_causality_input, oms_signal_type_real)
oms_addConnector("model.tlm.wc2.x", oms_causality_output, oms_signal_type_real)
oms_addConnector("model.tlm.wc2.v", oms_causality_output, oms_signal_type_real)
oms_addConnector("model.tlm.wc2.f", oms_causality_input, oms_signal_type_real)

status = oms_addTLMBus("model.tlm.wc1.bus1", oms_tlm_domain_input, 1, oms_tlm_no_interpolation)
printStatus(status, 0)

status = oms_addConnectorToTLMBus("model.tlm.wc1.bus1","model.tlm.wc1.y", "value")
printStatus(status, 0)

-- Test adding non-existing connector
status = oms_addConnectorToTLMBus("model.tlm.wc1.bus1","model.tlm.wc1.z", "value")
printStatus(status, 3)

-- Test adding connector with illegal type
status = oms_addConnectorToTLMBus("model.tlm.wc1.bus1","model.tlm.wc1.y", "effort")
printStatus(status, 3)

status = oms_addTLMBus("model.tlm.wc1.bus2", oms_tlm_domain_mechanical, 1, oms_tlm_no_interpolation)
printStatus(status, 0)

status = oms_addConnectorToTLMBus("model.tlm.wc1.bus2","model.tlm.wc1.x", "state")
printStatus(status, 0)

status = oms_addConnectorToTLMBus("model.tlm.wc1.bus2","model.tlm.wc1.v", "flow")
printStatus(status, 0)

-- Test adding already existing variable type to bus
status = oms_addConnectorToTLMBus("model.tlm.wc1.bus2","model.tlm.wc1.f", "flow")
printStatus(status, 3)

status = oms_addConnectorToTLMBus("model.tlm.wc1.bus2","model.tlm.wc1.f", "effort")
printStatus(status, 0)

status = oms_addTLMBus("model.tlm.wc2.bus2", oms_tlm_domain_output, 1, oms_tlm_no_interpolation)
printStatus(status, 0)

status = oms_addConnectorToTLMBus("model.tlm.wc2.bus2","model.tlm.wc2.y", "value")
printStatus(status, 0)

status = oms_addTLMConnection("model.tlm.wc1.bus1","model.tlm.wc2.bus2", 0.001,0.3,100,0)
printStatus(status, 0)

src, status = oms_list("model.tlm")
print(src)

status = oms_deleteConnectorFromTLMBus("model.tlm.wc1.bus2","model.tlm.wc1.x")
printStatus(status, 0)

src, status = oms_list("model.tlm")
print(src)

status = oms_delete("model")
printStatus(status, 0)

-- Result:
-- status:  [correct] ok
-- status:  [correct] ok
-- error:   [addConnectorToTLMBus] Connector "z" not found in system "model.tlm.wc1"
-- status:  [correct] error
-- error:   [addConnector] Unknown TLM variable type: "effort"
-- status:  [correct] error
-- status:  [correct] ok
-- status:  [correct] ok
-- status:  [correct] ok
-- error:   [addConnector] TLM bus connector "bus2" already contains a variable with type "flow"
-- status:  [correct] error
-- status:  [correct] ok
-- status:  [correct] ok
-- status:  [correct] ok
-- status:  [correct] ok
-- <?xml version="1.0"?>
-- <ssd:System name="tlm">
-- 	<ssd:Elements>
-- 		<ssd:System name="wc2">
-- 			<ssd:Connectors>
-- 				<ssd:Connector name="y" kind="input">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 				<ssd:Connector name="x" kind="output">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 				<ssd:Connector name="v" kind="output">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 				<ssd:Connector name="f" kind="input">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 			</ssd:Connectors>
-- 			<ssd:Annotations>
-- 				<ssc:Annotation type="org.openmodelica">
-- 					<oms:Annotations>
-- 						<oms:Buses>
-- 							<oms:Bus name="bus2" type="tlm" domain="output" dimensions="1" interpolation="none">
-- 								<oms:Signals>
-- 									<oms:Signal name="y" type="value" />
-- 								</oms:Signals>
-- 							</oms:Bus>
-- 						</oms:Buses>
-- 						<oms:SimulationInformation>
-- 							<oms:FixedStepMaster description="oms-ma" stepSize="0.100000" absoluteTolerance="0.000100" relativeTolerance="0.000100" />
-- 						</oms:SimulationInformation>
-- 					</oms:Annotations>
-- 				</ssc:Annotation>
-- 			</ssd:Annotations>
-- 		</ssd:System>
-- 		<ssd:System name="wc1">
-- 			<ssd:Connectors>
-- 				<ssd:Connector name="y" kind="output">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 				<ssd:Connector name="x" kind="output">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 				<ssd:Connector name="v" kind="output">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 				<ssd:Connector name="f" kind="input">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 			</ssd:Connectors>
-- 			<ssd:Annotations>
-- 				<ssc:Annotation type="org.openmodelica">
-- 					<oms:Annotations>
-- 						<oms:Buses>
-- 							<oms:Bus name="bus1" type="tlm" domain="input" dimensions="1" interpolation="none">
-- 								<oms:Signals>
-- 									<oms:Signal name="y" type="value" />
-- 								</oms:Signals>
-- 							</oms:Bus>
-- 							<oms:Bus name="bus2" type="tlm" domain="mechanical" dimensions="1" interpolation="none">
-- 								<oms:Signals>
-- 									<oms:Signal name="f" type="effort" />
-- 									<oms:Signal name="v" type="flow" />
-- 									<oms:Signal name="x" type="state" />
-- 								</oms:Signals>
-- 							</oms:Bus>
-- 						</oms:Buses>
-- 						<oms:SimulationInformation>
-- 							<oms:FixedStepMaster description="oms-ma" stepSize="0.100000" absoluteTolerance="0.000100" relativeTolerance="0.000100" />
-- 						</oms:SimulationInformation>
-- 					</oms:Annotations>
-- 				</ssc:Annotation>
-- 			</ssd:Annotations>
-- 		</ssd:System>
-- 	</ssd:Elements>
-- 	<ssd:Annotations>
-- 		<ssc:Annotation type="org.openmodelica">
-- 			<oms:Annotations>
-- 				<oms:Connections>
-- 					<oms:Connection startElement="wc1" startConnector="bus1" endElement="wc2" endConnector="bus2" delay="0.001000" alpha="0.300000" linearimpedance="100.000000" angularimpedance="0.000000" />
-- 				</oms:Connections>
-- 				<oms:SimulationInformation>
-- 					<oms:TlmMaster ip="127.0.1.1" managerport="11111" monitorport="11121" />
-- 				</oms:SimulationInformation>
-- 			</oms:Annotations>
-- 		</ssc:Annotation>
-- 	</ssd:Annotations>
-- </ssd:System>
--
-- status:  [correct] ok
-- <?xml version="1.0"?>
-- <ssd:System name="tlm">
-- 	<ssd:Elements>
-- 		<ssd:System name="wc2">
-- 			<ssd:Connectors>
-- 				<ssd:Connector name="y" kind="input">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 				<ssd:Connector name="x" kind="output">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 				<ssd:Connector name="v" kind="output">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 				<ssd:Connector name="f" kind="input">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 			</ssd:Connectors>
-- 			<ssd:Annotations>
-- 				<ssc:Annotation type="org.openmodelica">
-- 					<oms:Annotations>
-- 						<oms:Buses>
-- 							<oms:Bus name="bus2" type="tlm" domain="output" dimensions="1" interpolation="none">
-- 								<oms:Signals>
-- 									<oms:Signal name="y" type="value" />
-- 								</oms:Signals>
-- 							</oms:Bus>
-- 						</oms:Buses>
-- 						<oms:SimulationInformation>
-- 							<oms:FixedStepMaster description="oms-ma" stepSize="0.100000" absoluteTolerance="0.000100" relativeTolerance="0.000100" />
-- 						</oms:SimulationInformation>
-- 					</oms:Annotations>
-- 				</ssc:Annotation>
-- 			</ssd:Annotations>
-- 		</ssd:System>
-- 		<ssd:System name="wc1">
-- 			<ssd:Connectors>
-- 				<ssd:Connector name="y" kind="output">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 				<ssd:Connector name="x" kind="output">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 				<ssd:Connector name="v" kind="output">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 				<ssd:Connector name="f" kind="input">
-- 					<ssc:Real />
-- 				</ssd:Connector>
-- 			</ssd:Connectors>
-- 			<ssd:Annotations>
-- 				<ssc:Annotation type="org.openmodelica">
-- 					<oms:Annotations>
-- 						<oms:Buses>
-- 							<oms:Bus name="bus1" type="tlm" domain="input" dimensions="1" interpolation="none">
-- 								<oms:Signals>
-- 									<oms:Signal name="y" type="value" />
-- 								</oms:Signals>
-- 							</oms:Bus>
-- 							<oms:Bus name="bus2" type="tlm" domain="mechanical" dimensions="1" interpolation="none">
-- 								<oms:Signals>
-- 									<oms:Signal name="f" type="effort" />
-- 									<oms:Signal name="v" type="flow" />
-- 								</oms:Signals>
-- 							</oms:Bus>
-- 						</oms:Buses>
-- 						<oms:SimulationInformation>
-- 							<oms:FixedStepMaster description="oms-ma" stepSize="0.100000" absoluteTolerance="0.000100" relativeTolerance="0.000100" />
-- 						</oms:SimulationInformation>
-- 					</oms:Annotations>
-- 				</ssc:Annotation>
-- 			</ssd:Annotations>
-- 		</ssd:System>
-- 	</ssd:Elements>
-- 	<ssd:Annotations>
-- 		<ssc:Annotation type="org.openmodelica">
-- 			<oms:Annotations>
-- 				<oms:Connections>
-- 					<oms:Connection startElement="wc1" startConnector="bus1" endElement="wc2" endConnector="bus2" delay="0.001000" alpha="0.300000" linearimpedance="100.000000" angularimpedance="0.000000" />
-- 				</oms:Connections>
-- 				<oms:SimulationInformation>
-- 					<oms:TlmMaster ip="127.0.1.1" managerport="11111" monitorport="11121" />
-- 				</oms:SimulationInformation>
-- 			</oms:Annotations>
-- 		</ssc:Annotation>
-- 	</ssd:Annotations>
-- </ssd:System>
--
-- status:  [correct] ok
-- info:    0 warnings
-- info:    3 errors
-- endResult
