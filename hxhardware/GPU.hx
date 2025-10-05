package hxhardware;

/**
 * Get information about the GPU.
 */
@:include("gpu.hpp")
@:buildXml("<include name='${haxelib:hxhardware}/build.xml' />")
extern class GPU {
	/**
	 * Gets the total GPU usage of the system.
	 * @return The usage (as a %).
	 */
	@:native("hxhardware::getSystemTotalGPUUsage")
	static function getSystemTotalGPUUsage():Float;

	/**
	 * Gets the peak GPU usage of the system.
	 * @return The usage (as a %).
	 */
	@:native("hxhardware::getSystemTotalPeakGPUUsage")
	static function getSystemTotalPeakGPUUsage():Float;
}
