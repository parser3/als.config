###############################################################################
# $ID: index.p, 9 Sep 2016 18:31, Leonid 'n3o' Knyazev $
###############################################################################
###############################################################################
@main[]
$config[^als/config/Config::create[]]

^config.read[cfg1;./configs/test.ini]
^config.read[cfg2;./configs/test.xml]
^config.read[cfg3;./configs/test.json]
#end @main[]