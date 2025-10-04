package hxhardware;

import cpp.SizeT;

@:include("cpu.hpp")
@:buildXml("<include name='${haxelib:hxhardware}/build.xml' />")
extern class CPU {
	@:native("hxhardware::init")
	static function init():Void;

	@:native("hxhardware::getSystemTotalCPUUsage")
	static function getSystemTotalCPUUsage():Float;

	@:native("hxhardware::getSystemTotalPeakCPUUsage")
	static function getSystemTotalPeakCPUUsage():Float;

	@:native("hxhardware::getProcessCPUUsage")
	static function getProcessCPUUsage():Float;

	@:native("hxhardware::getProcessPeakCPUUsage")
	static function getProcessPeakCPUUsage():Float;
}
