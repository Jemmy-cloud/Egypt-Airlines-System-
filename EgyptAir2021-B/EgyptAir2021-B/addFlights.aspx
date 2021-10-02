<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html>


<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        // 1- Create connection Object
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=|DataDirectory|EgyptAir.mdf;Integrated Security=True";

        // Convert number of seats from string to int
        string strSeats = txtSeats.Text;
        int seats = Convert.ToInt32(strSeats);

        // 2- Create SQL Insert statement to add new flight to table Flight

        string strInsert = "INSERT INTO Flight "
            + " VALUES('" + txtFlightNo.Text + "', '"
            + txtFlightDate.Text + "', '"
            + ddlDairport.SelectedValue + "', '"
            + txtDtime.Text + "', '"
            + ddlAairport.SelectedValue + "', '"
            + txtAtime.Text + "', " + seats + ")";

        // 3- Create SQL command 
        SqlCommand cmdInsert = new SqlCommand(strInsert, conn);
        
        // 4- Execute SQL command
        conn.Open();
        cmdInsert.ExecuteNonQuery();


        // 5- Create SQL Select Query to display added Flight
        string strSelect = "SELECT FlightNo, CONVERT(varchar(10), FlightDate, 101) as FlightDate, "
            + " Dairport, Dtime, Aairport, Atime, Seats "
            + " FROM Flight "
            + " WHERE FlightDate = '" + txtFlightDate.Text + "'";

        // 6- Create SQL command
        SqlCommand cmdSelect = new SqlCommand(strSelect, conn);

        
        // 7- Create Data Table to receive result of query
        DataTable tbl = new DataTable();

        // 8- Load the Data Table with result of SQL query
        tbl.Load(cmdSelect.ExecuteReader());

        // 9- Configure the Data Source of Data Grid to be the Data Table tbl
        gdvFlights.DataSource = tbl;
        
        // 10 - Load the Data Grid with content of the Data Table
        gdvFlights.DataBind();


        // 11- Close the database connection
        conn.Close();

    }

 </script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
        .auto-style2 {
            width: 107px;
        }
        .auto-style3 {
            width: 107px;
            height: 23px;
        }
        .auto-style4 {
            height: 23px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Names="Arial" Font-Size="Large" ForeColor="#000066" Text="Manage Flights Schedule"></asp:Label>
            <br />
            <br />
            <asp:Label ID="Label9" runat="server" Font-Bold="True" Font-Names="Arial" Font-Size="Large" ForeColor="#000066" Text="Add Flight:"></asp:Label>
            <br />
            <br />
            <table class="auto-style1">
                <tr>
                    <td class="auto-style3">
                        <asp:Label ID="Label2" runat="server" Text="FlightNo" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066"></asp:Label>
                    </td>
                    <td class="auto-style4">
                        <asp:Label ID="Label3" runat="server" Text="Flight Date" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066"></asp:Label>
                    </td>
                    <td class="auto-style4">
                        <asp:Label ID="Label4" runat="server" Text="Departure" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066"></asp:Label>
                    </td>
                    <td class="auto-style4">
                        <asp:Label ID="Label5" runat="server" Text="Departure Time" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066"></asp:Label>
                    </td>
                    <td class="auto-style4">
                        <asp:Label ID="Label6" runat="server" Text="Destination" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066"></asp:Label>
                    </td>
                    <td class="auto-style4">
                        <asp:Label ID="Label7" runat="server" Text="Arrival Time" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066"></asp:Label>
                    </td>
                    <td class="auto-style4">
                        <asp:Label ID="Label8" runat="server" Text="Seats" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style2">
                        <asp:TextBox ID="txtFlightNo" runat="server" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="txtFlightDate" runat="server" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066" TextMode="Date"></asp:TextBox>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlDairport" runat="server" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066">
                            <asp:ListItem Selected="True">Cairo</asp:ListItem>
                            <asp:ListItem>Alex</asp:ListItem>
                            <asp:ListItem>Paris</asp:ListItem>
                            <asp:ListItem>London</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:TextBox ID="txtDtime" runat="server" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066"></asp:TextBox>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlAairport" runat="server" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066">
                            <asp:ListItem Selected="True">Cairo</asp:ListItem>
                            <asp:ListItem>Alex</asp:ListItem>
                            <asp:ListItem>Paris</asp:ListItem>
                            <asp:ListItem>London</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:TextBox ID="txtAtime" runat="server" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066"></asp:TextBox>
                    </td>
                    <td>
                        <asp:TextBox ID="txtSeats" runat="server" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <br />
            <asp:Button ID="btnSubmit" runat="server" Font-Names="Arial Black" Font-Size="Medium" ForeColor="#000066" OnClick="btnSubmit_Click" Text="Submit" />
            <br />
            <br />
            <br />
            <asp:GridView ID="gdvFlights" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" CellPadding="4" DataKeyNames="FlightNo,FlightDate" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066" GridLines="None">
                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                <Columns>
                    <asp:BoundField DataField="FlightNo" HeaderText="FlightNo" ReadOnly="True" SortExpression="FlightNo" />
                    <asp:BoundField DataField="FlightDate" HeaderText="FlightDate" ReadOnly="True" SortExpression="FlightDate" />
                    <asp:BoundField DataField="Dairport" HeaderText="Dairport" SortExpression="Dairport" />
                    <asp:BoundField DataField="Dtime" HeaderText="Dtime" SortExpression="Dtime" />
                    <asp:BoundField DataField="Aairport" HeaderText="Aairport" SortExpression="Aairport" />
                    <asp:BoundField DataField="Atime" HeaderText="Atime" SortExpression="Atime" />
                    <asp:BoundField DataField="Seats" HeaderText="Seats" SortExpression="Seats" />
                </Columns>
                <EditRowStyle BackColor="#999999" />
                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                <SortedAscendingCellStyle BackColor="#E9E7E2" />
                <SortedAscendingHeaderStyle BackColor="#506C8C" />
                <SortedDescendingCellStyle BackColor="#FFFDF8" />
                <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" DeleteCommand="DELETE FROM [Flight] WHERE [FlightNo] = @FlightNo AND [FlightDate] = @FlightDate" InsertCommand="INSERT INTO [Flight] ([FlightNo], [FlightDate], [Dairport], [Dtime], [Aairport], [Atime], [Seats]) VALUES (@FlightNo, @FlightDate, @Dairport, @Dtime, @Aairport, @Atime, @Seats)" SelectCommand="SELECT * FROM [Flight]" UpdateCommand="UPDATE [Flight] SET [Dairport] = @Dairport, [Dtime] = @Dtime, [Aairport] = @Aairport, [Atime] = @Atime, [Seats] = @Seats WHERE [FlightNo] = @FlightNo AND [FlightDate] = @FlightDate" >
                <DeleteParameters>
                    <asp:Parameter Name="FlightNo" Type="String" />
                    <asp:Parameter DbType="Date" Name="FlightDate" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="FlightNo" Type="String" />
                    <asp:Parameter DbType="Date" Name="FlightDate" />
                    <asp:Parameter Name="Dairport" Type="String" />
                    <asp:Parameter Name="Dtime" Type="String" />
                    <asp:Parameter Name="Aairport" Type="String" />
                    <asp:Parameter Name="Atime" Type="String" />
                    <asp:Parameter Name="Seats" Type="Int32" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Dairport" Type="String" />
                    <asp:Parameter Name="Dtime" Type="String" />
                    <asp:Parameter Name="Aairport" Type="String" />
                    <asp:Parameter Name="Atime" Type="String" />
                    <asp:Parameter Name="Seats" Type="Int32" />
                    <asp:Parameter Name="FlightNo" Type="String" />
                    <asp:Parameter DbType="Date" Name="FlightDate" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <br />
            <br />

            <asp:LinkButton ID="LinkButton1" runat="server" Font-Bold="True" Font-Names="Arial Black" Font-Size="Medium" ForeColor="#000066" PostBackUrl="~/manageFlights.aspx">Edit/Delete Flights</asp:LinkButton>

        </div>
    </form>
</body>
</html>

