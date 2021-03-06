<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="css/bootstrap.css" rel="stylesheet" type="text/css"/>
<title>Widget Manager</title>
</head>
<body>

<form action="widgets.jsp" method="get">
<div class="container">

<h1>Widget Manager</h1>

<table class="table">
	<tr>
		<th>ID</th>
		<th>Name</th>
		<th>Content</th>
		<th>Page</th>
		<th>Actions</th>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input name="name" class="form-control"/></td>
		<td><input name="content" class="form-control"/></td>
		<td><input name="page" type="number" class="form-control"/></td>
		<td><button type="submit" name="action" value="add" class="btn btn-success btn-block">Add Widget</button></td>
	</tr>
<%

String driver = "com.mysql.jdbc.Driver";
String url    = "jdbc:mysql://localhost/cs5200";

int id, editingId = -1;
String name, content;
String action;
int pageId;

String selectAllWidgets  = "SELECT * FROM WIDGET;";
String selectWidgetForId  = "SELECT * FROM WIDGET WHERE ID=?;";
String selectWidgetsForPageId  = "SELECT * FROM WIDGET, PAGE WHERE PAGEID=?;";
String insertNewWidget   = "INSERT INTO WIDGET VALUES (NULL, ?, ?)";
String deleteWidgetForId = "DELETE FROM WIDGET WHERE ID=?";
String updateWidgetForId = "UPDATE WIDGET SET NAME=?, CONTENT=? WHERE ID=?";

Connection connection = null;
PreparedStatement pstatement = null;
ResultSet results = null;

try {
	Class.forName (driver).newInstance();
	connection = DriverManager.getConnection (url, "root", null);
	
	action = request.getParameter("action");
	if("add".equals(action)) {
		name = request.getParameter("name");
		content = request.getParameter("content");
		pstatement = connection.prepareStatement(insertNewWidget);
		pstatement.setString(1, name);
		pstatement.setString(2, content);
		pstatement.executeUpdate();
	} else if("delete".equals(action)) {
		id = Integer.parseInt(request.getParameter("id"));
		pstatement = connection.prepareStatement(deleteWidgetForId);
		pstatement.setInt(1, id);
		pstatement.executeUpdate();
	} else if("edit".equals(action)) {
		editingId = Integer.parseInt(request.getParameter("id"));
	} else if("update".equals(action)) {
		id = Integer.parseInt(request.getParameter("idUpdate"));
		name = request.getParameter("nameUpdate");
		content = request.getParameter("contentUpdate");
		pstatement = connection.prepareStatement(updateWidgetForId);
		pstatement.setString(1, name);
		pstatement.setString(2, content);
		pstatement.setInt(3, id);
		pstatement.executeUpdate();
	}
	
	// select all
	pstatement = connection.prepareStatement(selectAllWidgets);
	results = pstatement.executeQuery();
	while(results.next()) {
		id = results.getInt("id");
		name = results.getString("name");
		content = results.getString("content");
		pageId = results.getInt("pageId");
		if(id == editingId) {%>
		<tr>
			<td><%= id %></td>
			<td><input value="<%= name %>" name="nameUpdate" class="form-control"/></td>
			<td><input value="<%= content %>" name="contentUpdate" class="form-control"/></td>
			<td><input value="<%= pageId %>" name="pageId" class="form-control"/></td>
			<td>
				<button name="action" value="update" class="btn btn-success">Update</button>
				<a href="widgets.jsp" class="btn btn-danger">Cancel</a>
				<input type="hidden" name="idUpdate" value="<%= id %>"/>
			</td>
		</tr>
<%		} else {%>
		<tr>
			<td><%= id %></td>
			<td><%= name %></td>
			<td><%= content %></td>
			<td><%= pageId %></td>
			<td>
				<a href="widgets.jsp?action=delete&id=<%= id %>" class="btn btn-danger btn-xs">Delete</a>
				<a href="widgets.jsp?action=edit&id=<%= id %>" class="btn btn-warning btn-xs">Edit</a>
			</td>
		</tr>
<%		}
	}
} catch(Exception e) {
	e.printStackTrace();
} finally {
	try {
		connection.close();
	} catch (SQLException e) {
		e.printStackTrace();
	}
}

%>
</table>
</div>
</form>
</body>
</html>