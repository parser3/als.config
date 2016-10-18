###############################################################################
# $ID: Cache.p, 9 Sep 2016 15:31, Leonid 'n3o' Knyazev $
###############################################################################
@CLASS
als/config/Cache


@OPTIONS
locals



###############################################################################
@create[params]
# @{hash} [params]
$self.params[^hash::create[
	$.mode[tree]
	$.separator[.]
]]

^self.params.add[^hash::create[$params]]

# @{hash} [cache]
$self.cache[^hash::create[]]
#end @create[]



###############################################################################
# @PUBLIC
###############################################################################
@get[name]
$result[]

^switch[$self.params.mode]{
	^case[tree]{
		$result[$self.cache]
		$parts[^name.split[$self.params.separator;l]]

		^parts.menu{
			$key[$parts.piece]
			$part[^if(def $part){${part}.}$key]

			^if($result is hash && ^result.contains[$key]){
				^switch[$result.[$key].CLASS_NAME]{
					^case[int;double;bool]{
						$result($result.[$key])
					}
					^case[DEFAULT]{
						$result[$result.[$key]]
					}
				}
			}{
				^throw[not.found;$self.CLASS_NAME;Cache key '$key' not found.]
			}
		}
	}
	^case[DEFAULT]{
		^if(^self.cache.contains[$name]){
			$result[$self.cache.[$name]]
		}{
			^throw[not.found;$self.CLASS_NAME;Cache key '$name' not found.]
		}
	}
}
#end @get[]


###############################################################################
@set[name;data]
$result[]

^switch[$self.params.mode]{
	^case[tree]{
		$current[$self.cache]

		$parts[^name.split[$self.params.separator;l]]

		^parts.menu{
			$part[$parts.piece]

			^if(^current.contains[$part]){
				^if(^parts.line[] == $parts){
					^switch[$data.CLASS_NAME]{
						^case[int;double;bool]{
							$current.[$part]($data)
						}
						^case[DEFAULT]{
							$current.[$part][$data]
						}
					}
				}

				$current[$current.[$part]]
			}{
				^if(^parts.line[] < $parts){
					^current.add[
						$.[$part][^hash::create[]]
					]
				}{
					^switch[$data.CLASS_NAME]{
						^case[int;double;bool]{
							^current.add[
								$.[$part]($data)
							]
						}
						^case[DEFAULT]{
							^current.add[
								$.[$part][$data]
							]
						}
					}
				}

				$current[$current.[$part]]
			}
		}
	}
	^case[DEFAULT]{
		^self.cache.add[
			$.[$name][$data]
		]
	}
}
#end @set[]


###############################################################################
@has[name]
^switch[$self.params.mode]{
	^case[tree]{
		$result(false)

		$current[$self.cache]
		$parts[^name.split[$self.params.separator;l]]

		^parts.menu{
			$part[$parts.piece]

			^if($current is hash && ^current.contains[$part]){
				^if(^parts.line[] == $parts){
					$result(true)
				}

				$current[$current.[$part]]
			}{
				^break[]
			}
		}
	}
	^case[DEFAULT]{
		$result(^self.cache.contains[$name])
	}
}
#end @has[]
