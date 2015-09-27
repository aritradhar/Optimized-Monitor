package monitors.fileWrite;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class FileTest {

	public static void main(String[] args) throws IOException {
		
		File file = new File("a.txt");
		FileWriter fw = new FileWriter(file);
		fw.write("abc");
		fw.close();
		fw.write("a");
		System.exit(1);
	}
}
