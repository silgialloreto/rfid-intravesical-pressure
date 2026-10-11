'# MWS Version: Version 2021.1 - Nov 10 2020 - ACIS 30.0.1 -

'# length = mm
'# frequency = MHz
'# time = ns
'# frequency range: fmin = 700 fmax = 1200
'# created = '[VERSION]2021.1|30.0.1|20201110[/VERSION]


'@ use template: Antenna - Planar_2.cfg

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "MHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "H"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "F"
End With

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "700", "1200"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' optimize mesh settings for planar structures

With Mesh
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "20"
     .AutomeshRefineAtPecLines "True", "6"
     .FPBAAvoidNonRegUnite "True"
     .ConsiderSpaceForLowerMeshLimit "False"
     .MinimumStepNumber "5"
     .AnisotropicCurvatureRefinement "True"
     .AnisotropicCurvatureRefinementFSM "True"
End With

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "6"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

' change mesh adaption scheme to energy
' 		(planar structures tend to store high energy
'     	 locally at edges rather than globally in volume)

MeshAdaption3D.SetAdaptionStrategy "Energy"

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "700;950;1200"
Dim sDefineAtName As String
sDefineAtName = "700;950;1200"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Tet"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "Tetrahedral"
End With

'set the solver type
ChangeSolverType("HF Frequency Domain")

'----------------------------------------------------------------------------

'@ switch working plane

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Plot.DrawWorkplane "false"

'@ paste structure data: 1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Material 
     .Reset 
     .Name "Bladder" 
     .Folder "" 
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "MHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "18.9"
     .Mu "1"
     .Sigma "0.38506"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "0", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With 

With Material 
     .Reset 
     .Name "Copper (annealed)_1" 
     .Folder "" 
     .Rho "8930.0"
     .ThermalType "Normal"
     .ThermalConductivity "401.0"
     .SpecificHeat "390", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0"
     .VoxelConvection "0"
     .BloodFlow "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "120"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "17"
     .FrqType "static"
     .Type "Normal"
     .MaterialUnit "Frequency", "Hz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "1"
     .Mu "1.0"
     .Sigma "5.8e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Mu "1.0"
     .Sigma "5.8e+007"
     .LossyMetalSIRoughness "0.0"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "1", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With 

With Material 
     .Reset 
     .Name "Fat" 
     .Folder "" 
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "MHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "5.4596"
     .Mu "1"
     .Sigma "0.051402"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "0.501961", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With 

With Material 
     .Reset 
     .Name "Muscle" 
     .Folder "" 
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "MHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "55"
     .Mu "1"
     .Sigma "0.95"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "0.501961", "0.752941" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With 

With Material 
     .Reset 
     .Name "Skin" 
     .Folder "" 
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "MHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "41.329"
     .Mu "1"
     .Sigma "0.87169"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "0.501961", "0.501961" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With 

With Material 
     .Reset 
     .Name "Air" 
     .Folder "Urine" 
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "MHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "34.5"
     .Mu "1"
     .Sigma "0.82"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0", "1", "0.501961" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With 

With SAT 
     .Reset 
     .FileName "*1.cby" 
     .SubProjectScaleFactor "0.001" 
     .ImportToActiveCoordinateSystem "True" 
     .ScaleToUnit "True" 
     .Curves "False" 
     .Read 
End With

'@ paste structure data: 2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Material 
     .Reset 
     .Name "Copper (annealed)_2" 
     .Folder "" 
     .Rho "8930.0"
     .ThermalType "Normal"
     .ThermalConductivity "401.0"
     .SpecificHeat "390", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0"
     .VoxelConvection "0"
     .BloodFlow "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "120"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "17"
     .FrqType "static"
     .Type "Normal"
     .MaterialUnit "Frequency", "Hz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "1"
     .Mu "1.0"
     .Sigma "5.8e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Mu "1.0"
     .Sigma "5.8e+007"
     .LossyMetalSIRoughness "0.0"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "1", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With 

With Material 
     .Reset 
     .Name "Forex" 
     .Folder "" 
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Time", "s"
     .Epsilon "1"
     .Mu "1"
     .Sigma "0"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstSigma"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstSigma"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.752941", "0.752941", "0.752941" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With 

With Material 
     .Reset 
     .Name "Silicon" 
     .Folder "" 
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "MHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "ns"
     .MaterialUnit "Temperature", "Kelvin"
     .Epsilon "2.2"
     .Mu "1"
     .Sigma "0.005"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.501961", "0.501961", "0.501961" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With 

With SAT 
     .Reset 
     .FileName "*2.cby" 
     .SubProjectScaleFactor "0.001" 
     .SubProjectLocalWCS "70", "0", "0", "-1", "-0", "-0", "0", "0", "1" 
     .ImportToActiveCoordinateSystem "True" 
     .ScaleToUnit "True" 
     .Curves "False" 
     .Read 
End With 

With MeshSettings
     With .ItemMeshSettings ("solid$component1/Patch1:solid1")
          .SetMeshType "All" 
          .Set "Transform", "0", "0", "1", "0", "1", "0", "-1", "0", "0" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1/Patch1:solid1_1")
          .SetMeshType "All" 
          .Set "Transform", "0", "0", "1", "0", "1", "0", "-1", "0", "0" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1/Patch1:substrate")
          .SetMeshType "All" 
          .Set "Transform", "0", "0", "1", "0", "1", "0", "-1", "0", "0" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1/Patch1:strip")
          .SetMeshType "All" 
          .Set "Transform", "0", "0", "1", "0", "1", "0", "-1", "0", "0" 
     End With
End With
With MeshSettings
     With .ItemMeshSettings ("solid$component1/Patch1:strip_1")
          .SetMeshType "All" 
          .Set "Transform", "0", "0", "1", "0", "1", "0", "-1", "0", "0" 
     End With
End With

'@ transform: rotate component1/Patch1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1/Patch1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "90", "0", "0" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Rotate" 
End With

'@ transform: translate component1/Patch1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1/Patch1" 
     .Vector "0", "skin_radius", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1/Patch1:solid1_1", "1" 
WCS.AlignWCSWithSelected "Face"

'@ define discrete port: 1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter"
     .Label ""
     .Folder ""
     .Impedance "50.0"
     .VoltagePortImpedance "0.0"
     .Voltage "1.0"
     .Current "1.0"
     .Monitor "True"
     .Radius "0.0"
     .SetP1 "False", "0.6", "0.0", "0.0"
     .SetP2 "False", "0.6", "0.0", "3"
     .InvertDirection "False"
     .LocalCoordinates "True"
     .Wire ""
     .Position "end1"
     .Create 
End With

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:solid5", "5" 
WCS.AlignWCSWithSelected "Face"

'@ define discrete port: 2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "2" 
     .Type "SParameter"
     .Label ""
     .Folder ""
     .Impedance "50.0"
     .VoltagePortImpedance "0.0"
     .Voltage "1.0"
     .Current "1.0"
     .Monitor "True"
     .Radius "0.0"
     .SetP1 "False", "0.0", "0.0", "0.0"
     .SetP2 "False", "0.0", "0.0", "0.4625"
     .InvertDirection "False"
     .LocalCoordinates "True"
     .Wire ""
     .Position "end1"
     .Create 
End With

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ define frequency domain solver parameters

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "True" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .StoreSolutionCoefficients "True" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.3" 
     .UseCFIEForCPECIntEq "True" 
     .UseFastRCSSweepIntEq "false" 
     .UseSensitivityAnalysis "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "True"
     .MaxCPUs "1024"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "False" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
End With

'@ farfield plot options

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "90" 
     .Phi "90" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "-1" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .ShowStructureProfile "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .AspectRatio "Free" 
     .ShowGridlines "True" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Gain" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .IncludeUnitCellSidewalls "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .SetMaxReferenceMode "abs" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "unknown" 
     .Phistart "1.000000e+00", "0.000000e+00", "0.000000e+00" 
     .Thetastart "0.000000e+00", "0.000000e+00", "1.000000e+00" 
     .PolarizationVector "0.000000e+00", "1.000000e+00", "0.000000e+00" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+00 
     .Origin "bbox" 
     .Userorigin "0.000000e+00", "0.000000e+00", "0.000000e+00" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+00" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+01" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .AddCut "lateral", "0", "1"  
     .AddCut "lateral", "90", "1"  
     .AddCut "polar", "90", "1"  

     .StoreSettings
End With

'@ delete shapes

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Delete "component1:implantation" 
Solid.Delete "component1:solid5"

'@ delete shape: component1:UrineAir

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Delete "component1:UrineAir"

'@ delete port: port2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Port.Delete "2"

'@ define sphere: component1:Urine

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Sphere 
     .Reset 
     .Name "Urine" 
     .Component "component1" 
     .Material "Urine/Air" 
     .Axis "z" 
     .CenterRadius "urine_radius" 
     .TopRadius "0" 
     .BottomRadius "0" 
     .Center "0", "0", "0" 
     .Segments "0" 
     .Create 
End With

'@ define brick: component1:solid2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid2" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-L/2 ", "L/2" 
     .Yrange "bladder_radius", "bladder_radius +0.035" 
     .Zrange "-W/2", "W/2" 
     .Create
End With

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:solid2", "5" 
WCS.AlignWCSWithSelected "Face"

'@ define brick: component1:solid3

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid3" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-xfeed/2", "xfeed/2" 
     .Yrange "-W/2", "W/2" 
     .Zrange "-0.035", "0" 
     .Create
End With

'@ rename block: component1:solid2 to: component1:Dipole

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Rename "component1:solid2", "Dipole"

'@ boolean subtract shapes: component1:Dipole, component1:solid3

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:Dipole", "component1:solid3"

'@ define sphere: component1:solid2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Sphere 
     .Reset 
     .Name "solid2" 
     .Component "component1" 
     .Material "Vacuum" 
     .Axis "z" 
     .CenterRadius "10" 
     .TopRadius "0" 
     .BottomRadius "10" 
     .Center "0", "0", "0" 
     .Segments "0" 
     .Create 
End With

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ rename block: component1:solid2 to: component1:Incapsulation

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Rename "component1:solid2", "Incapsulation"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:Dipole", "8" 
WCS.AlignWCSWithSelected "Face"

''@ define brick: component1:solid2
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid2" 
'     .Component "component1" 
'     .Material "Copper (annealed)_1" 
'     .Xrange "-(L/2-xfeed/2)/2 + 0.5", "-(L/2-xfeed/2)/2 " 
'     .Yrange "-0.035/2", "0.035/2" 
'     .Zrange "0", "b" 
'     .Create
'End With
'
''@ align wcs with face
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Pick.ForceNextPick 
'Pick.PickFaceFromId "component1:Dipole", "15" 
'WCS.AlignWCSWithSelected "Face"
'
''@ define brick: component1:solid3
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid3" 
'     .Component "component1" 
'     .Material "Copper (annealed)_1" 
'     .Xrange "(L/2 - xfeed/2)/2 - 0.5", "(L/2 - xfeed/2)/2" 
'     .Yrange "-0.035/2", "0.035/2" 
'     .Zrange "0", "b" 
'     .Create
'End With
'
''@ align wcs with face
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Pick.ForceNextPick 
'Pick.PickFaceFromId "component1:solid2", "1" 
'WCS.AlignWCSWithSelected "Face"
'
''@ define brick: component1:solid4
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid4" 
'     .Component "component1" 
'     .Material "Copper (annealed)_1" 
'     .Xrange "-0.5/2", "a-0.5/2" 
'     .Yrange "-0.035/2", "0.035/2" 
'     .Zrange "0", "0.5" 
'     .Create
'End With
'
''@ align wcs with face
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Pick.ForceNextPick 
'Pick.PickFaceFromId "component1:solid3", "1" 
'WCS.AlignWCSWithSelected "Face"
'
''@ define brick: component1:solid5
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid5" 
'     .Component "component1" 
'     .Material "Copper (annealed)_1" 
'     .Xrange "+0.5/2 - a", "0.5/2 " 
'     .Yrange "-0.035/2", "0.035/2" 
'     .Zrange "0", "0.5" 
'     .Create
'End With
'
''@ activate global coordinates
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'WCS.ActivateWCS "global"
'
''@ align wcs with face
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Pick.ForceNextPick 
'Pick.PickFaceFromId "component1:solid4", "1" 
'WCS.AlignWCSWithSelected "Face"
'
''@ define brick: component1:solid6
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid6" 
'     .Component "component1" 
'     .Material "Copper (annealed)_1" 
'     .Xrange "a/2", "a/2 -0.5" 
'     .Yrange "-0.035/2", "0.035/2" 
'     .Zrange "0", "b" 
'     .Create
'End With
'
''@ align wcs with face
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Pick.ForceNextPick 
'Pick.PickFaceFromId "component1:solid5", "1" 
'WCS.AlignWCSWithSelected "Face"
'
''@ define brick: component1:solid7
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid7" 
'     .Component "component1" 
'     .Material "Copper (annealed)_1" 
'     .Xrange "-(a/2-0.5)", "-(a/2)" 
'     .Yrange "-0.035/2", "0.035/2" 
'     .Zrange "0", "b" 
'     .Create
'End With
'
''@ align wcs with face
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Pick.ForceNextPick 
'Pick.PickFaceFromId "component1:solid6", "1" 
'WCS.AlignWCSWithSelected "Face"
'
''@ define brick: component1:solid8
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid8" 
'     .Component "component1" 
'     .Material "Copper (annealed)_1" 
'     .Xrange "-a+0.5/2 - y", "0.5/2" 
'     .Yrange "-0.035/2", "0.035/2" 
'     .Zrange "0", "0.5" 
'     .Create
'End With
'
''@ align wcs with face
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Pick.ForceNextPick 
'Pick.PickFaceFromId "component1:solid7", "1" 
'WCS.AlignWCSWithSelected "Face"
'
''@ define brick: component1:solid9
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid9" 
'     .Component "component1" 
'     .Material "Copper (annealed)_1" 
'     .Xrange "-0.5/2", "a-0.5/2 + y" 
'     .Yrange "-0.035/2", "0.035/2" 
'     .Zrange "0", "0.5" 
'     .Create
'End With
'
'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:Dipole", "12" 
WCS.AlignWCSWithSelected "Face"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:Dipole", "11" 
WCS.AlignWCSWithSelected "Face"

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ activate local coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "local"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:Dipole", "12" 
WCS.AlignWCSWithSelected "Face"

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:Dipole", "12" 
WCS.AlignWCSWithSelected "Face"

''@ define brick: component1:solid10
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid10" 
'     .Component "component1" 
'     .Material "Copper (annealed)_1" 
'     .Xrange "-W/2", "Lt - L - W/2" 
'     .Yrange "-0.035/2", "0.035/2" 
'     .Zrange "0", "W" 
'     .Create
'End With
'
''@ align wcs with face
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Pick.ForceNextPick 
'Pick.PickFaceFromId "component1:Dipole", "10" 
'WCS.AlignWCSWithSelected "Face"
'
''@ define brick: component1:solid11
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid11" 
'     .Component "component1" 
'     .Material "Copper (annealed)_1" 
'     .Xrange "-W/2", "Lt - W/2 - L" 
'     .Yrange "-0.035/2", "0.035/2" 
'     .Zrange "0", "W" 
'     .Create
'End With
'
''@ boolean add shapes: component1:Dipole, component1:solid10
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Add "component1:Dipole", "component1:solid10"
'
''@ boolean add shapes: component1:solid11, component1:solid2
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Add "component1:solid11", "component1:solid2"
'
''@ boolean add shapes: component1:solid3, component1:solid4
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Add "component1:solid3", "component1:solid4"
'
''@ boolean add shapes: component1:solid5, component1:solid6
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Add "component1:solid5", "component1:solid6"
'
''@ boolean add shapes: component1:solid7, component1:solid8
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Add "component1:solid7", "component1:solid8"
'
''@ boolean add shapes: component1:solid7, component1:solid9
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Add "component1:solid7", "component1:solid9"
'
''@ boolean add shapes: component1:Dipole, component1:solid11
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Add "component1:Dipole", "component1:solid11"
'
''@ boolean add shapes: component1:solid3, component1:solid5
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Add "component1:solid3", "component1:solid5"
'
''@ boolean add shapes: component1:solid3, component1:solid7
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Add "component1:solid3", "component1:solid7"
'
''@ boolean add shapes: component1:Dipole, component1:solid3
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Add "component1:Dipole", "component1:solid3"
'
'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ align wcs with point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickExtraSpherepointFromId "component1:Bladder", "2", "3" 
WCS.AlignWCSWithSelectedPoint

'@ define material: Polyimide (lossy)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Material
     .Reset
     .Name "Polyimide (lossy)"
     .Folder ""
     .FrqType "all"
     .Type "Normal"
     .SetMaterialUnit "MHz", "mm"
     .Epsilon "3.5"
     .Mu "1.0"
     .Kappa "0.0"
     .TanD "0.0027"
     .TanDFreq "1.0"
     .TanDGiven "True"
     .TanDModel "ConstTanD"
     .KappaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstKappa"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "General 1st"
     .DispersiveFittingSchemeMu "General 1st"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .Rho "1400.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.20"
     .SpecificHeat "1000", "J/K/kg"
     .SetActiveMaterial "all"
     .MechanicsType "Isotropic"
     .YoungsModulus "2.5"
     .PoissonsRatio "0.4"
     .ThermalExpansionRate "25"
     .Colour "0.94", "0.82", "0.76"
     .Wireframe "False"
     .Transparency "0"
     .Create
End With

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ delete shape: component1:Incapsulation

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Delete "component1:Incapsulation"

'@ delete shapes

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Delete "component1:Fat" 
Solid.Delete "component1:Muscle"

'@ transform: translate component1:Dipole

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:Dipole" 
     .Vector "0", "3", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Shape", "Translate" 
End With

'@ define brick: component1:Kapton

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "Kapton" 
     .Component "component1" 
     .Material "Polyimide (lossy)" 
     .Xrange "-L/2 - 1", "L/2  + 1" 
     .Yrange "54.5 - 0.125", "54.5" 
     .Zrange "-W/2  -1 ", "W/2  + 1" 
     .Create
End With

''@ define brick: component1:solid2
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid2" 
'     .Component "component1" 
'     .Material "Polyimide (lossy)" 
'     .Xrange "-L/2 +0.5", "L/2 -0.5" 
'     .Yrange "54.5 - 0.125", "54.5" 
'     .Zrange "W/2 + 0.5", "Lt-L-W/2+0.5" 
'     .Create
'End With
'
''@ boolean subtract shapes: component1:Kapton, component1:solid2
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Subtract "component1:Kapton", "component1:solid2"
'
''@ define brick: component1:solid2
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid2" 
'     .Component "component1" 
'     .Material "Polyimide (lossy)" 
'     .Xrange "-xfeed/2-a-0.5", "xfeed/2+a+0.5" 
'     .Yrange "54.5 - 0.125", "54.5" 
'     .Zrange "-W/2-2*b-1.5", "0" 
'     .Create
'End With
'
''@ boolean add shapes: component1:Kapton, component1:solid2
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Add "component1:Kapton", "component1:solid2"
'
''@ define cylinder: component1:Incaps_bottom
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Cylinder 
'     .Reset 
'     .Name "Incaps_bottom" 
'     .Component "component1" 
'     .Material "Vacuum" 
'     .OuterRadius "10.5" 
'     .InnerRadius "0.0" 
'     .Axis "y" 
'     .Yrange "53.5-0.125", "54.5-0.125" 
'     .Xcenter "0" 
'     .Zcenter "0" 
'     .Segments "0" 
'     .Create 
'End With
'
''@ bend: selected sheets, component1:Bladder
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Bending 
'	.Reset 
'	.Version "10" 
'	.Sheet "component1:Incaps_bottom" 
'	.Solid "component1:Bladder" 
'	.Faces "2" 
'	.Bend 
'End With
'
''@ align wcs with face
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Pick.ForceNextPick 
'Pick.PickFaceFromId "component1:Incaps_bottom", "1" 
'WCS.AlignWCSWithSelected "Face"
'
''@ activate global coordinates
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'WCS.ActivateWCS "global"
'
''@ bend: selected sheets, component1:Incaps_bottom
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Bending 
'	.Reset 
'	.Version "10" 
'	.Sheet "component1:Kapton" 
'	.Solid "component1:Incaps_bottom" 
'	.Faces "1" 
'	.Bend 
'End With
'
''@ bend: selected sheets, component1:Kapton
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Bending 
'	.Reset 
'	.Version "10" 
'	.Sheet "component1:Dipole" 
'	.Solid "component1:Kapton" 
'	.Faces "1" 
'	.Bend 
'End With
'
''@ define cylinder: component1:Incaps
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Cylinder 
'     .Reset 
'     .Name "Incaps" 
'     .Component "component1" 
'     .Material "Vacuum" 
'     .OuterRadius "10.5" 
'     .InnerRadius "0.0" 
'     .Axis "y" 
'     .Yrange "55", "55 + h_impl" 
'     .Xcenter "0" 
'     .Zcenter "0" 
'     .Segments "0" 
'     .Create 
'End With
'
''@ bend: selected sheets, component1:Incaps_bottom
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With Bending 
'	.Reset 
'	.Version "10" 
'	.Sheet "component1:Incaps" 
'	.Solid "component1:Incaps_bottom" 
'	.Faces "1" 
'	.Bend 
'End With
'
''@ boolean insert shapes: component1:Incaps, component1:Bladder
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Insert "component1:Incaps", "component1:Bladder"
'
''@ boolean insert shapes: component1:Incaps, component1:Dipole
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Insert "component1:Incaps", "component1:Dipole"
'
''@ boolean insert shapes: component1:Incaps, component1:Kapton
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Insert "component1:Incaps", "component1:Kapton"
'
''@ boolean add shapes: component1:Incaps_bottom, component1:Incaps
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Add "component1:Incaps_bottom", "component1:Incaps"
'
'@ define brick: component1:Muscle

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "Muscle" 
     .Component "component1" 
     .Material "Muscle" 
     .Xrange "-muscle_radius", "muscle_radius" 
     .Yrange "-muscle_radius", "muscle_radius" 
     .Zrange "-muscle_radius", "muscle_radius" 
     .Create
End With

'@ boolean insert shapes: component1:Muscle, component1:Bladder

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Muscle", "component1:Bladder"

'@ boolean insert shapes: component1:Muscle, component1:Urine

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Muscle", "component1:Urine"

''@ boolean insert shapes: component1:Muscle, component1:Dipole
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Insert "component1:Muscle", "component1:Dipole"
'
''@ boolean insert shapes: component1:Muscle, component1:Kapton
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Insert "component1:Muscle", "component1:Kapton"
'
''@ boolean insert shapes: component1:Muscle, component1:Incaps_bottom
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Insert "component1:Muscle", "component1:Incaps_bottom"
'
''@ boolean insert shapes: component1:Muscle, component1:Incaps
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Insert "component1:Muscle", "component1:Incaps"
'
'@ define brick: component1:Fat

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "Fat" 
     .Component "component1" 
     .Material "Fat" 
     .Xrange "-fat_radius", "fat_radius" 
     .Yrange "-fat_radius", "fat_radius" 
     .Zrange "-fat_radius", "fat_radius" 
     .Create
End With

'@ boolean insert shapes: component1:Fat, component1:Bladder

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Fat", "component1:Bladder"

'@ boolean insert shapes: component1:Fat, component1:Urine

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Fat", "component1:Urine"

'@ boolean insert shapes: component1:Fat, component1:Dipole

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Fat", "component1:Dipole"

'@ boolean insert shapes: component1:Fat, component1:Kapton

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Fat", "component1:Kapton"

''@ boolean insert shapes: component1:Fat, component1:Incaps_bottom
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Insert "component1:Fat", "component1:Incaps_bottom"
'
''@ boolean insert shapes: component1:Fat, component1:Incaps
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Insert "component1:Fat", "component1:Incaps"
'
'@ boolean insert shapes: component1:Fat, component1:Muscle

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Fat", "component1:Muscle"

'@ switch bounding box

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Plot.DrawBox "True"

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ switch bounding box

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Plot.DrawBox "True"

'@ farfield plot options

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "90" 
     .Phi "90" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "-1" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .ShowStructureProfile "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "False" 
     .AspectRatio "Free" 
     .ShowGridlines "True" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Gain" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .IncludeUnitCellSidewalls "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .SetMaxReferenceMode "abs" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "unknown" 
     .Phistart "1.000000e+00", "0.000000e+00", "0.000000e+00" 
     .Thetastart "0.000000e+00", "0.000000e+00", "1.000000e+00" 
     .PolarizationVector "0.000000e+00", "1.000000e+00", "0.000000e+00" 
     .SetCoordinateSystemType "spherical" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Linear" 
     .SlantAngle 0.000000e+00 
     .Origin "bbox" 
     .Userorigin "0.000000e+00", "0.000000e+00", "0.000000e+00" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+00" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+01" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .AddCut "lateral", "0", "1"  
     .AddCut "lateral", "90", "1"  
     .AddCut "polar", "90", "1"  

     .StoreSettings
End With

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:Dipole", "17", "13"

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:Dipole", "5", "5"

''@ define discrete face port: 2
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'With DiscreteFacePort 
'     .Reset 
'     .PortNumber "2" 
'     .Type "SParameter"
'     .Label ""
'     .Folder ""
'     .Impedance "50.0"
'     .VoltagePortImpedance "0.0"
'     .VoltageAmplitude "1.0"
'     .CurrentAmplitude "1.0"
'     .Monitor "True"
'     .CenterEdge "True"
'     .SetP1 "True", "-0.3810906533653", "51.923601521022", "0"
'     .SetP2 "True", "0.418901381277", "51.923310243404", "-1.1102230246252e-16"
'     .LocalCoordinates "False"
'     .InvertDirection "False"
'     .UseProjection "False"
'     .ReverseProjection "False"
'     .FaceType "Linear"
'     .Create 
'End With
'
''@ change material: component1:Incaps_bottom to: Silicon
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.ChangeMaterial "component1:Incaps_bottom", "Silicon"
'
''@ set shape accuracy
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.ShapeVisualizationAccuracy2 "120" 
'Solid.ShapeVisualizationOffset "0" 
'Pick.ClearAllPicks
'
''@ delete shape: component1:Incaps_bottom
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Delete "component1:Incaps_bottom"
'
''@ delete shape: component1:Incaps
'
''[VERSION]2021.1|30.0.1|20201110[/VERSION]
'Solid.Delete "component1:Incaps"
'
'@ align wcs with edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.AlignWCSWithSelected "EdgeCenter"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:Kapton", "5" 
WCS.AlignWCSWithSelected "Face"

'@ define ecylinder: component1:incaps_bottom

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With ECylinder 
     .Reset 
     .Name "incaps_bottom" 
     .Component "component1" 
     .Material "Silicon" 
     .Xradius "rmax_incapsbot" 
     .Yradius "rmin_incapsbot" 
     .Axis "z" 
     .Zrange "-1-0.125", "-0.125" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ bend: selected sheets, component1:Bladder

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Bending 
	.Reset 
	.Version "10" 
	.Sheet "component1:incaps_bottom" 
	.Solid "component1:Bladder" 
	.Faces "2" 
	.Bend 
End With

'@ set shape accuracy

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ShapeVisualizationAccuracy2 "30" 
Solid.ShapeVisualizationOffset "0" 
Pick.ClearAllPicks

'@ bend: selected sheets, component1:incaps_bottom

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Bending 
	.Reset 
	.Version "10" 
	.Sheet "component1:Kapton" 
	.Solid "component1:incaps_bottom" 
	.Faces "1" 
	.Bend 
End With

'@ bend: selected sheets, component1:Kapton

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Bending 
	.Reset 
	.Version "10" 
	.Sheet "component1:Dipole" 
	.Solid "component1:Kapton" 
	.Faces "1" 
	.Bend 
End With

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ activate local coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "local"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:Kapton", "1" 
WCS.AlignWCSWithSelected "Face"

'@ define ecylinder: component1:incaps

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With ECylinder 
     .Reset 
     .Name "incaps" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xradius "rmax_incapsbot+0.2" 
     .Yradius "rmin_incapsbot+0.2" 
     .Axis "z" 
     .Zrange "-0.125+2", "h_impl+2" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Segments "0" 
     .Create 
End With

'@ bend: selected sheets, component1:incaps_bottom

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Bending 
	.Reset 
	.Version "10" 
	.Sheet "component1:incaps" 
	.Solid "component1:incaps_bottom" 
	.Faces "1" 
	.Bend 
End With

'@ boolean insert shapes: component1:incaps, component1:Bladder

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:incaps", "component1:Bladder"

'@ boolean insert shapes: component1:incaps, component1:Dipole

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:incaps", "component1:Dipole"

'@ boolean insert shapes: component1:incaps, component1:Kapton

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:incaps", "component1:Kapton"

'@ boolean insert shapes: component1:Muscle, component1:Dipole

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Muscle", "component1:Dipole"

'@ boolean insert shapes: component1:Muscle, component1:Kapton

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Muscle", "component1:Kapton"

'@ boolean insert shapes: component1:Muscle, component1:incaps_bottom

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Muscle", "component1:incaps_bottom"

'@ boolean insert shapes: component1:Muscle, component1:incaps

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Muscle", "component1:incaps"

'@ boolean insert shapes: component1:Fat, component1:Dipole

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Fat", "component1:Dipole"

'@ boolean insert shapes: component1:Fat, component1:Kapton

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Fat", "component1:Kapton"

'@ boolean insert shapes: component1:Fat, component1:incaps_bottom

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Fat", "component1:incaps_bottom"

'@ boolean insert shapes: component1:Fat, component1:incaps

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Insert "component1:Fat", "component1:incaps"

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:Dipole", "9" 
WCS.AlignWCSWithSelected "Face"

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component1:Dipole", "9"

'@ define discrete port: 2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "2" 
     .Type "SParameter"
     .Label ""
     .Folder ""
     .Impedance "50.0"
     .VoltagePortImpedance "0.0"
     .Voltage "1.0"
     .Current "1.0"
     .Monitor "True"
     .Radius "0.0"
     .SetP1 "False", "0.0", "0.0", "0.0"
     .SetP2 "False", "0.0", "0", "1"
     .InvertDirection "False"
     .LocalCoordinates "True"
     .Wire ""
     .Position "end1"
     .Create 
End With

'@ delete port: port2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Port.Delete "2"

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:Dipole", "13", "10"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "0"
    .SetOrientation "Smart Mode"
    .SetDistance "0.799746"
    .SetViewVector "0.463009", "-0.782486", "-0.416338"
    .SetConnectedElement1 "component1:Dipole"
    .SetConnectedElement2 "component1:Dipole"
    .Create
End With

Pick.ClearAllPicks

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component1:Dipole", "9"

'@ define discrete port: 2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "2" 
     .Type "SParameter"
     .Label ""
     .Folder ""
     .Impedance "50.0"
     .VoltagePortImpedance "0.0"
     .Voltage "1.0"
     .Current "1.0"
     .Monitor "True"
     .Radius "0.0"
     .SetP1 "False", "0.0", "0.0", "0.0"
     .SetP2 "False", "0.0", "0.0", "1.50"
     .InvertDirection "False"
     .LocalCoordinates "True"
     .Wire ""
     .Position "end1"
     .Create 
End With

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ delete port: port2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Port.Delete "2"

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ align wcs with face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ForceNextPick 
Pick.PickFaceFromId "component1:Dipole", "9" 
WCS.AlignWCSWithSelected "Face"

'@ pick face

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickFaceFromId "component1:Dipole", "9"

'@ define discrete port: 2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "2" 
     .Type "SParameter"
     .Label ""
     .Folder ""
     .Impedance "50.0"
     .VoltagePortImpedance "0.0"
     .Voltage "1.0"
     .Current "1.0"
     .Monitor "True"
     .Radius "0.0"
     .SetP1 "False", "0.0", "0.0", "0.0"
     .SetP2 "False", "0.0", "0.0", "1"
     .InvertDirection "False"
     .LocalCoordinates "True"
     .Wire ""
     .Position "end1"
     .Create 
End With

'@ delete port: port2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Port.Delete "2"

'@ clear picks

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.ClearAllPicks

'@ pick mid point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickMidpointFromId "component1:Dipole", "13"

'@ pick mid point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickMidpointFromId "component1:Dipole", "1"

'@ define discrete port: 2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "2" 
     .Type "SParameter"
     .Label ""
     .Folder ""
     .Impedance "50.0"
     .VoltagePortImpedance "0.0"
     .Voltage "1.0"
     .Current "1.0"
     .Monitor "True"
     .Radius "0.0"
     .SetP1 "True", "0.019280107896954", "2.7071454005602e-13", "-1.1102230246252e-16"
     .SetP2 "True", "0.013195420772135", "2.7060351692621e-13", "0.80050123333525"
     .InvertDirection "False"
     .LocalCoordinates "True"
     .Wire ""
     .Position "end1"
     .Create 
End With

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:Dipole", "9", "1"

'@ transform port: translate port2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "port2" 
     .Vector "-0.0175", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Transform "Port", "Translate" 
End With

'@ activate global coordinates

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
WCS.ActivateWCS "global"

'@ switch bounding box

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Plot.DrawBox "False"

