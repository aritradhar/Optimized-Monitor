//*************************************************************************************
//*********************************************************************************** *
//author Aritra Dhar																* *
//MT12004																			* *
//M.TECH CSE																		* * 
//INFORMATION SECURITY																* *
//IIIT-Delhi																		* *	 
//---------------------------------------------------------------------------------	* *																				* *
/////////////////////////////////////////////////									* *
//The program will do the following::::         //									* *
/////////////////////////////////////////////////									* *
//version 1.0																		* *
//*********************************************************************************** * 
//*************************************************************************************

package callGraphTrace;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import soot.PackManager;
import soot.Scene;
import soot.SootClass;
import soot.SootMethod;
import soot.Transform;
import soot.options.Options;
import soot.util.Chain;


public class CallGraphDriver 
{
	
	public static void main(String[] className) 
	{

		//String []className = {"callGraphTrace.Test"};
		
		Options.v().set_soot_classpath("C:\\Users\\Aritra\\workspace\\CGTrace\\bin");				
		Options.v().set_prepend_classpath(true);
		Options.v().setPhaseOption("cg.cha", "on");
		Options.v().set_exclude(Arrays.asList(new String[]{"java", "sun", "java.lang"}));
		Options.v().set_no_bodies_for_excluded(true);
		
		PackManager.v().getPack("wjtp").add(new Transform("wjtp.myTransform", new CallGraphTracer()));
		
		List<SootMethod> entryPoints = new ArrayList<SootMethod>();

		/*
		Chain<SootClass> s =  Scene.v().getClasses();

		for (SootClass sc : Scene.v().getClasses()){
		    if (sc.declaresMethodByName("main"))
			entryPoints.add(sc.getMethodByName("main"));
		}

		Scene.v().setEntryPoints(entryPoints);
*/
		
		Options.v().setPhaseOption("jb", "use-original-names:true");
	     
        String st = "c";
        
        if(st.equalsIgnoreCase("j"))
        	Options.v().set_output_format(Options.output_format_jimple);
        
        if(st.equalsIgnoreCase("c"))
        	Options.v().set_output_format(Options.output_format_class); 
        
        Options.v().set_whole_program(true);
		
		Options.v().set_app(true);
		
		soot.Main.main(className);
	}
}
