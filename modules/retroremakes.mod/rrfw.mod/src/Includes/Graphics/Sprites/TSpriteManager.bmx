Rem
bbdoc: #TSpriteManager
about: Manager class for handling sprites
endrem
Type TSpriteManager
	
	field updateProfile:TProfilerSample
	field renderProfile:TProfilerSample
	
	Field LSprites:TList
	Field hideAll:Int

	Method New()
		LSprites = New TList
		hideAll = False
		updateProfile = rrCreateProfilerSample("Sprite Manager: Update")
		renderProfile = rrCreateProfilerSample("Sprite Manager: Render")
	End Method
	
	rem
	bbdoc: Add a sprite to the manager
	endrem
	Method AddSprite(sprite:TSprite)
		LSprites.AddLast(sprite)
		SortList(LSprites, True, SpriteZOrderSort)
	End Method

	rem
	bbdoc: Remove a sprite from the manager
	endrem
	Method RemoveSprite(sprite:TSprite)
		sprite.Remove()
		RemoveLink(sprite.spriteListLink)
	End Method

	rem
	bbdoc: Remove all sprites from the manager
	endrem	
	Method PurgeSprites()
		For Local sprite:TSprite = EachIn LSprites
			sprite.remove()
		Next
		LSprites.Clear()
	End Method

	rem
	bbdoc: Hide/Unhide all sprites
	about: #True hides all sprites, #False unhides them
	endrem		
	Method HideSprites(hide:Int = True)
		hideAll = hide
	End Method

	rem
	bbdoc: Get the current hidden status
	returns: #True if sprites are hidden, #False if they are unhiddent
	endrem		
	Method GetHidden:Int()
		Return hideAll
	End Method

	rem
	bbdoc: Update positions and animations of all sprites
	about: Call this once per logic update frame to update all sprites
	endrem	
	Method Update()
		rrStartProfilerSample(updateProfile)
		For Local sprite:TSprite = EachIn LSprites
			'sprite.SetPreviousPosition(sprite.GetCurrentPosition().Copy())
			sprite.previousPosition_.x = sprite.currentPosition_.x
			sprite.previousPosition_.y = sprite.currentPosition_.y
			sprite.Update()
		Next
		rrStopProfilerSample(updateProfile)
	End Method

	rem
	bbdoc: Render all sprites to the screen
	about: Call this once per render frame to draw all sprites
	endrem		
	Method Render(fixed:Int = false)
		rrStartProfilerSample(renderProfile)
		If Not hideAll
			Local tweening:Double = TFixedTimestep.GetInstance().GetTweening()
			For Local sprite:TSprite = EachIn LSprites
				sprite.Render(tweening, fixed)
			Next
		End If
		rrStopProfilerSample(renderProfile)
	End Method
	
		
End Type

Function rrCreateSpriteManager:TSpriteManager()
	Return New TSpriteManager
End Function

Function rrAddSprite(manager:TSpriteManager, sprite:TSprite)
	manager.AddSprite(sprite)
End Function

Function SpriteZOrderSort:Int(o1:Object, o2:Object)
	Local o1ZDepth:Int = TSprite(o1).GetZDepth()
	Local o2ZDepth:Int = TSprite(o2).GetZDepth()
	If o1ZDepth < o2ZDepth
		Return - 1
	ElseIf o1ZDepth > o2ZDepth
		Return 1
	Else
		Return 0
	EndIf
End Function