package callGraphTrace;
import soot.*;


import soot.options.Options;
public class DriverClass_MethodDump 
{
	public static void main(String[] args)
	{
		/*if(args.length == 0)
		{
			System.err.println("Usage: java MainDriver[options] classname");
			System.exit(0);
		}*/
		Options.v().set_soot_classpath("C:\\Users\\Aritra\\workspace\\CGTrace\\bin");				
		Options.v().set_prepend_classpath(true);
		Options.v().setPhaseOption("jb", "use-original-names:true");
		Pack jtp = PackManager.v().getPack("jtp");
		jtp.add(new Transform("jtp.instrumenter",new MethodDump()));
	
		soot.Main.main(args);
	}
	
}
