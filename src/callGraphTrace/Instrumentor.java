package callGraphTrace;

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
public class Instrumentor extends BodyTransformer
{
	SootClass traceDataClass;
	SootMethod insertMethod;
	/**
	 * 
	 */
	public Instrumentor() 
	{
		this.traceDataClass = Scene.v().loadClassAndSupport("callGraphTrace.TraceData");
		this.insertMethod = traceDataClass.getMethodByName("insert");
	}

	/* (non-Javadoc)
	 * @see soot.BodyTransformer#internalTransform(soot.Body, java.lang.String, java.util.Map)
	 */
	@SuppressWarnings("rawtypes")
	@Override
	protected void internalTransform(Body body, String phaseName, Map options) 
	{
		String methodName = body.getMethod().getSignature();
		System.out.println("Method name : " + body.getMethod());
		//if(body.getMethod().getName().startsWith("<"))
			//return;

		//System.out.println(body);
		PatchingChain<Unit> pc =  body.getUnits();
		Iterator<Unit> it = pc.snapshotIterator();
		
		StaticInvokeExpr stExpr = Jimple.v().newStaticInvokeExpr(insertMethod.makeRef(), (Value)StringConstant.v(methodName));
		InvokeStmt st = Jimple.v().newInvokeStmt(stExpr);
		
		while(it.hasNext())
		{
			Stmt stmt = (Stmt) it.next();
			if(stmt instanceof IdentityStmt)
			{
				pc.insertAfter(st, stmt);
				break;
			}
		}
		
		//pc.addFirst(st);
		
		body.validate();
	}
	
}
