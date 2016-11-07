###############################################################################
# $ID: Xml.p, 9 Sep 2016 16:55, Leonid 'n3o' Knyazev $
###############################################################################
@CLASS
Als/Config/Reader/Xml


@OPTIONS
locals



###############################################################################
@create[]
#end @create[]



###############################################################################
# @PUBLIC
###############################################################################
@read[path]
$result[^xdoc::load[$path]]
#end @read[]


###############################################################################
@parse[data]
$result[^hash::create[]]

^if(def $data){
	^if(!($data is xdoc)){
		$data[^self._parse[$data]]
	}

	$result[^self._parseXML[$data.documentElement;^hash::create[]]]
}
#end @parse[]



###############################################################################
# @PRIVATE
###############################################################################
@_parse[data]
$result[^xdoc::create{$data}]
#end @_parse[]


###############################################################################
@_parseXML[node;cache]
$nodes[^node.select[*]]

^for[i](0;$nodes - 1){
	$item[$nodes.$i]

	^if($item.firstChild.nodeType == $xdoc:TEXT_NODE && !$item.firstChild.nextSibling){
		$value[^item.firstChild.nodeValue.trim[]]

		^switch[$value]{
			^case[true;false]{
				$value(^value.bool($value))
			}
		}
	}{
		$value[^self._parseXML[$item;^hash::create[]]]
	}

	^if(!def $value){
		$value[$VOID]
	}

	$cache.[$item.nodeName][$value]
}

$result[$cache]
#end @_parseXML[]
