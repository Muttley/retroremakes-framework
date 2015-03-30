# Introduction #

TimeLineFX (http://www.rigzsoft.co.uk/) is an awesome particle and effects editor. The exported libraries can be used with the timelinefx module, also available on that web site.  This page explains how to use the module in a basic RRFW setup.

# Implementation Details #

  * Ensure that the RRFW engine and the particlemanager use the same update frequency
  * If you want to control the order in which particles are drawn, you can create a particle manager layer for each screen you use, and render the particle layer in the screen render call.
  * TimeLineFX has its own render tweening, but we do not use it. Tweening from RRFW is used in the screen `Render()` call.
  * Use `CopyCompiledEffect()` instead of `CopyEffect()` for a slight speed boost.
  * The tlEffect type contains manipulation methods, like `SetX()` which is used here.  Turn, rotate and scale etc. are provided to change the effect according to game objects turning and moving.

# Example Code #

What follows is an example. The example uses a library which can be downloaded for free from the TimeLineFX website.

```
SuperStrict

'import the necesarry modules
Framework retroremakes.rrfw
Import rigz.timelinefx

'init the RRFW engine
rrEngineInitialise()
rrUseExeDirectoryForData()
TGameEngine.GetInstance().SetGameManager(New MyGameManager)

'set RRFW update frequency
rrSetUpdateFrequency(60.0)

'create a manager
Global MyParticleManager:tlParticleManager = CreateParticleManager(5000)

'set particle manager update frequency
SetUpdateFrequency(60.0)

'load an effects library
Global MyEffectsLibrary:tlEffectsLibrary = LoadEffects("ShootEmUpEffects.eff")

'the effect we want to use is retrieved from the effects library
Global theEffect:tlEffect = MyEffectsLibrary.GetEffect("Thrusters 2")
If theEffect = Null Then DebugStop

rrEngineRun()


Type MyGameManager Extends TGameManager
	
	Method Start()
		
		'add our screen to the layer manager. This screen will update and render the particles
		TLayerManager.GetInstance().AddRenderableToLayerByName(New MyScreen, "layer")

		'sync manager screensize to physical screen size
		MyParticleManager.SetScreenSize(rrGetGraphicsWidth(), rrGetGraphicsHeight())
		
		'use screen coordinates
		MyParticleManager.SetOrigin(rrGetGraphicsWidth() / 2, rrGetGraphicsHeight() / 2)
	End Method

	
	Method Stop()
		'clean up before quitting
		TMessageService.GetInstance().UnsubscribeAllChannels(Self)
		MyParticleManager.ClearAll()
	End Method
	

	Method Update()
	End Method
	

	Method MessageListener(message:TMessage)
	End Method
	
	
	'empty. we let the screen render, not this game manager.
	Method Render(tweening:Double, fixed:Int = False)
	End Method
	
End Type



'this screen is updated when not in pause mode, and always rendered
Type MyScreen Extends TActor

	Method Start()
	End Method
		
	
	Method Stop()
		'clean up before exit
		TLayerManager.GetInstance().RemoveRenderable(Self)
	End Method
	
	
	Method Update()

		'update the effects already in the manager
		MyParticleManager.Update()
		
		'click to generate the effect
		If MouseHit(1)
			Local tempeffect:tlEffect = CopyCompiledEffect(theEffect, MyParticleManager)

			'Set the temp effect to the mouse coords
    			tempeffect.setx(MouseX())
			tempeffect.sety(MouseY())

			'add the effect the the particle manager. Important, otherwise the particle manager would have nothing to update
			MyParticleManager.addeffect(tempeffect)
		End If
	End Method

	
	'draw the screen
	Method Render(tweening:Double, fixed:Int)
		MyParticleManager.DrawParticles(tweening)
		
		SetColor 255, 255, 255
		
		'show some particle engine information
		DrawText("Particles: " + MyParticleManager.GetParticlesInUse(), 0, 0)
	End Method

End Type
```