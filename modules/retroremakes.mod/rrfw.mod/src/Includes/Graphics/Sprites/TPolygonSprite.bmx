'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TPolygonSprite Extends TSprite

	Field vertices:Float[]
	
	Method Render(tweening:Double, fixed:int)
		Interpolate(tweening)
	End Method

End Type
