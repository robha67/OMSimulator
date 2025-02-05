-- status: correct
-- teardown_command: rm -rf importStartValues-lua/
-- linux: yes
-- mingw: yes
-- win: no
-- mac: no

oms_setCommandLineOption("--suppressPath=true --exportParametersInline=false")

oms_setTempDirectory("./importStartValues-lua/")

oms_importFile("../resources/importStartValues.ssp");

src1 = oms_exportSnapshot("importStartValues")
print(src1)

oms_setStopTime("importStartValues", 2)

oms_instantiate("importStartValues")

oms_initialize("importStartValues")
oms_simulate("importStartValues")

oms_terminate("importStartValues")
oms_delete("importStartValues")


-- Result:
-- warning: Wrong/deprecated content detected but successfully loaded. Please re-export the SSP file to avoid this message.
-- warning: Wrong/deprecated content detected but successfully loaded. Please re-export the SSP file to avoid this message.
-- warning: Wrong/deprecated content detected but successfully loaded. Please re-export the SSP file to avoid this message.
-- warning: Wrong/deprecated content detected but successfully loaded. Please re-export the SSP file to avoid this message.
-- warning: Wrong/deprecated content detected but successfully loaded. Please re-export the SSP file to avoid this message.
-- <?xml version="1.0"?>
-- <oms:snapshot
--   xmlns:oms="https://raw.githubusercontent.com/OpenModelica/OMSimulator/master/schema/oms.xsd"
--   partial="false">
--   <oms:file
--     name="SystemStructure.ssd">
--     <ssd:SystemStructureDescription
--       xmlns:ssc="http://ssp-standard.org/SSP1/SystemStructureCommon"
--       xmlns:ssd="http://ssp-standard.org/SSP1/SystemStructureDescription"
--       xmlns:ssv="http://ssp-standard.org/SSP1/SystemStructureParameterValues"
--       xmlns:ssm="http://ssp-standard.org/SSP1/SystemStructureParameterMapping"
--       xmlns:ssb="http://ssp-standard.org/SSP1/SystemStructureSignalDictionary"
--       xmlns:oms="https://raw.githubusercontent.com/OpenModelica/OMSimulator/master/schema/oms.xsd"
--       name="importStartValues"
--       version="1.0">
--       <ssd:System
--         name="root">
--         <ssd:Connectors>
--           <ssd:Connector
--             name="C1"
--             kind="input">
--             <ssc:Real />
--           </ssd:Connector>
--         </ssd:Connectors>
--         <ssd:ParameterBindings>
--           <ssd:ParameterBinding
--             source="resources/importStartValues.ssv" />
--         </ssd:ParameterBindings>
--         <ssd:Elements>
--           <ssd:System
--             name="System1">
--             <ssd:Connectors>
--               <ssd:Connector
--                 name="C1"
--                 kind="input">
--                 <ssc:Real />
--               </ssd:Connector>
--               <ssd:Connector
--                 name="C2"
--                 kind="parameter">
--                 <ssc:Real />
--               </ssd:Connector>
--               <ssd:Connector
--                 name="C3"
--                 kind="output">
--                 <ssc:Real />
--               </ssd:Connector>
--             </ssd:Connectors>
--             <ssd:Annotations>
--               <ssc:Annotation
--                 type="org.openmodelica">
--                 <oms:Annotations>
--                   <oms:SimulationInformation>
--                     <oms:VariableStepSolver
--                       description="euler"
--                       absoluteTolerance="0.000100"
--                       relativeTolerance="0.000100"
--                       minimumStepSize="0.000100"
--                       maximumStepSize="0.100000"
--                       initialStepSize="0.000100" />
--                   </oms:SimulationInformation>
--                 </oms:Annotations>
--               </ssc:Annotation>
--             </ssd:Annotations>
--           </ssd:System>
--         </ssd:Elements>
--         <ssd:Annotations>
--           <ssc:Annotation
--             type="org.openmodelica">
--             <oms:Annotations>
--               <oms:SimulationInformation>
--                 <oms:FixedStepMaster
--                   description="oms-ma"
--                   stepSize="0.100000"
--                   absoluteTolerance="0.000100"
--                   relativeTolerance="0.000100" />
--               </oms:SimulationInformation>
--             </oms:Annotations>
--           </ssc:Annotation>
--         </ssd:Annotations>
--       </ssd:System>
--       <ssd:DefaultExperiment
--         startTime="0.000000"
--         stopTime="1.000000">
--         <ssd:Annotations>
--           <ssc:Annotation
--             type="org.openmodelica">
--             <oms:Annotations>
--               <oms:SimulationInformation
--                 resultFile="importStartValues_res.mat"
--                 loggingInterval="0.000000"
--                 bufferSize="10"
--                 signalFilter="resources/signalFilter.xml" />
--             </oms:Annotations>
--           </ssc:Annotation>
--         </ssd:Annotations>
--       </ssd:DefaultExperiment>
--     </ssd:SystemStructureDescription>
--   </oms:file>
--   <oms:file
--     name="resources/importStartValues.ssv">
--     <ssv:ParameterSet
--       xmlns:ssc="http://ssp-standard.org/SSP1/SystemStructureCommon"
--       xmlns:ssv="http://ssp-standard.org/SSP1/SystemStructureParameterValues"
--       version="1.0"
--       name="parameters">
--       <ssv:Parameters>
--         <ssv:Parameter
--           name="C1">
--           <ssv:Real
--             value="-10.5" />
--         </ssv:Parameter>
--         <ssv:Parameter
--           name="System1.C2">
--           <ssv:Real
--             value="3.5" />
--         </ssv:Parameter>
--         <ssv:Parameter
--           name="System1.C1">
--           <ssv:Real
--             value="-13.5" />
--         </ssv:Parameter>
--       </ssv:Parameters>
--     </ssv:ParameterSet>
--   </oms:file>
--   <oms:file
--     name="resources/signalFilter.xml">
--     <oms:SignalFilter
--       version="1.0">
--       <oms:Variable
--         name="importStartValues.root.C1"
--         type="Real"
--         kind="input" />
--       <oms:Variable
--         name="importStartValues.root.System1.C1"
--         type="Real"
--         kind="input" />
--       <oms:Variable
--         name="importStartValues.root.System1.C2"
--         type="Real"
--         kind="parameter" />
--       <oms:Variable
--         name="importStartValues.root.System1.C3"
--         type="Real"
--         kind="output" />
--     </oms:SignalFilter>
--   </oms:file>
-- </oms:snapshot>
--
-- info:    model doesn't contain any continuous state
-- info:    Result file: importStartValues_res.mat (bufferSize=10)
-- info:    5 warnings
-- info:    0 errors
-- endResult
