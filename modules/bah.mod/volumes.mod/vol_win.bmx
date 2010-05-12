' Copyright (c) 2007-2009 Bruce A Henderson
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
' 
SuperStrict

Import BRL.Bank
Import BRL.LinkedList
Import Pub.Win32
Import BRL.Map

Import "main.bmx"

Import "-lkernel32"
Import "-lshell32"

Extern "win32"
	Function GetDiskFreeSpaceEx:Int(lpDirectoryName:Short Ptr, lpFreeBytesAvailableToCaller:Long Var, lpTotalNumberOfBytes:Long Var, lpTotalNumberOfFreeBytes:Long Var) = "GetDiskFreeSpaceExW@16"
	Function GetVolumeInformation:Int(lpRootPathName:Short Ptr, lpVolumeNameBuffer:Short Ptr, nVolumeNameSize:Int, ..
		lpVolumeSerialNumber:Int Var, lpMaximumComponentLength:Int Var, lpFileSystemFlags:Int Var, lpFileSystemNameBuffer:Short Ptr, nFileSystemNameSize:Int) = "GetVolumeInformationW@32"
	Function GetLogicalDrives:Int() = "GetLogicalDrives@0"
	Function SetErrorMode:Int(mode:Int) = "SetErrorMode@4"

	' volumes
	Function FindFirstVolume:Int(volumeName:Short Ptr, bufferSize:Int) = "FindFirstVolumeW@8"
	Function FindNextVolume:Int(handle:Int, volumeName:Short Ptr, bufferSize:Int) = "FindNextVolumeW@12"
	Function FindVolumeClose:Int(handle:Int) = "FindVolumeClose@4"
	
	' volume paths
	Function GetVolumePathNamesForVolumeName:Int(volumeName:Short Ptr, volumePaths:Short Ptr, bufferSize:Int, copiedSize:Int Ptr) = "GetVolumePathNamesForVolumeNameW@16"
	
	Function SHGetFolderPath:Int(hwndOwner:Byte Ptr, nFolder:Int, hToken:Byte Ptr, dwFlags:Int, pszPath:Short Ptr) = "SHGetFolderPathW@20"
End Extern

Const CSIDL_APPDATA:Int = $001A
Const CSIDL_DESKTOPDIRECTORY:Int = $0010
Const CSIDL_PERSONAL:Int = $0005
Const CSIDL_PROFILE:Int = $0028
Const CSIDL_MYPICTURES:Int = $0027
Const CSIDL_MYMUSIC:Int = $000D
Const CSIDL_MYVIDEO:Int = $000E

Const SHGFP_TYPE_CURRENT:Int = 0

Const SEM_FAILCRITICALERRORS:Int = 1

Global winVolume_driver:TWinVolumeDriver = New TWinVolumeDriver

Type TWinVolumeDriver

	Method New()
		volume_driver = TWinVolume.Create()
	End Method

End Type


Type TWinVolume Extends TVolume

	Const PATH_MAX:Int = $104

	Field vs:TVolSpace

	Function Create:TWinVolume()
		Local this:TWinVolume = New TWinVolume
		
		Return this
	End Function

	Method ListVolumes:TList()
		Local volumes:TMap

		' create buffer
		Local nameBuffer:Short[] = New Short[PATH_MAX]
		Local mpBuffer:Short[] = New Short[PATH_MAX]
		
		' get the first volume
		Local handle:Int = FindFirstVolume(nameBuffer, PATH_MAX)
		If handle Then

			volumes = New TMap

			While True

				' retrieve the paths
				Local pathsBuffer:Short[] = New Short[PATH_MAX]
				Local bufferSize:Int
				
				Local paths:String[]

				If GetVolumePathNamesForVolumeName(nameBuffer, pathsBuffer, Self.PATH_MAX, Varptr bufferSize) Then

					paths = String.FromShorts(pathsBuffer, bufferSize).Trim().split("~0")

				' Some error occured – if the buffer was too small we will set it to the
				' right size and try it again
				Else If bufferSize > PATH_MAX Then

					If GetVolumePathNamesForVolumeName(nameBuffer, pathsBuffer, bufferSize, Varptr bufferSize) Then
						paths = String.FromShorts(pathsBuffer, bufferSize).Trim().split("~0")
					EndIf

				EndIf

				For Local path:String = EachIn paths
					volumes.Insert(path, GetVolumeInfo(path))
				Next

				' get the next volume or quit the loop if there is none
				If Not FindNextVolume(handle, nameBuffer, PATH_MAX) Then
					Exit
				End If
			Wend

			' end the volumes search
			FindVolumeClose(handle)

		End If


		' now look for missing drives...
		Local bitmap:Int = GetLogicalDrives()
		
		For Local i:Int = 1 To 26
			If bitmap & 1 Then

				If Not volumes Then
					volumes = New TMap
				End If
				
				Local path:String = Chr(64 + i) + ":\"
				
				If Not volumes.Contains(path) Then
					volumes.Insert(path, GetVolumeInfo(path))
				End If
				
			End If
			
			bitmap:Shr 1
		Next
		
		' return a list of volumes
		If volumes Then
			Local list:TList = New TList
			For Local volume:TVolume = EachIn volumes.Values()
				list.AddLast(volume)
			Next
			
			Return list
		Else
			Return Null
		End If

	End Method
	
	Method GetVolumeFreeSpace:Long(vol:String)

		Local _vs:TVolSpace = TVolSpace.GetDiskSpace(vol)
		
		Return _vs.fb
	End Method

	Method GetVolumeSize:Long(vol:String)

		Local _vs:TVolSpace = TVolSpace.GetDiskSpace(vol)
		
		Return _vs.tb
	End Method
	
	Method GetVolumeInfo:TVolume(vol:String)
		Local mode:Int = SetErrorMode(SEM_FAILCRITICALERRORS)

		Local volume:TWinVolume = New TWinVolume
		
		volume.volumeDevice = vol

		Local volname:Short[PATH_MAX]
		Local filesys:Short[PATH_MAX]
		Local snum:Int
		Local maxLength:Int
		Local flags:Int

		Local ret:Int = GetVolumeInformation(volume.volumeDevice, volname, PATH_MAX, ..
			snum, maxLength, flags, filesys, PATH_MAX)

		If ret Then
			volume.volumeName = String.fromWString(volname)
			volume.volumeType = String.fromWString(filesys)
			
			volume.vs = TVolSpace.GetDiskSpace(volume.volumeDevice)
			volume.volumeSize = volume.vs.tb
			volume.volumeFree = volume.vs.fb
			
			volume.available = True
		End If
		
		SetErrorMode(mode)
				
		Return volume
	End Method

	Method Refresh()
		If Not vs Then
			Return
		End If
		
		Local ret:Int = vs.refresh()
		
		If ret Then
			volumeSize = vs.tb
			volumeFree = vs.fb
			
			available = True
		Else
			available = False
		End If
		
	End Method

	Method GetUserHomeDir:String()
		Return _getFolderPath(CSIDL_PROFILE)
	End Method
	
	Method GetUserDesktopDir:String()
		Return _getFolderPath(CSIDL_DESKTOPDIRECTORY)
	End Method
	
	Method GetUserAppDir:String()
		Return _getFolderPath(CSIDL_APPDATA)
	End Method
	
	Method GetUserDocumentsDir:String()
		Return _getFolderPath(CSIDL_PERSONAL)
	End Method

	Method GetCustomDir:String(dirType:Int)
		Select dirType
			Case DT_USERPICTURES
				Return _getFolderPath(CSIDL_MYPICTURES)
			Case DT_USERMUSIC
				Return _getFolderPath(CSIDL_MYMUSIC)
			Case DT_USERMOVIES
				Return _getFolderPath(CSIDL_MYVIDEO)
		End Select
		
		Return Null
	End Method
	
	Method _getFolderPath:String(kind:Int)
		Local b:Short[] = New Short[MAX_PATH]
		
		Local ret:Int = SHGetFolderPath(Null, kind, Null, SHGFP_TYPE_CURRENT, b)
		
		Return String.fromWString(b)
	End Method
	
End Type

Type TVolSpace
	Field vol:String
	
	Field fbc:Long
	Field tb:Long
	Field fb:Long
	
	Function GetDiskSpace:TVolSpace(vol:String)
		Local this:TVolSpace = New TVolSpace
		
		Local dir:Short Ptr = vol.toWString()

		Local ret:Int = GetDiskFreeSpaceEx(dir, this.fbc, this.tb, this.fb)
		
		If dir Then
			MemFree(dir)
		End If
		
		Return this
	End Function
	
	Method refresh:Int()
		Local mode:Int = SetErrorMode(SEM_FAILCRITICALERRORS)
		
		Local dir:Short Ptr = vol.toWString()

		Local ret:Int = GetDiskFreeSpaceEx(dir, fbc, tb, fb)
		
		If dir Then
			MemFree(dir)
		End If
		
		SetErrorMode(mode)
		Return ret
	End Method

End Type
