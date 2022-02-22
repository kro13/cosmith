#rem doesn't work with lix
haxelib run lime build html5 -v -D react_global -D react_ver=16.3 -D react_ref_api -debug
winrar a -afzip bin\client\html5\bin_test.zip bin\client\html5\bin
butler push bin\client\html5\bin_test.zip kro13/cosmith:html5