package com.udox.utils
{
	public class StringTemplate
	{
		/**
		 * Mimics the python template string format, eg:
		 * 
		 * "blah blah %(varname)s blah blah"
		 * 
		 * then you pass in a 'dict' of varnames which get
		 * substituted into the string when run.
		 */
		public static function parse(str:String, vars:Object):String
		{
			var re:RegExp = /\%\((\w+)\)s/g;
			var match:Object;
			while((match=re.exec(str)) !== null) {
				if (vars.hasOwnProperty(match[1])) {
					str = str.replace(match[0], vars[match[1]]);
				}
			}
			return str;
		}
	}
}