package hxhardware;

import cpp.SizeT;

@:include("memory.hpp")
@:buildXml("<include name='${haxelib:hxhardware}/build.xml' />")
extern class Memory {
	@:native("hxhardware::getSystemTotalVirtualMemory")
	static function getSystemTotalVirtualMemory():SizeT;

	@:native("hxhardware::getSystemVirtualMemoryUsage")
	static function getSystemVirtualMemoryUsage():SizeT;

	@:native("hxhardware::getSystemPeakVirtualMemoryUsage")
	static function getSystemPeakVirtualMemoryUsage():SizeT;

	@:native("hxhardware::getProcessVirtualMemoryUsage")
	static function getProcessVirtualMemoryUsage():SizeT;

	@:native("hxhardware::getProcessPhysicalMemoryUsage")
	static function getProcessPhysicalMemoryUsage():SizeT;

	@:native("hxhardware::getProcessPeakVirtualMemoryUsage")
	static function getProcessPeakVirtualMemoryUsage():SizeT;

	@:native("hxhardware::getProcessPeakPhysicalMemoryUsage")
	static function getProcessPeakPhysicalMemoryUsage():SizeT;

	@:native("hxhardware::getSystemTotalPhysicalMemory")
	static function getSystemTotalPhysicalMemory():SizeT;

	@:native("hxhardware::getSystemPhysicalMemoryUsage")
	static function getSystemPhysicalMemoryUsage():SizeT;

	@:native("hxhardware::getSystemPeakPhysicalMemoryUsage")
	static function getSystemPeakPhysicalMemoryUsage():SizeT;
}
