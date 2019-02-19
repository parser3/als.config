###############################################################################
# $ID: Ini.p, 9 Sep 2016 16:53, Leonid 'n3o' Knyazev $
###############################################################################
@CLASS
Als/Config/Reader/Ini


@OPTIONS
locals



###############################################################################
@create[]
#end @create[]



###############################################################################
# @PUBLIC
###############################################################################
@read[path]
$result[^table::load[nameless;$path][
	$.separator[=]
]]
#end @read[]


###############################################################################
@parse[data]
$result[^hash::create[]]

^if(def $data){
	^if(!($data is table)){
		$data[^self._parse[$data]]
	}

	$sections[^Als/Config/Cache::create[]]

	^data.menu{
		$name[^data.0.trim[]]

		^if(^name.left(1) eq ";"){
			^continue[]
		}

		^if(^name.left(1) eq "["){
			$section[^name.trim[both;[]]]
			^sections.set[$section;^hash::create[]]
			^continue[]
		}

		$value[$data.1]

		$value[^value.split[^;;lh]]
		$value[$value.0]

		$value[^value.split[#;lh]]
		$value[$value.0]

		$value[^value.trim[]]

		^sections.set[^if(def $section){${section}.}$name;$value]
	}

	^if(^sections.cache.keys[]){
		$result[^hash::create[$sections.cache]]
	}
}
#end @parse[]



###############################################################################
# @PRIVATE
###############################################################################
@_parse[data]
$result[^table::create[nameless]{$data}][
	$.separator[=]
]
#end @_parse[]
