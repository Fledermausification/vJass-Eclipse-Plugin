/*
 * generated by Xtext
 */
package org.xexample.domainmodel.validation

import org.eclipse.xtext.validation.Check
import org.xexample.domainmodel.domainmodel.DomainmodelPackage
import org.xexample.domainmodel.domainmodel.Function
import org.xexample.domainmodel.domainmodel.FunctionArgument
import org.xexample.domainmodel.domainmodel.FunctionCall
import org.xexample.domainmodel.domainmodel.FunctionOperation
import org.xexample.domainmodel.domainmodel.ReturnStatement

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class DomainmodelValidator extends AbstractDomainmodelValidator {
	@Check
	def void checkFunctionNameStartsWithCapital(Function function) {
		//This is just a dummy one to test stuff out
		if (!Character::isUpperCase(function.getName().charAt(0))) {
			warning('Function names should start with a capital', 
					DomainmodelPackage.Literals::FUNCTION__NAME)
		}
	}
	
	@Check
	def void checkFunctionDefinitionArguments(Function function) {
		var nothing = false;
		for (FunctionArgument a : function.args) {
			if (a.type == "nothing") nothing = true;
		}
		if (nothing && function.args.size() > 1) {
			error('Invalid function arguments', 
				  DomainmodelPackage.Literals::FUNCTION__NAME)
		}
	}
	
	@Check
	def void checkFunctionDefinitionReturns(Function function) {
		var invalid = false;
		
		if (function.^return != "nothing") {
			//Function returns *something*
			var returns = false;
			for (FunctionOperation o : function.opertations) {
				if (o instanceof ReturnStatement) {
					var r = o as ReturnStatement;
					if (r.type != null && r.type.type == function.^return) {
						returns = true;
					}
					else {
						invalid = true;
					}
				}
			}
			
			if (!returns) {
				error('Function has no return statement', 
					  DomainmodelPackage.Literals::FUNCTION__RETURN)
			}
		}
		else {
			//Function returns nothing, but it can still have blank return statements
			for (FunctionOperation o : function.opertations) {
				if (o instanceof ReturnStatement && (o as ReturnStatement).type != null) {
				    invalid = true;
				}
			}
		}
		
		if (invalid) {
			error('Incorrect return type', 
				  DomainmodelPackage.Literals::FUNCTION__RETURN)
		}
	}
	
	@Check
	def void checkFunctionCallArguments(FunctionCall function) {
		/*System.out.println("=====================\nChecking function call to function " + function.name + " with arguments:");
		for (a : function.args) {
			if (a.value == null) {
				//Argument is a PrimitiveValue
				System.out.println("PrimVal: " + a.prim);
			}
			else if (a.prim == null) {
				//Argument is a Variable
			    System.out.println("VarVal: " + a.value);
			}
			
		}
		System.out.println(function.args.size());*/
		
		var args    = function.args;
		var argsDef = function.name.args;
		
		if (argsDef.size() == 1 && argsDef.get(0).type == "nothing" && args.size() > 0) {
			//Function def takes nothing, function call is giving > 0 parameters
			//We shouldn't need to check the size but it doesn't hurt to
			error('Incorrect amount of arguments', 
				  DomainmodelPackage.Literals::FUNCTION_CALL__NAME)
		}
		else if (args.size() == argsDef.size()) {
			//Function call's number of parameters matches the number defined in the function def
			//Need to do more validation to check types match
			var invalid = false;
			for (i : 0..< args.size()) {
				var v = args.get(i);
				var a = argsDef.get(i);
				if (v.value != null) {
					//Argument is a Variable
					if (v.value.type != a.type) {
						invalid = true;
					}
				}
				else if (v.prim != null) {
					//Argument is a PrimitiveValue
					//Add more validation in here!
				}
			}
			
			if (invalid) {
				error('Arguments are invalid!', 
				      DomainmodelPackage.Literals::FUNCTION_CALL__NAME)
			}
		}
		else if (argsDef.get(0).type != "nothing") {
			//We only care about argument number mismatches for non-nothing function def's
			//The first if statement will handle those
			error('Incorrect amount of arguments', 
				  DomainmodelPackage.Literals::FUNCTION_CALL__NAME)
		}
	}
//	
//	@Check
//	def void checkGlobalVaribaleType(GlobalVariable v) {
////		var type  = v.type;
////		var value = v.value;
//		//var quote = '"'.charAt(0);
//		
////		System.out.println("Checking global " + v.name + " of type " + type + " with value " + value + " and varvalue of " + v.varvalue);
//		
//		/*if (type == "integer") {
//		    try {
//		    	Integer.parseInt(value);
//		    }
//		    catch (NumberFormatException e) {
//		    	error('Incorrect integer value',
//		    		DomainmodelPackage$Literals::GLOBAL_VARIABLE__VALUE
//		    	);
//		    }
//		}
//		else if (type == "real") {
//			try {
//				Double.parseDouble(value);
//			}
//			catch (NumberFormatException e) {
//				error('Incorrect real value',
//		    		DomainmodelPackage$Literals::GLOBAL_VARIABLE__VALUE
//		    	);
//			}
//		}
//		else if (type == "boolean" && value != "true" && value != "false") {
//			error('Incorrect boolean value',
//		    	DomainmodelPackage$Literals::GLOBAL_VARIABLE__VALUE
//		    );
//		}
//		else if (type == "string" && value.charAt(0) != quote && value.charAt(value.length - 1) != quote) {
//			error('Incorrect string value',
//		    	DomainmodelPackage$Literals::GLOBAL_VARIABLE__VALUE
//		    );
//		}*/
//	}
//	
//	@Check
//	def void checkFunctionArguments(Function f) {
//		System.out.println("Function args: " + f);
//		for (arg : f.args) {
//			System.out.println(arg.type + " - " + arg.name);
//		}
//	}
	
//	@Check
//	def void checkFunctionNameIsUnique(Function function) {
//		var superScopeType = (function.eContainer() as ScopeType).getSuperType();
//	}
}