Rem
'
' Copyright (c) 2007-2011 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
EndRem

SuperStrict

Rem
bbdoc: RetroRemakes Framework: Score Services
about: The score services allow you to manage player scores and high-score
tables, including reading/writing those tables to disk in both encrypted and
unencrypted forms.
EndRem
Module retroremakes.score

Import retroremakes.engine
Import retroremakes.maths
Import retroremakes.service

Include "Source/THighScoreEntry.bmx"
Include "Source/THighScoreTable.bmx"
Include "Source/TScore.bmx"
Include "Source/TScoreService.bmx"
