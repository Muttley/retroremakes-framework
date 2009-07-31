Type TFixedTimestep Extends TGameService
	
	Const DEFAULT_LOGIC_UPDATE_FREQUENCY:Double = 60.0	'60 frames per second

	Global instance:TFixedTimestep
	
	Field updateFrequency:Double
		
	Field dt:Double	' Delta Time
	Field nowTime:Double
	Field newTime:Double
	Field accumulator:Double = 0.0
	Field tween:Double	'tweening value to be used for rendering offsets only
	

	
	Function Create:TFixedTimestep()
		Return TFixedTimestep.GetInstance()
	End Function
	
	
		
	Function GetInstance:TFixedTimestep()
		If Not instance
			Return New TFixedTimestep
		Else
			Return instance
		EndIf
	EndFunction

	
	
	Method Calculate()
		newTime = Millisecs()

		Local deltaTime:Double = newTime - nowTime
		nowTime = newTime
		
		accumulator:+deltaTime
	End Method
	
	

	Method CalculateTweening()
		tween = accumulator / dt
	End Method
	
	
	
	Method GetDeltaTime:Double()
		Return dt
	End Method
	
	
		
	Method GetFrequency:Double()
		Return updateFrequency
	End Method
	
	
			
	Method GetTweening:Double()
		Return tween
	End Method

	
				
	Method Initialise()
		SetName("Fixed Timestep Logic")
		Super.Initialise()
	End Method

	
	
	Method New()
		If instance Throw "Cannot create multiple instances of this Singleton Type"
		instance = Self
		Self.Initialise()
	EndMethod
		
	
	
	Method Reset()
		SetFrequency(rrGetDoubleVariable("LOGIC_UPDATE_FREQUENCY", DEFAULT_LOGIC_UPDATE_FREQUENCY, "Engine"))
		nowTime = rrMillisecs()
	End Method
	
	

	Method SetFrequency(freq:Double)
		updateFrequency = freq
		dt = 1000.0:Double / freq
	End Method
	
	
		
	Method Shutdown()
	End Method

	
				
	Method Start()
		Reset()
	End Method


	
	Method TimeStepNeeded:Int()
		If accumulator >= dt
			accumulator:-dt
			Return True
		Else
			Return False
		End If
	End Method
	
End Type



Function rrCalculateFixedTimestep()
	TFixedTimestep.GetInstance().Calculate()
End Function



Function rrCalculateRenderTweening()
	TFixedTimestep.GetInstance().CalculateTweening()
End Function



Function rrGetDeltaTime:Double()
	Return TFixedTimestep.GetInstance().GetDeltaTime()
End Function



Function rrGetUpdateFrequency:Double()
	Return TFixedTimestep.GetInstance().GetFrequency()
End Function



Function rrResetFixedTimestep()
	TFixedTimestep.GetInstance().Reset()
End Function



Function rrSetUpdateFrequency(freq:Double)
	rrSetDoubleVariable("LOGIC_UPDATE_FREQUENCY", freq, "Engine")
	TFixedTimestep.GetInstance().SetFrequency(freq)
End Function



Function rrStartFixedTimestep()
	TFixedTimestep.GetInstance().Start()
End Function



Function rrTimeStepNeeded:Int()
	Return TFixedTimestep.GetInstance().TimeStepNeeded()
End Function
