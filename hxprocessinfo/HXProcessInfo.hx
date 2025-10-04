package hxprocessinfo;

import cpp.SizeT;
import cpp.UInt64;

@:include("memory.hpp")
@:include("cpu.hpp")
@:buildXml("<include name='${haxelib:hxprocessinfo}/build.xml' />")
extern class HXProcessInfo {

	@:native("hxprocessinfo::init")
	static function init():Void;

	@:native("hxprocessinfo::getSystemTotalCPUUsage")
	static function getSystemTotalCPUUsage():Float;

	@:native("hxprocessinfo::getProcessCPUUsage")
	static function getProcessCPUUsage():Float;

	@:native("hxprocessinfo::getSystemTotalVirtualMemory")
	static function getSystemTotalVirtualMemory():UInt64;

	@:native("hxprocessinfo::getSystemVirtualMemoryUsage")
	static function getSystemVirtualMemoryUsage():UInt64;

	@:native("hxprocessinfo::getProcessVirtualMemoryUsage")
	static function getProcessVirtualMemoryUsage():UInt64;

	@:native("hxprocessinfo::getProcessPhysicalMemoryUsage")
	static function getProcessPhysicalMemoryUsage():SizeT;

	@:native("hxprocessinfo::getProcessPeakPhysicalMemoryUsage")
	static function getProcessPeakPhysicalMemoryUsage():SizeT;

	@:native("hxprocessinfo::getSystemTotalPhysicalMemory")
	static function getSystemTotalPhysicalMemory():UInt64;

	@:native("hxprocessinfo::getSystemPhysicalMemoryUsage")
	static function getSystemPhysicalMemoryUsage():UInt64;
}
