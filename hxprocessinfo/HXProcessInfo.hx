package hxprocessinfo;

import cpp.SizeT;

@:include("memory.hpp")
@:include("cpu.hpp")
@:buildXml("<include name='${haxelib:hxprocessinfo}/build.xml' />")
extern class HXProcessInfo {
	@:native("hxprocessinfo::init")
	static function init():Void;

	@:native("hxprocessinfo::getSystemTotalCPUUsage")
	static function getSystemTotalCPUUsage():Float;

	@:native("hxprocessinfo::getSystemTotalPeakCPUUsage")
	static function getSystemTotalPeakCPUUsage():Float;

	@:native("hxprocessinfo::getProcessCPUUsage")
	static function getProcessCPUUsage():Float;

	@:native("hxprocessinfo::getProcessPeakCPUUsage")
	static function getProcessPeakCPUUsage():Float;

	@:native("hxprocessinfo::getSystemTotalVirtualMemory")
	static function getSystemTotalVirtualMemory():SizeT;

	@:native("hxprocessinfo::getSystemVirtualMemoryUsage")
	static function getSystemVirtualMemoryUsage():SizeT;

	@:native("hxprocessinfo::getSystemPeakVirtualMemoryUsage")
	static function getSystemPeakVirtualMemoryUsage():SizeT;

	@:native("hxprocessinfo::getProcessVirtualMemoryUsage")
	static function getProcessVirtualMemoryUsage():SizeT;

	@:native("hxprocessinfo::getProcessPhysicalMemoryUsage")
	static function getProcessPhysicalMemoryUsage():SizeT;

	@:native("hxprocessinfo::getProcessPeakVirtualMemoryUsage")
	static function getProcessPeakVirtualMemoryUsage():SizeT;

	@:native("hxprocessinfo::getProcessPeakPhysicalMemoryUsage")
	static function getProcessPeakPhysicalMemoryUsage():SizeT;

	@:native("hxprocessinfo::getSystemTotalPhysicalMemory")
	static function getSystemTotalPhysicalMemory():SizeT;

	@:native("hxprocessinfo::getSystemPhysicalMemoryUsage")
	static function getSystemPhysicalMemoryUsage():SizeT;

	@:native("hxprocessinfo::getSystemPeakPhysicalMemoryUsage")
	static function getSystemPeakPhysicalMemoryUsage():SizeT;
}
