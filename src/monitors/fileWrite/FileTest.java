package monitors.fileWrite;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import callGraphTrace.TraceData;

public class FileTest {

	public static void main(String[] args) throws IOException {
		
		TraceData.insert("void main(java.lang.String)");
		
		File file = new File("a.txt");
		FileWriter fw = new FileWriter(file);
		fw.write("abc");
		fw.close();
		//fw.write("a");
		
		FileWriter fw1 = new FileWriter(file);
		fw1.write("abc");
		fw1.close();
		fw1.write("a");
		
		
		System.exit(1);
	}
}
