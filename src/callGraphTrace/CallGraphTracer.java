package callGraphTrace;

import java.io.FileWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import soot.Scene;
import soot.SceneTransformer;
import soot.SootClass;
import soot.SootMethod;
import soot.jimple.toolkits.callgraph.CallGraph;

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
public class CallGraphTracer extends SceneTransformer
{

	
	CallGraphTracer()
	{
		
	}
	/* (non-Javadoc)
	 * @see soot.SceneTransformer#internalTransform(java.lang.String, java.util.Map)
	 */
	@SuppressWarnings("rawtypes")
	@Override
	protected void internalTransform(String arg0, Map arg1) 
	{
		CallGraph cg = Scene.v().getCallGraph();

		try{
			FileWriter fw = new FileWriter("Trace.txt");
			fw.write(cg.toString());

			fw.close();
		}

		catch(Exception ex)
		{
			ex.printStackTrace();
		}

		//ArrayList<SootMethod> al = CallGraphDFS.callGraphDFS(cg, Scene.v().getMainMethod(), false);

		try
		{
			FileWriter fwM = new FileWriter("callChains.txt");

			for (SootClass sc : Scene.v().getClasses())
			{
				List<SootMethod> methods = sc.getMethods();

				for(SootMethod method : methods)
				{
					if(method.getName().equals("<init>"))
						continue;
					if(ExcludeMethod.excludeMethod(method))
						continue;
					
					
					ArrayList<SootMethod> al = CallGraphDFS.callGraphDFS(cg, method, false);
					
					for(SootMethod sm : al)
						fwM.write(sm.getSignature()+ "\n");
					fwM.write("------\n");
				}
			}
			
			fwM.close();
		}
		

		catch(Exception ex)
		{

		}
	}

}
