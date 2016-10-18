###############################################################################
# $ID: Config.p, 23 Aug 2016 15:16, Leonid 'n3o' Knyazev $
###############################################################################
@CLASS
als/config/Config


@OPTIONS
locals



###############################################################################
@create[params]
# @{hash} [params]
$self.params[^hash::create[
	$.root[]
]]

^self._configure[$params]

# @{object} [configs] Configs storage.
$self.configs[^als/config/Cache::create[]]

# @{object} [reader]
$self.reader[^als/config/Reader::create[]]

# process autoload
^if(def $self.params.configs){
	^self.read[$self.params.configs]
}
#end @create[]



###############################################################################
# @PUBLIC
###############################################################################
@get[name;default]
$result[^self.configs.get[$name]]

^if(!def $result && def $default){
	$result[$default]
}
#end @get[]


###############################################################################
@set[name;data]
$result[^self.configs.set[$name;$data]]
#end @set[]


###############################################################################
@read[name;path]
^if($name is hash){
	^name.foreach[_name;_path]{
		^self.read[$_name;$_path]
	}
}($name is string){
	^if(!def $path){
		$path[$name]
	}

	$path[^self._parsePath[$path]]
	$name[^self._parseName[$name]]

	$data[^self.reader.read[$path]]

	^if(def $data){
		^self.configs.set[$name;$data]
	}
}{
	^throw[invalid.argument;$self.CLASS_NAME;Invalid argument '^$name' format: $name.CLASS_NAME]
}
#end @read[]


###############################################################################
@parse[]
^throw[not.implemented;$self.CLASS_NAME;Method 'parse' not implemented yet.]
#end @parse[]


###############################################################################
@save[]
^throw[not.implemented;$self.CLASS_NAME;Method 'save' not implemented yet.]
#end @save[]



###############################################################################
# @PRIVATE
###############################################################################
@_configure[params]
^self.params.add[^hash::create[$params]]
#end @_configure[]


###############################################################################
@_parsePath[path]
$result[$path]

^if(def $self.params.root){
	$root[^self.params.root.trim[right;/]]

	^if($result eq "."){
		$result[]
	}

	^if($root ne "."){
		$result[^result.trim[left;/]]
	}

	$result[${root}/${result}]
	$result[^result.trim[right;/]]
}
#end @_parsePath[]


###############################################################################
@_parseName[name]
$result[^file:justname[$name]]
#end @_parseName[]


###############################################################################
@_parseType[path]
$result[^file:justext[$path]]
#end @_parseType[]



###############################################################################
# @DEFAULTS
###############################################################################
@GET_DEFAULT[name]
$result[^self.get[$name]]
#end @GET_DEFAULT[]


###############################################################################
@SET_DEFAULT[name;data]
^self.set[$name;$data]
#end @SET_GET_DEFAULT[]
