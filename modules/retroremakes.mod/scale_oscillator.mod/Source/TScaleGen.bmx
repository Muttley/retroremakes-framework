rem
'
' Copyright (c) 2007-2010 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

Type TScaleGen
	Field x:Float	'X speed
	Field y:Float	'Y speed
	Field x_lo:Int	'Lowest X setting
	Field y_lo:Int	'Lowest Y setting
	Field x_hi:Int	'Highest X setting
	Field y_hi:Int	'Highest Y setting
	
	Method New()
		'some defaults
		SetXSpeed(1.0)
		SetYSpeed(1.0)
		SetXLow(64)
		SetYLow(64)
		SetXHigh(192)
		SetYHigh(192)
	End Method
	
	Method GetXSpeed:Float()
		Return x
	End Method
	
	Method GetYSpeed:Float()
		Return y
	End Method

	Method GetXLow:Int()
		Return x_lo
	End Method

	Method GetYLow:Int()
		Return y_lo
	End Method

	Method GetXHigh:Int()
		Return x_hi
	End Method

	Method GetYHigh:Int()
		Return y_hi
	End Method

	Method SetXSpeed(speed:Float)
		x = speed
	End Method

	Method SetYSpeed(speed:Float)
		y = speed
	End Method

	Method SetXLow(low:Int)
		x_lo = CapValueToByte(low)
	End Method

	Method SetYLow(low:Int)
		y_lo = CapValueToByte(low)
	End Method

	Method SetXHigh(high:Int)
		x_hi = CapValueToByte(high)
	End Method

	Method SetYHigh(high:Int)
		y_hi = CapValueToByte(high)
	End Method	
			
EndType
