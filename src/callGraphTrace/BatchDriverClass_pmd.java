package callGraphTrace;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import soot.*;
import soot.options.Options;
public class BatchDriverClass_pmd 
{
	public static List<String> files = new ArrayList<>();

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
					fName = fName.replace(".class", "");
					fName = fName.replaceAll("\\\\", ".");
					
					//if(!fName.contains("pmd.jaxen"))
					//{
						System.out.println(fName);
						files.add(fName);
					//}
				}

			}
		}
	}

	public static FileWriter fw;
	public static void main(String[] args) throws IOException
	{
		fw = new FileWriter("log.txt");
		long start = System.currentTimeMillis();
		
		/*if(args.length == 0)
		{
			System.err.println("Usage: java MainDriver[options] classname");
			System.exit(0);
		}*/
		walk("bin\\net");

		for(String s : files)
		{
			String[] ar = {s};
			System.err.println("Instrumenting : " + s);
			fw.append("Class : " + s + "\n");
			
			Options.v().set_soot_classpath("C:\\Users\\Aritra\\workspace\\CGTrace\\bin;"
					+ "C:\\lib\\apache-ant-1.8.2.jar;"
					+ "C:\\lib\\pmd_dep.jar;"
					+ "C:\\lib\\apache-jakarta-oro.jar");	
			
			Options.v().set_prepend_classpath(true);
			Options.v().setPhaseOption("jb", "use-original-names:true");
			Pack jtp = PackManager.v().getPack("jtp");
			jtp.add(new Transform("jtp.instrumenter",new Instrumentor()));

			soot.Main.main(ar);
			G.reset();
			System.err.println("===================================================================");
		}
		
		System.out.println("Total class instrumented : " + files.size());
		long end = System.currentTimeMillis();
		double time = (double) (end - start) / 1000;
		System.out.println("Total time : " + time + " sec");
		
		fw.close();
	}

}
