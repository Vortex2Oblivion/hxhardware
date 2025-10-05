import cpp.SizeT;
import sys.thread.Thread;
import hxhardware.*;

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
		CPU.init();
		var th:Thread = Thread.create(() -> {
			while (true) {
				var i:Int = 1223 * 1453;
			}
		});

		for (i in 0...1000) {
			Sys.sleep(1);

			var cpuUsageProcess:Float = CPU.getProcessCPUUsage();
			var cpuPeakProcess:Float = CPU.getProcessPeakCPUUsage();

			var cpuUsageSystem:Float = CPU.getSystemTotalCPUUsage();
			var cpuPeakSystem:Float = CPU.getSystemTotalPeakCPUUsage();

			var physicalMemoryUsage:SizeT = Memory.getProcessPhysicalMemoryUsage();
			var physicalMemoryPeak:SizeT = Memory.getProcessPeakPhysicalMemoryUsage();

			var virtualMemoryUsage:SizeT = Memory.getProcessVirtualMemoryUsage();
			var virtualMemoryPeak:SizeT = Memory.getProcessPeakVirtualMemoryUsage();

			var physicalMemoryUsageSystem:SizeT = Memory.getSystemPhysicalMemoryUsage();
			var physicalMemoryPeakSystem:SizeT = Memory.getSystemPeakPhysicalMemoryUsage();

			var virtualMemoryUsageSystem:SizeT = Memory.getSystemVirtualMemoryUsage();
			var virtualMemoryPeakSystem:SizeT = Memory.getSystemPeakVirtualMemoryUsage();

			var physicalMemoryAvaliable:SizeT = Memory.getSystemTotalPhysicalMemory();
			var virtualMemoryAvaliable:SizeT = Memory.getSystemTotalVirtualMemory();

			if (Sys.systemName() == "Windows")
				Sys.command("cls");
			else
				Sys.command("clear");

			Sys.println(GPU.getSystemTotalGPUUsage());
			Sys.println(GPU.getSystemTotalPeakGPUUsage());

			Sys.println("------------------------------------------PROCESS------------------------------------------");
			Sys.println('CPU: ${roundDecimal(cpuUsageProcess, 2)}% / ${roundDecimal(cpuPeakProcess, 2)}% (peak) | Physical Memory: ${formatBytes(physicalMemoryUsage)} / ${formatBytes(physicalMemoryPeak)} (peak) | Virutal Memory: ${formatBytes(virtualMemoryUsage)} / ${formatBytes(virtualMemoryPeak)} (peak)');
			Sys.println("------------------------------------------SYSTEM-------------------------------------------");
			Sys.println('CPU: ${roundDecimal(cpuUsageSystem, 2)}% / ${roundDecimal(cpuPeakSystem, 2)}% (peak) | Physical Memory: ${formatBytes(physicalMemoryUsageSystem)} / ${formatBytes(physicalMemoryPeakSystem)} (peak) | Virutal Memory: ${formatBytes(virtualMemoryUsageSystem)} / ${formatBytes(virtualMemoryPeakSystem)} (peak)');
			Sys.println("-----------------------------------------AVALIABLE------------------------------------------");
			Sys.println('Physical Memory: ${formatBytes(physicalMemoryAvaliable)} | Virutal Memory: ${formatBytes(virtualMemoryAvaliable)}');
		}
	}
}
