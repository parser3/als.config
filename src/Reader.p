###############################################################################
# $ID: Reader.p, 9 Sep 2016 16:44, Leonid 'n3o' Knyazev $
###############################################################################
@CLASS
als/config/Reader


@OPTIONS
locals



###############################################################################
@create[]
# @{hash} [readers]
$self.readers[^hash::create[
	$.ini[als/config/reader/Ini]
	$.xml[als/config/reader/Xml]
	$.json[als/config/reader/Json]
]]

# @{object} [cache]
$self.cache[^als/config/Cache::create[
	$.mode[flat]
]]
#end @create[]



###############################################################################
# @PUBLIC
###############################################################################
@read[path]
$type[^self._parseType[$path]]

^if(!^self.readers.contains[$type]){
	^throw[invalid.type;$self.CLASS_NAME;'${path}' - invalid file type '$type'. (supported: ^self.readers.foreach[_type;]{$_type}[, ])]
}

$name[^self._parseName[$path]]
$path[^self._parsePath[$path]]

$path[${path}/${name}.${type}]

^if(^self.cache.has[$path]){
	$data[^self.cache.get[$path]]
}{
	^if(-f "$path"){
		^if($self.readers.[$type] is string){
			$self.readers.[$type][^reflection:create[$self.readers.[$type];create]]
		}

		$data[^self.readers.[$type].read[$path]]
	}{
		^throw[not.found;$self.CLASS_NAME;${path} - file not found.]
	}

	^if(def $data){
		^self.cache.set[$path;$data]
	}
}

$result[^self.parse[$type;$data]]
#end @read[]


###############################################################################
@parse[type;data]
^if($self.readers.[$type] is string){
	$self.readers.[$type][^reflection:create[$self.readers.[$type];create]]
}

$result[^self.readers.[$type].parse[$data]]
#end @pase[]



###############################################################################
# @PRIVATE
###############################################################################
@_parseType[path]
$result[^file:justext[$path]]
#end @_parseType[]


###############################################################################
@_parseName[path]
$result[^file:justname[$path]]
#end @_parseName[]


###############################################################################
@_parsePath[path;root]
$result[^file:dirname[$path]]
#end @_parsePath[]
