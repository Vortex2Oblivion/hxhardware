package hxhardware;

import cpp.SizeT;

/**
 * Get information about the CPU.
 */
@:include("cpu.hpp")
@:buildXml("<include name='${haxelib:hxhardware}/build.xml' />")
extern class CPU {
	/**
	 * Should be called before attempting to get any values.
	 */
	@:native("hxhardware::init")
	static function init():Void;

	/**
	 * Gets the total CPU usage of the system.
	 * @return The usage (as a %).
	 */
	@:native("hxhardware::getSystemTotalCPUUsage")
	static function getSystemTotalCPUUsage():Float;

	/**
	 * Gets the peak CPU usage of the system.
	 * @return The usage (as a %).
	 */
	@:native("hxhardware::getSystemTotalPeakCPUUsage")
	static function getSystemTotalPeakCPUUsage():Float;

	/**
	 * Gets the current CPU usage of the current process.
	 * @return The usage (as a %).
	 */
	@:native("hxhardware::getProcessCPUUsage")
	static function getProcessCPUUsage():Float;

	/**
	 * Gets the peak CPU usage of the current process.
	 * @return The usage (as a %).
	 */
	@:native("hxhardware::getProcessPeakCPUUsage")
	static function getProcessPeakCPUUsage():Float;
}
