'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TVirtualControlMessageData Extends TMessageData

	field gamepadId:int
	
	field controlName:string
	
	field analogueStatus:Float
	field digitalStatus:int
	field hits:int
End Type
