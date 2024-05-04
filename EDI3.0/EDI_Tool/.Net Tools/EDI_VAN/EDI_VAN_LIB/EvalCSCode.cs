using System;
using System.Text;
using System.CodeDom;
using System.CodeDom.Compiler;
using System.Reflection;
using System.Windows;
using Microsoft.CSharp;

namespace EDI_VAN_LIB
{
	public class EvalCSCode
	{
		public static object Eval(string sCSCode) 
		{
			CSharpCodeProvider cSharpCodeProvider = new CSharpCodeProvider();
			ICodeCompiler icc = cSharpCodeProvider.CreateCompiler();
			CompilerParameters compilerParameters = new CompilerParameters();

			compilerParameters.ReferencedAssemblies.Add("system.dll");
			compilerParameters.ReferencedAssemblies.Add("system.xml.dll");
			compilerParameters.ReferencedAssemblies.Add("system.data.dll");
			compilerParameters.ReferencedAssemblies.Add("system.windows.forms.dll");
			compilerParameters.ReferencedAssemblies.Add("system.drawing.dll");
		 
			compilerParameters.CompilerOptions = "/t:library";
			compilerParameters.GenerateInMemory = true;
			StringBuilder stringBuilder = new StringBuilder("");

			stringBuilder.Append("using System;\n" );
			stringBuilder.Append("using System.Xml;\n");
			stringBuilder.Append("using System.Data;\n");
			stringBuilder.Append("using System.Data.SqlClient;\n");
			stringBuilder.Append("using System.Windows.Forms;\n");
			stringBuilder.Append("using System.Drawing;\n");

			stringBuilder.Append("namespace CSCodeEvaler{ \n");
			stringBuilder.Append("public class CSCodeEvaler{ \n");
			stringBuilder.Append("public object EvalCode(){\n");
			stringBuilder.Append("return "+sCSCode+"; \n");
			stringBuilder.Append("} \n");
			stringBuilder.Append("} \n");
			stringBuilder.Append("}\n");

			CompilerResults cr = icc.CompileAssemblyFromSource(compilerParameters, stringBuilder.ToString());
			if( cr.Errors.Count > 0 )
			{ 
				//WindowsLog.WindowsLog.WriteLog("Application", "EDI VAN NetWrok:" + "ERROR: " + cr.Errors[0].ErrorText, 103, 0);
				return null;
			}

			System.Reflection.Assembly assembly = cr.CompiledAssembly;
			object obj = assembly.CreateInstance("CSCodeEvaler.CSCodeEvaler");
			Type type = obj.GetType();
			MethodInfo methodInfo = type.GetMethod("EvalCode");
			object InvokedObj = methodInfo.Invoke(obj, null);
			return InvokedObj;
		}
	}
}
