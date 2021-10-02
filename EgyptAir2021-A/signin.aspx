<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        // 1- Create Connection Object
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=|DataDirectory|EgyptAir.mdf;Integrated Security=True";

        // 2- Create SQL Select statement
        string strSelect = "SELECT * FROM Member "
            + " WHERE Username = '" + txtUsername.Text + "' AND Password = '"
            + txtPassword.Text + "'";

        // 3- Create SQL Select Command
        SqlCommand cmdSelect = new SqlCommand(strSelect, conn);

        // 4- Create data reader object
        SqlDataReader reader;

        // 5- Open the database
        conn.Open();

        // 6- Execute Select command

        reader = cmdSelect.ExecuteReader();

        if (reader.Read())
            Response.Redirect("~/userHome.aspx");
        else
            lblMsg.Text = "Incorrect Username and/or Password, Please try again!!";

        // 7- close the database
        conn.Close();

    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
        .style2
        {
        }
        .style3
        {
            height: 34px;
        }
        .style4
        {
            height: 34px;
        }
        .style5
        {
            width: 96px;
        }
        .style6
        {
            height: 34px;
            width: 96px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:Label ID="Label1" runat="server" Font-Names="Monotype Corsiva" 
            Font-Size="X-Large" ForeColor="#000066" 
            Text="Enter your Username and Password to login in:"></asp:Label>
        <br />
        <br />
        <table class="style1">
            <tr>
                <td class="style5">
                    <asp:Label ID="Label2" runat="server" Font-Names="Arial" Font-Size="Medium" 
                        ForeColor="#000066" Text="Username:"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtUsername" runat="server" Font-Names="Arial" 
                        Font-Size="Medium" ForeColor="#000066" Width="175px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="style5">
                    <asp:Label ID="Label3" runat="server" Font-Names="Arial" Font-Size="Medium" 
                        ForeColor="#000066" Text="Password:"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtPassword" runat="server" Font-Names="Arial" 
                        Font-Size="Medium" ForeColor="#000066" TextMode="Password" Width="175px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="style6">
                </td>
                <td class="style4">
                </td>
            </tr>
            <tr>
                <td class="style5">
                    <asp:Button ID="btnLogin" runat="server" Font-Names="Arial" Font-Size="Medium" 
                        ForeColor="#000066"  Text="Log In" OnClick="btnLogin_Click"  />
                </td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="style2" colspan="2">
                    &nbsp;</td>
            </tr>
        </table>
    
    </div>
    <table class="style1">
        <tr>
            <td class="style3">
                <asp:Label ID="lblMsg" runat="server" Font-Names="Monotype Corsiva" 
                    Font-Size="X-Large" ForeColor="#000066"></asp:Label>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
