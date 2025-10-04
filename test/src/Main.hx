import cpp.SizeT;
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
			var cpuPeakProcess:Float = HXProcessInfo.getProcessPeakCPUUsage();

			var cpuUsageSystem:Float = HXProcessInfo.getSystemTotalCPUUsage();
			var cpuPeakSystem:Float = HXProcessInfo.getSystemTotalPeakCPUUsage();

			var physicalMemoryUsage:cpp.SizeT = HXProcessInfo.getProcessPhysicalMemoryUsage();
			var physicalMemoryPeak:cpp.SizeT = HXProcessInfo.getProcessPeakPhysicalMemoryUsage();

			var virtualMemoryUsage:cpp.SizeT = HXProcessInfo.getProcessVirtualMemoryUsage();
			var virtualMemoryPeak:cpp.SizeT = HXProcessInfo.getProcessPeakVirtualMemoryUsage();

			var physicalMemoryUsageSystem:cpp.SizeT = HXProcessInfo.getSystemPhysicalMemoryUsage();
			var physicalMemoryPeakSystem:cpp.SizeT = HXProcessInfo.getSystemPeakPhysicalMemoryUsage();

			var virtualMemoryUsageSystem:cpp.SizeT = HXProcessInfo.getSystemVirtualMemoryUsage();
			var virtualMemoryPeakSystem:cpp.SizeT = HXProcessInfo.getSystemPeakVirtualMemoryUsage();

			var physicalMemoryAvaliable:cpp.SizeT = HXProcessInfo.getSystemTotalPhysicalMemory();
			var virtualMemoryAvaliable:cpp.SizeT = HXProcessInfo.getSystemTotalVirtualMemory();

			if (Sys.systemName() == "Windows")
				Sys.command("cls");
			else
				Sys.command("clear");
			Sys.println("------------------------------------------PROCESS------------------------------------------");
			Sys.println('CPU: ${roundDecimal(cpuUsageProcess, 2)}% / ${roundDecimal(cpuPeakProcess, 2)}% (peak) | Physical Memory: ${formatBytes(physicalMemoryUsage)} / ${formatBytes(physicalMemoryPeak)} (peak) | Virutal Memory: ${formatBytes(virtualMemoryUsage)} / ${formatBytes(virtualMemoryPeak)} (peak)');
			Sys.println("------------------------------------------SYSTEM-------------------------------------------");
			Sys.println('CPU: ${roundDecimal(cpuUsageSystem, 2)}% / ${roundDecimal(cpuPeakSystem, 2)}% (peak) | Physical Memory: ${formatBytes(physicalMemoryUsageSystem)} / ${formatBytes(physicalMemoryPeakSystem)} (peak) | Virutal Memory: ${formatBytes(virtualMemoryUsageSystem)} / ${formatBytes(virtualMemoryPeakSystem)} (peak)');
			Sys.println("-----------------------------------------AVALIABLE------------------------------------------");
			Sys.println('Physical Memory: ${formatBytes(physicalMemoryAvaliable)} | Virutal Memory: ${formatBytes(virtualMemoryAvaliable)}');
		}
	}
}
