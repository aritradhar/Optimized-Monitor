package callGraphTrace;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Iterator;
import java.util.Map;

import soot.Body;
import soot.BodyTransformer;
import soot.PatchingChain;
import soot.Scene;
import soot.SootClass;
import soot.SootMethod;
import soot.Unit;
import soot.Value;
import soot.jimple.IdentityStmt;
import soot.jimple.InvokeStmt;
import soot.jimple.Jimple;
import soot.jimple.StaticInvokeExpr;
import soot.jimple.Stmt;
import soot.jimple.StringConstant;

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
public class MethodDump extends BodyTransformer
{


	/* (non-Javadoc)
	 * @see soot.BodyTransformer#internalTransform(soot.Body, java.lang.String, java.util.Map)
	 */
	@SuppressWarnings("rawtypes")
	@Override
	protected void internalTransform(Body body, String phaseName, Map options) 
	{
		String methodName = body.getMethod().getSignature();
		
		System.out.println("Method name : " + body.getMethod());
		
		//exclude constructors
		if(body.getMethod().getName().startsWith("<"))
			return;

		//System.out.println(body);
		PatchingChain<Unit> pc =  body.getUnits();
		Iterator<Unit> it = pc.snapshotIterator();
		
		//pc.addFirst(st);
		
		body.validate();
	}
	
}
