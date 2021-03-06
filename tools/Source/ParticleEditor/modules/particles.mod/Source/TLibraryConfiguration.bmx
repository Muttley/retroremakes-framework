Rem
'
' Copyright (c) 2007-2010 Wiebo de Wit <wiebo.de.wit@gmail.com>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
endrem

rem
bbdoc: particle library configuration handler
endrem
Type TLibraryConfiguration

	'last loaded configuration filename
	Field configurationName:String
	
	'tmap containing the loaded configuration
	Field library:TMap
	
	'type containing the 'world' settings (gravity, updatefreq, etc)
	'Field world:TParticleWorldSettings
	
	'id to use when adding a new object to the library
	Field nextID:Int
	
	
	
	rem
	bbdoc: Returns the TMap containing the library configuration
	endrem
	Method GetLibrary:TMap()
		If Not library Then Throw("No configuration loaded!")
		Return library
	End Method
	
	
	
	rem
	bbdoc: Adds particle world settings to the library
	about: These settings are stored with the id "world"
	endrem
	Method AddWorld(settings:String)
	
	End Method


	
	rem
	bbdoc: Adds an image to the library
	about: a blank TParticleImage is added if no settings are specified
	returns: the new TParticleImage
	endrem
	Method AddImage:TParticleImage(settings:String[] = Null)
		Local i:TParticleImage = New TParticleImage
		If settings Then i.ImportSettings(settings)
		StoreObject(i, i.GetID())
		Return i
	End Method
	
	
	
	rem
	bbdoc: Adds a particle to the library
	about: a blank TParticle is added if no settings are specified
	returns: the new TParticle
	endrem
	Method AddParticle:TParticle(settings:String[] = Null)
		Local p:TParticle = New TParticle
		If settings Then p.ImportSettings(settings)
		StoreObject(p, p.GetID())
		Return p
	End Method
	
	
	
	rem
	bbdoc: Stores an object in the library
	endrem
	Method StoreObject(o:Object, id:String)
	
		If id = ""
			id = String(nextID)
			TParticleActor(o).SetID(id)
		EndIf
		
		library.Insert(id, o)
		
		'advance id counter if needed
		If Int(id) >= nextID Then nextID = Int(id) + 1
		
	End Method
	
	
	
	rem
	bbdoc: Returns an object from the library, using the passed ID
	endrem
	Method GetObject:Object(id:String)
		Local o:Object = library.ValueForKey(id)
		If o = Null Then Throw "Cannot find object with id : " + id
		Return o
	End Method
	
	
	
	rem
	bbdoc: Loads library configuration file and adds objects to the library
	endrem
	Method ReadConfiguration:Int(filename:String)
	
		Local fileHandle:TStream = ReadFile(filename)
		If Not fileHandle Then Return False
		
		If Not library
			library = New TMap
		Else
			library.Clear()
		EndIf
		
		While Not Eof(fileHandle)
			Local line:String = Trim(ReadLine(fileHandle))
			
			'ignore blank lines and comments
			If line = "" Then Continue
			If line[0] = "#" Then Continue
			
			Local settings:String[] = line.Split(",")
			Select settings[0]
				Case "image"
					AddImage(settings)
				Case "particle"
					AddParticle(settings)
			End Select
			
		Wend
				
		CloseFile(fileHandle)
		configurationName = filename
		
		'do post process
		
		Return True
	End Method		

End Type