import cpp.Int64;
import haxe.macro.Compiler;
import hxprocessinfo.HXProcessInfo;
import sys.thread.Thread;

class Main {
	static function roundDecimal(Value:Float, Precision:Int):Float {
		var mult:Float = 1;
		for (i in 0...Precision) {
			mult *= 10;
		}
		return Math.fround(Value * mult) / mult;
	}

	static function formatBytes(Bytes:Float, Precision:Int = 2):String {
		var units:Array<String> = ["Bytes", "kB", "MB", "GB", "TB", "PB"];
		var curUnit = 0;
		while (Bytes >= 1024 && curUnit < units.length - 1) {
			Bytes /= 1024;
			curUnit++;
		}
		return roundDecimal(Bytes, Precision) + units[curUnit];
	}

	static function main() {
		HXProcessInfo.init();
		var th:Thread = Thread.create(() -> {
			while (true) {
				var i:Int = 1223 * 1453;
			}
		});

		for (i in 0...1000) {
			Sys.sleep(1);

			var cpuUsageProcess:Float = HXProcessInfo.getProcessCPUUsage();
			var cpuUsageSystem:Float = HXProcessInfo.getSystemTotalCPUUsage();

			var physicalMemoryUsage:cpp.SizeT = HXProcessInfo.getProcessPhysicalMemoryUsage();
			var physicalMemoryPeak:cpp.SizeT = HXProcessInfo.getProcessPeakPhysicalMemoryUsage();

			var virtuallMemoryUsage:cpp.SizeT = HXProcessInfo.getProcessPhysicalMemoryUsage();

			var physicalMemoryUsageSystem:cpp.SizeT = HXProcessInfo.getSystemPhysicalMemoryUsage();
			var virtuallMemoryUsageSystem:cpp.SizeT = HXProcessInfo.getSystemVirtualMemoryUsage();

			var physicalMemoryAvaliable:cpp.SizeT = HXProcessInfo.getSystemTotalPhysicalMemory();
			var virtualMemoryAvaliable:cpp.SizeT = HXProcessInfo.getSystemTotalVirtualMemory();

			Sys.command("clear");
			Sys.println("------------------------------------------PROCESS------------------------------------------");
			Sys.println('CPU: ${roundDecimal(cpuUsageProcess, 2)}% | Physical Memory: ${formatBytes(physicalMemoryUsage)} | Virutal Memory: ${formatBytes(virtuallMemoryUsage)}');
			Sys.println("------------------------------------------SYSTEM-------------------------------------------");
			Sys.println('CPU: ${roundDecimal(cpuUsageSystem, 2)}% | Physical Memory: ${formatBytes(physicalMemoryUsageSystem)} | Virutal Memory: ${formatBytes(virtuallMemoryUsageSystem)}');
			Sys.println("-----------------------------------------AVALIABLE------------------------------------------");
			Sys.println('Physical Memory: ${formatBytes(physicalMemoryAvaliable)} | Virutal Memory: ${formatBytes(virtualMemoryAvaliable)}');
		}
	}
}
