import cpp.Int64;
import haxe.macro.Compiler;
import hxprocessinfo.HXProcessInfo;
import sys.thread.Thread;

class Main {
	static function main() {
		HXProcessInfo.init();
		var th:Thread = Thread.create(() -> {
			while (true) {
				var i:Int = 1223 * 1453;
			}
		});

		for (i in 0...1000) {
			Sys.sleep(0.1);

			var cpuUsage:Float = HXProcessInfo.getCpuUsage();
			var mem:cpp.SizeT = HXProcessInfo.getMemoryUsage();
			var memPeak:cpp.SizeT = HXProcessInfo.getMemoryPeak();

			trace('CPU: $cpuUsage% Memory: $mem bytes / $memPeak bytes (peak)');
		}
	}
}
