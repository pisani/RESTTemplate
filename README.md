## Summary

This code is a functioning New Document Template Wizard that can be introduced into the InterSystems Cache developmoent environment for access via the InterSystems Caceh Studio IDE.  Note, that the approach for this template however, 
is to use %ZEN classes (not CSP) in the same manner as %ZEN Studio templates are designed.

A New Document Template in the Cache Studio IDE creats a new document (in this case a Cache Class) based on a form that is filled in. 

This new document template prompts the user for REST interface details, and builds a skeleton REST Dispatch Class with URL Map, Route Map and placeholders for the call back Methods.

## Installation

To install this template into your Cache development environment, for use across all namespaces, import the %ZEN.Template.RESTDispatchClassWizard code into your environment as follows:

1. Make sure CACHELIB is set to Read/Write and record the previous state.
2. Using the System Managment Portal go to System Explorer > Classes
3. Ensure you are referencing the Namespace: %SYS, and select 'Import'
4. Select [x] File, and enter the full path to the downloaded 'RESTDispatchClassWizard.xml' file.
5. Ensure [x] Compile is selected.
6. Select Next, and Finish.
7. Return the CACHELIB Read/Write status to the previous setting.


## Usage

1. Using Cache Studio select File - > New...
2. Under Category 'Custom:'  choose REST Dispatch Class and hit OK
3. Specify the Package and Class name for the dispatch class
4. Provide a description (optional)
5. Select 'Handle Cors Request' if CORS support is to be the default for this class.
6. Specify Routes in the ROUTES data grid.  For each route (eg /customers/:ID) specify a REST Method (eg: 'GET') and a method name to use for this call (eg 'getCustomers').
   Do not specify arguments in the method name.  They will be autmatically inserted using REST url as a reference.
   
   Using the above examples, the following method will be generated in the Dispatch class:
	
	```
	/// <Route Url="/customers/:ID" Method= "GET" Call="getCustomers" Cors="false"/>
	ClassMethod getCustomers(pID As %String) as %Status
	{
	#dim tSC As %Status = $$$OK
	Try {
			#; ToDo...
		} Catch (e) {
			Set tSC=e.AsStatus()
	}
		Quit tSC
	}
	```
	
7. Specify additional Routes.
8. Specify an Maps for the Dispatch class.
9. Click FINISH to generate a dispatch class.  Note that the generated class is NOT Saved automatically for you.


