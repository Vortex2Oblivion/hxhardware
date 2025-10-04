package hxprocessinfo;

import cpp.SizeT;

@:include("hxprocessinfo.hpp")
@:buildXml("<include name='${haxelib:hxprocessinfo}/build.xml' />")
extern class HXProcessInfo {

	@:native("hxprocessinfo::init")
	static function init():Void;

	@:native("hxprocessinfo::getCpuUsage")
	static function getCpuUsage():Float;

	@:native("hxprocessinfo::getCurrentRSS")
	static function getMemoryUsage():SizeT;

	@:native("hxprocessinfo::getPeakRSS")
	static function getMemoryPeak():SizeT;
}
