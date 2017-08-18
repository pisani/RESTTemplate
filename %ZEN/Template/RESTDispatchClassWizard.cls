/// Studio Template:<br>
/// Create a new REST Dispatch class.
Class %ZEN.Template.RESTDispatchClassWizard Extends %ZEN.Template.studioTemplate [ System = 4 ]
{

Parameter TEMPLATENAME = "REST Dispatch Class";

Parameter TEMPLATETITLE = "REST Dispatch Class";

Parameter TEMPLATEDESCRIPTION = "Create a new REST Dispatch class.";

Parameter TEMPLATETYPE = "cls";

/// What type of template.
Parameter TEMPLATEMODE = "new";

/// Domain used for localization.
Parameter DOMAIN = "%ZEN";

Parameter HELPID = "GSOAP_REST";

Property jsonRouteData As %ZEN.proxyObject;

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">

#svgFrame {
	border: 1px solid darkblue;
}

#gridRoute
 {
   width: 400px;
   height: 200px;
 }
 
 .dataGridGroupOuter{
	overflow:hidden; 
 }
 	 
 .dataGridGroupInner {
	 left:-55px;
	 position:relative;
 }
	
 
#gridMap
 {
   width: 400px;
   height: 150px;
 }
 
 .modalGroupBody
 {
	background-color:lightgray;	 
}
</style>
}

/// This XML block defines the contents of the body pane of this Studio Template.
XData templateBody [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane id="body">

<tabGroup id="tabGroup">
<tab>
<vgroup labelPosition="left" cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;">
<html id="desc" OnDrawContent="%GetDescHTML"/>
<dataCombo label="Package Name:"
		id="ctrlPackage"
		name="Package"
		required="true"
		labelClass="zenRequired"
		title="Package name for the new page"
		editable="true"
		unrestricted="true"
		searchKeyLen="0"
		maxRows="500"
		size="60"
		OnCreateResultSet="CreatePackageRS"
		onchange="zenPage.updateState();"
/>

<text label="Class Name:" 
	id="ctrlClassName"
	name="ClassName"
	size="40"
	required="true"
	labelClass="zenRequired"
	title="Class name for the new page" 
	onchange="zenPage.updateState();"
/>

<textarea label="Description:" 
	id="ctrlDescription"
	name="Description"
	rows="4"
	cols="69"
	title="Description for the new class" 
	onchange="zenPage.updateState();"
/>

<jsonProvider id="jsonRoute" OnGetArray="GetRouteArray" />
<hidden name="hdRoutes" id="hdRoutes" value="" />

<jsonProvider id="jsonMap" OnGetArray="GetMapArray" />
<hidden name="hdMaps" id="hdMaps" value="" />

<checkbox label="Handle Cors Request:" id="chkCrossOrigin" name="CrossOrigin" title="This parameter influences the CORS support. The default of unchecked delegates support based ono each individual URL Route defined." />

<group label="Routes:" labelPosition="left" groupClass="dataGridGroupOuter" >
<group groupClass="dataGridGroupInner">
<dataGrid id="gridRoute" controllerId="jsonRoute" showColumnLabels="true"  name="gridRoute"
rowLabelWidth="1px" showRowLabels="true"  rowHeight="20px"  rowLabelSpan="false"   
selectMode="cells" width="635px" canResizeColumns="false" 
 sortColumn="0" ondrawcell="return zenPage.routeCellRenderer(value,row,col);" onselectcell="zenPage.selectCell();" onaction="zenPage.routeCellAction(row,name,value);"> 
<columnDescriptor caption="URL" width="200px" type="string" />
<columnDescriptor caption="Method" width="60px" type="user" readOnly="true"/>
<columnDescriptor caption="Call" width="248px" type="string" />
<columnDescriptor caption="Cors" width="37px" type="checkbox" name="Cors" />
</dataGrid>
</group>
</group>

<hgroup align="left" > 
<button id="btnRADD" caption="Insert" onclick="zenPage.addRow(zen('jsonRoute'),zen('gridRoute'));" />
<button id="btnRDEL" caption="Remove" onclick="zenPage.deleteRow(zen('jsonRoute'),zen('gridRoute'));" />
<button id="btnRUP"  caption="Move Up" onclick="zenPage.moveRowUp(zen('jsonRoute'),zen('gridRoute'));" />
<button id="btnRDN"  caption="Move Down" onclick="zenPage.moveRowDown(zen('jsonRoute'),zen('gridRoute'));" />
</hgroup>

<spacer height="20px" />

<group label="Maps:" labelPosition="left" groupClass="dataGridGroupOuter">
<group groupClass="dataGridGroupInner">
<dataGrid id="gridMap" controllerId="jsonMap" showColumnLabels="true" 
rowLabelWidth="1px" showRowLabels="true"  rowHeight="20px" rowLabelSpan="false"   
selectMode="cells" width="630px" canResizeColumns="true"> 
<columnDescriptor caption="Forward" width="330px" type="string"/>
<columnDescriptor caption="Prefix"  width="218px" type="string" />
</dataGrid>
</group>
</group>

<hgroup align="left"> 
<button id="btnMADD" caption="Insert" onclick="zenPage.addRow(zen('jsonMap'),zen('gridMap'));" />
<button id="btnMDEL" caption="Remove" onclick="zenPage.deleteRow(zen('jsonMap'),zen('gridMap'));" />
<button id="btnMUP" caption="Move Up" onclick="zenPage.moveRowUp(zen('jsonMap'),zen('gridMap'));" />
<button id="btnMDN" caption="Move Down" onclick="zenPage.moveRowDown(zen('jsonMap'),zen('gridMap'));" />
</hgroup>

<spacer height="20px" />
 

</vgroup>
</tab>

</tabGroup>
<modalGroup id="mgRestMethods" title="Select REST Method." onshowGroup="zenPage.mgPreSelectMethod();" groupTitle="Select REST Method">

<spacer height="5px"/>
<hgroup>
<radioSet layout="vertical" id="idMethod" displayList="GET,POST,PUT,PATCH,DELETE,HEAD,OPTIONS,Other: " 
 valueList="GET,POST,PUT,PATCH,DELETE,HEAD,OPTIONS,OTHER" value="GET" onchange="zenPage.onChangeRESTMethod(zenThis.value);"/>
<text id="txMOther" size="15" valign="bottom" disabled="true" />
</hgroup>
<spacer height="20px" />
<hgroup align="right">
	<button id="mgOKButton" caption="OK" onclick="zenPage.mgOKBtnClick();" controlClass="commandButton"/>
	<spacer width="5px"/>
	<button id="mgCancelButton" caption="Cancel" onclick="zenPage.mgCancelBtnClick();" controlClass="commandButton"/>
</hgroup>
	
<spacer height="5px"/>
</modalGroup>
</pane>
}

/// Provide contents of description component.
Method %GetDescHTML(pSeed As %String) As %Status
{
	Write $$$TextHTML("This wizard creates a new REST dispatch class."),"<br/>"
	Write $$$TextHTML("Fill in the form below and then press Finish to generate your sample REST dispatch class.")
	Quit $$$OK
}

/// Create the result set used by the Package dataCombo.
Method CreatePackageRS(Output tSC As %Status, pInfo As %ZEN.Auxiliary.QueryInfo) As %ResultSet
{
	Set tRS = ""
	Set tSC = $$$OK

	Set tRS = ##class(%ResultSet).%New()
	Set tRS.ClassName = "%ZEN.Utils"
	Set tRS.QueryName = "EnumeratePackages"
	Quit tRS
}

Method GetRouteArray(ByRef pParameters, Output pMetaData, Output pData) As %Status
{
  Set pMetaData = $LB("URL","Method","Call","Cors")
  Set pData(1) = $LB("","","","")
   
  Quit $$$OK
}

Method GetMapArray(ByRef pParameters, Output pMetaData, Output pData) As %Status
{
  Set pMetaData = $LB("Forward","Prefix")
  Set pData(1) = $LB("","")
  
  Quit $$$OK
}

/// This is called when the template is first displayed;
/// This provides a chance to set focus etc.
ClientMethod onstartHandler() [ Language = javascript ]
{
	// give focus to name
	var ctrl = zenPage.getComponentById('ctrlPackage');
	if (ctrl) {
		ctrl.focus();
		ctrl.select();
	}
}

/// Validation handler for form built-into template.
ClientMethod formValidationHandler() [ Language = javascript ]
{
	return this.validateClassName();
}

ClientMethod validateClassName() [ Language = javascript ]
{
	// test if class name is valid
	var pkgName = zenPage.getComponentById('ctrlPackage').getValue();
	var clsName = zenPage.getComponentById('ctrlClassName').getValue();

	var msg = this.IsValidClassName(pkgName + "." + clsName);

	if ('' != msg) {
		alert(msg);
		zen("ctrlClassName").focus();
		return false;
	}

	return true;
}

/// addURLMapRow
ClientMethod addRow(json, grid) [ Language = javascript ]
{
	 
	content=json.getContentObject()
	if (grid.id=="gridRoute") {
		content.children.push({URL:"",Method:"",Call:"",Cors:""})
	} else if (grid.id=="gridMap") {
		content.children.push({Forward:"",Prefix:""})
	}
	
	startRow=content.children.length 
	
	json.setContentObject(content) 
	grid.setProperty('currRow',startRow)
	grid.setProperty('currColumn',1)
	zenPage.updateButtons(json,grid)
}

ClientMethod deleteRow(json, grid) [ Language = javascript ]
{
	content=json.getContentObject()
	currRow=grid.currRow
	if (content.children.length==1) {
		if (grid.id=="gridRoute") {
			obj={URL:"",Method:"",Call:"",Cors:""}
		} else if (grid.id=="gridMap") {
			obj={Forward:"",Prefix:""}
		}
		content.children[0]=obj
		
	} else {
		// delete a child entry in the middle or end of the list.
		content.children.splice(currRow-1,1)
	} 
	
	json.setContentObject(content) 
	zenPage.updateButtons(json,grid)
}

ClientMethod moveRowUp(json, grid) [ Language = javascript ]
{
	content=json.getContentObject()
	
	currRow=grid.currRow
	if (currRow==1) { return }
	
	data=content.children[currRow-1]
	content.children.splice(currRow-1,1)
	
	index=currRow-1
	content.children.splice(index-1,0,data)
	
	json.setContentObject(content) 
	grid.setProperty('currRow',currRow-1)
	grid.setProperty('currColumn',1)
	zenPage.updateButtons(json,grid)
}

ClientMethod moveRowDown(json, grid) [ Language = javascript ]
{
	content=json.getContentObject()
	
	currRow=grid.currRow
	if (currRow==content.children.length) { return }
	
	data=content.children[currRow-1]
	content.children.splice(currRow-1,1)
	
	index=currRow-1
	content.children.splice(index+1,0,data)
	
	json.setContentObject(content) 
	grid.setProperty('currRow',currRow+1)
	grid.setProperty('currColumn',1)
	zenPage.updateButtons(json,grid)
}

ClientMethod updateButtons(json, grid) [ Language = javascript ]
{
	if (grid.id=="gridRoute") {
		badd=zen("btnRADD")
		bdel=zen("btnRDEL")		
		bup=zen("btnRUP")
		bdn=zen("btnRDN")
		
	} else {
		badd=zen("btnMADD")
		bdel=zen("btnMDEL")		
		bup=zen("btnMUP")
		bdn=zen("btnMDN")
	}
		
	content=json.getContentObject()
	length=content.children.length
	var emptyFistRow=false
	
	if (zenPage.isEmpty(content.children[0])) {
		emptyFistRow=true
	}
			
	grid.refreshContents()
	
	// Add/Remove button
	if ((length==1)&&(grid.currRow==1)) {
		// only one row
		badd.setProperty("disabled",false)
		bdel.setProperty("disabled",emptyFistRow)
	} else {
		badd.setProperty("disabled",false)
		bdel.setProperty("disabled",false)
	}
		
	// Up Down buttons
	if ((length==1)){
		bup.setProperty("disabled",true)
		bdn.setProperty("disabled",true)
		return
	} else {
		if ((grid.currRow>1)&(grid.currRow<(length))) {
			bup.setProperty("disabled",false)
			bdn.setProperty("disabled",false)
		} else if (grid.currRow==1) {
			bup.setProperty("disabled",true)
			bdn.setProperty("disabled",false)
		} else if (grid.currRow==length) {
			bup.setProperty("disabled",false)
			bdn.setProperty("disabled",true)
		}
	}
	
	
	return
}

/// check if all columns on this row (ie property values of this object map) are empty
ClientMethod isEmpty(map) [ Language = javascript ]
{
   for(var key in map) {
      if (map[key]!="") {
         return false;
      }
   }
   return true;
}

/// This client event, if present, is fired when the page is loaded.
ClientMethod onloadHandler() [ Language = javascript ]
{
	zenPage.updateButtons(zen("jsonRoute"),zen("gridRoute"))
	zenPage.updateButtons(zen("jsonMap"),zen("gridMap"))
	
	return
}

/// pre-select the Option for Route Method in the modal group before showing
ClientMethod mgPreSelectMethod() [ Language = javascript ]
{
  currRow=zen('gridRoute').getProperty("currRow")
  content=zen('jsonRoute').getContentObject()
  method=content.children[currRow-1].Method
  
  if (method=="") { method="GET" }
  
  if ((method!='GET')&(method!='POST')&(method!='PUT')&(method!='PATCH')&(method!='DELETE')&(method!='HEAD')&(method!='OPTIONS')) {
  	zen('txMOther').setProperty('value',method)
  	zen('txMOther').setProperty('disabled',false)
  	method="OTHER"
  } else {
  	zen('txMOther').setProperty('value',"")
  	zen('txMOther').setProperty('disabled',true)
  }	  
  zen('idMethod').setProperty("value",method)
}

/// called by onselectcell of the Router Grid (for optimal rendering) this method 
/// opens the static modal dialog box if the column is 2 (the Method column)
/// and properly updates the grid content for CORS if column is 4 
ClientMethod selectCell() [ Language = javascript ]
{
 
  if (zen('gridRoute').currColumn!==2) { 
  	return
  }
    var group = zen('mgRestMethods');
  	group.show();
}

/// enable the text box for custom method, if 'OTHER' method option is chosen
ClientMethod onChangeRESTMethod(sel) [ Language = javascript ]
{
	if (sel=="OTHER") {
		zen("txMOther").setProperty("disabled",false)
	} else {
		zen("txMOther").setProperty("disabled",true)
	}
}

/// insert selected method into the Json content and refresh the grid
ClientMethod mgOKBtnClick() [ Language = javascript ]
{
	restMethod=zen('idMethod').getProperty("value")
	currRow=zen('gridRoute').getProperty("currRow")
	content=zen('jsonRoute').getContentObject()
	
	
	if (restMethod=="OTHER") {
		restMethod=zen("txMOther").getProperty("value")
		restMethod=restMethod.toUpperCase()
	} 
	
	content.children[currRow-1].Method=restMethod
	zen('gridRoute').currColumn=3;
	zen('gridRoute').refreshContents();
	
	zenPage.endModal();
}

ClientMethod mgCancelBtnClick() [ Language = javascript ]
{
  	zenPage.endModal();
}

ClientMethod routeCellRenderer(value, row, col) [ Language = javascript ]
{
	var cell={content:""}
	
	if (col==2) {
		cell.content="<input type='text' value='"+value+"' style='width:60px;border-style:none;' readonly  />"
		return cell
	}
	
	return null
}

/// toggle CORS value for this route entry 
ClientMethod routeCellAction(row, name, value) [ Language = javascript ]
{
 
	json=zen("jsonRoute")
	content=json.getContentObject()
	content.children[row-1].Cors=value
	
	zen('gridRoute').refreshContents();
}

/// This is called when the template is finished;
ClientMethod onfinishHandler() [ Language = javascript ]
{
	// Serialise the data held within the datagrids into hidden controls for later use by Submit logic 
	var routes=zen("jsonRoute").getContentObject()
	zen("hdRoutes").setProperty("value",JSON.stringify(routes.children)) 
	
	var routes=zen("jsonMap").getContentObject()
	zen("hdMaps").setProperty("value",JSON.stringify(routes.children)) 
	
	return true;
}

/// This method is called when the template is complete. Any
/// output to the principal device is returned to the Studio.
Method %OnTemplateAction() As %Status
{
	#dim tStream As %Library.Stream

	Set tPackage = ..%GetValueByName("Package")
	Set tClassName = ..%GetValueByName("ClassName") 
	Set tDescription = ..%GetValueByName("Description")
	set tCrossOrigin = ..%GetValueByName("CrossOrigin")
	Set tSuperClass = "%CSP.REST"
	Set cls = tPackage_"."_tClassName

	set jsonRoutes=..%GetValueByName("hdRoutes")
	do ##Class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(jsonRoutes,,.objRoutes)
	
	set jsonMaps=..%GetValueByName("hdMaps")
	do ##Class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(jsonMaps,,.objMaps)
	
	
	#; create content of new class definition
	Do ..%SetClassName(cls)
			
	#; process description
	If (tDescription = "") {
		Write "/// Created using the REST Dispatch Class Wizard.",!
	}
	Else {
		For i = 1:1:$length(tDescription,$char(13,10)) {
			Set line = $piece(tDescription,$char(13,10),i)
			Write "/// ",line,!
		}
	}
	Write "Class ",cls," Extends ",tSuperClass
	
	If (..Language '= "cache"&&(..Language'="")) {
		Write " [Language = ",..Language,"]"
	}
	Write !
	Write "{",!!
	
	Write "XData UrlMap [ XMLNamespace = ""http://www.intersystems.com/urlmap"" ]",!
	Write "{",!
	Write "<Routes>"
	kill routes
	for i=1:1:objRoutes.Count() {
		set obj=objRoutes.GetAt(i)
		set routes(i)="<Route Url="""_obj.URL_""" Method= """_obj.Method_""" Call="""_obj.Call_""" Cors="""_$select(obj.Cors=1:"true",1:"false")_"""/>"
		Write !,routes(i)
	} 
	for i=1:1:objMaps.Count() {
		set obj=objMaps.GetAt(i)
		if obj.Prefix=""&(obj.Forward="") { continue }
		Write !,"<Map Prefix="""_obj.Prefix_""" Forward= """_obj.Forward_"""/>"
	} 
	Write !,"</Routes>",!
	Write "}",! 
	
	/* Handle Cors? */
	if tCrossOrigin = 1{
		Write !," Parameter HandleCorsRequest=1;",!
	}
	
	/* Setup method signatures for Routes */
	for i=1:1:objRoutes.Count() {
		set url=objRoutes.GetAt(i).URL
		set call=objRoutes.GetAt(i).Call
		
		if (call[":")&($piece(call,":")'=cls) { continue }	// Call is to another class's method. ignore
		
		kill params set params=""
		for p=1:1:$l(url,"/") {	
			if $extract($piece(url,"/",p))=":" set params($i(params))=$extract($piece(url,"/",p),2,*) 
		}
		Write !,"/// "_routes(i)
		if (url=""!(call="")) {
			Write !,"/// WARNING: Unable to generate method signature for this route. URL or Call parameter is empty."
		} else {		
			// signature
			write !,"ClassMethod "
			if (call[":")&($piece(call,":")=cls) {
				write $piece(call,":",2)
			} elseif call'[":" {
				write call
			}
			write "("
			for j=1:1:params {
				write "p"_params(j)_" As %String"
				write:j'=params ", "
			}
			write ") as %Status"
			
			// content
			write !,"{"
		    Write !,"	#dim tSC As %Status = $$$OK"
    		Write !,"   Try {"
			Write !,"		#; ToDo..."
		    Write !,"	} Catch (e) {"
        	Write !,"		Set tSC=e.AsStatus()"
        	Write !,"   }"
    		Write !,"	Quit tSC" 
			Write !,"}",!
		}
	} 
	
	#; end of class
	Write !,"}"

	Quit $$$OK
}

}
