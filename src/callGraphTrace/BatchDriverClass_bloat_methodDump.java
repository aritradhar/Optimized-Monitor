package callGraphTrace;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import soot.*;
import soot.options.Options;
public class BatchDriverClass_bloat_methodDump 
{
	public static List<String> files = new ArrayList<>();

	public static HashMap<String, Integer> hm = new HashMap<>();
	public static int counter = 0;

	public static void walk( String path ) {

		File root = new File( path );
		File[] list = root.listFiles();

		if (list == null) return;

		for ( File f : list ) {
			if ( f.isDirectory() ) {
				walk( f.getAbsolutePath() );
				//System.out.println( "Dir:" + f.getAbsoluteFile() );
			}
			else {
				String fName = f.getAbsoluteFile().toString().substring(44);
				if(fName.contains(".class"))
				{
					//if(fName.contains("CompactArrayInitializer") || fName.contains("ClassHierarchy"))
					//	continue;
					fName = fName.replace(".class", "");
					fName = fName.replaceAll("\\\\", ".");
					System.out.println(fName);
					files.add(fName);
				}

			}
		}
	}

	public static void main(String[] args) throws IOException
	{
		
		long start = System.currentTimeMillis();
		/*if(args.length == 0)
		{
			System.err.println("Usage: java MainDriver[options] classname");
			System.exit(0);
		}*/
		walk("bin\\EDU");


		for(String s : files)
		{
			String[] ar = {s};			
			System.err.println("Instrumenting : " + s);
			Options.v().set_soot_classpath("C:\\Users\\Aritra\\workspace\\CGTrace\\bin");				
			Options.v().set_prepend_classpath(true);
			Options.v().setPhaseOption("jb", "use-original-names:true");
			Pack jtp = PackManager.v().getPack("jtp");
			jtp.add(new Transform("jtp.instrumenter",new MethodDump()));
			try
			{
				soot.Main.main(ar);
			}
			catch(Exception ex)
			{
				System.err.println("Exception happed in " + s);
				G.reset();
				System.out.println("-------------------------------------------------------------");
				continue;
			}
			
			G.reset();
			System.out.println("-------------------------------------------------------------");
		}

		FileWriter fw = new FileWriter("MethodList.txt");

		for(String method : BatchDriverClass_bloat_methodDump.hm.keySet())
		{
			fw.append(method + "|" + BatchDriverClass_bloat_methodDump.hm.get(method) + "\n");
		}

		fw.close();
		
		long end = System.currentTimeMillis();
		
		System.out.println("Total time taken : " + (end - start) + " ms.");
	}

}
