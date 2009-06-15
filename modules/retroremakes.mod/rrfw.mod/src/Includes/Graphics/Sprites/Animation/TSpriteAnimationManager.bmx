'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TSpriteAnimationManager
	Field sprite:TSprite	'The sprite that this animation manager is linked to
	Field animations:TList 'List of animations scheduled for this sprite
	Field finishedAnimations:TList
	
	field updateProfile:TProfilerSample
	
	Method New()
		animations = New TList
		finishedAnimations = new TList
	'	updateProfile = rrCreateProfilerSample("Sprite Anim Manager: Update")
	End Method
	
	Method SetSprite(sprite:TSprite)
		Self.sprite = sprite
	End Method
	
	Method AddAnimation(animation:TSpriteAnimation)
		Self.animations.AddLast(animation)
	End Method
	
	Method Update()
	'	rrStartProfilerSample(updateProfile)
		If Not sprite Then Throw "TSpriteAnimationManager has no TSprite attached"
		If animations.Count() > 0
			If TSpriteAnimation(animations.First()).Update(sprite)
				'Animation has finished so remove it
				finishedAnimations.AddLast(animations.RemoveFirst())
			EndIf
		End If
	'	rrStopProfilerSample(updateProfile)
	End Method
	
	
	
	Method remove()
		Local animation:TSpriteAnimation
		For animation = EachIn animations
			animation.remove()
			animations.remove(animation)
			animation = Null
		Next
		For animation = EachIn finishedAnimations
			animation.remove()
			finishedAnimations.remove(animation)
			animation = Null
		Next
		GCCollect()
	End Method
	
	
	
	Method Reset()
		'move the remaining animations to the finished list
		While animations.Count() > 0
			finishedAnimations.AddLast(animations.RemoveFirst())
		Wend
		animations.Clear()
		
		'repopulate animation list and reset all animations
		While finishedAnimations.Count() > 0
			animations.AddLast(finishedAnimations.RemoveFirst())
			TSpriteAnimation(animations.Last()).Reset()
		Wend
		finishedAnimations.Clear()
	End Method
	
End Type
