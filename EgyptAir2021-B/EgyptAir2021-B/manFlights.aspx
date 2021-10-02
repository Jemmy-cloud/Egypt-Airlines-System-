<%@ Page Title="" Language="C#" MasterPageFile="~/adminMaster.master" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>


<script runat="server">

    protected void btnDisplay_Click(object sender, EventArgs e)
    {
        // 1- Create connection object
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=|DataDirectory|EgyptAir.mdf;Integrated Security=True";

        // 2- Create SQL Select statement

        string strSelect = "SELECT FlightNo, CONVERT(varchar(10), FlightDate, 101) as FlightDate, "
            + "Dairport, Dtime, Aairport, Atime, Seats "
            + " FROM Flight "
            + " WHERE FlightDate >= '" + txtStartDate.Text + "' AND "
            + " FlightDate <= '" + txtEndDate.Text + "'";


        // 3- Create SQL command
        SqlCommand cmdSelect = new SqlCommand(strSelect, conn);

        // 4- Create SQL Data reader
        SqlDataReader reader;

        // 5- Execute SQL query
        conn.Open();
        reader = cmdSelect.ExecuteReader();

        // 5- Create Data table
        DataTable tbl = new DataTable();

        // 6- load data table tbl with result of SQL query

        if (reader.Read())
        {
            tbl.Load(reader);

            // bindind tbl data to the gridview
            gdvFlights.DataSource = tbl;
            gdvFlights.DataBind();
            gdvFlights.Visible = true;
            lblMsg.Text = "";
        }
        else
        {
            gdvFlights.Visible = false;
            lblMsg.Text = "No Flights Available !!";
        }

        conn.Close();
    }

    protected void txtStartDate_TextChanged(object sender, EventArgs e)
    {

    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Label ID="Label1" runat="server" Font-Names="Arial Black" Font-Size="Medium" Text="Manage Flights:"></asp:Label>
    <br />
    <br />
    <asp:Label ID="Label2" runat="server" Font-Names="Arial Black" Font-Size="Medium" Text="From:"></asp:Label>
&nbsp;&nbsp;&nbsp;
    <asp:TextBox ID="txtStartDate" runat="server" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066" TextMode="Date" OnTextChanged="txtStartDate_TextChanged"></asp:TextBox>
&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Label ID="Label3" runat="server" Font-Names="Arial Black" Font-Size="Medium" Text="To:        "></asp:Label>
&nbsp;&nbsp;
    <asp:TextBox ID="txtEndDate" runat="server" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066"  TextMode="Date"></asp:TextBox>
    <br />
    <br />
    <asp:Button ID="btnDisplay" runat="server" Font-Names="Arial Black" Font-Size="Medium" ForeColor="#000066" OnClick="btnDisplay_Click" Text="Display" />
    <br />
    <br />
    <br />
    <asp:GridView ID="gdvFlights" runat="server" CellPadding="4" Font-Names="Arial" Font-Size="Medium" ForeColor="#000066" GridLines="None" AutoGenerateColumns="False" DataKeyNames="FlightNo,FlightDate" >
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        <Columns>
            <asp:BoundField DataField="FlightNo" HeaderText="FlightNo" ReadOnly="True" SortExpression="FlightNo" />
            <asp:BoundField DataField="FlightDate" HeaderText="FlightDate" ReadOnly="True" SortExpression="FlightDate" />
            <asp:BoundField DataField="Dairport" HeaderText="Dairport" SortExpression="Dairport" />
            <asp:BoundField DataField="Dtime" HeaderText="Dtime" SortExpression="Dtime" />
            <asp:BoundField DataField="Aairport" HeaderText="Aairport" SortExpression="Aairport" />
            <asp:BoundField DataField="Atime" HeaderText="Atime" SortExpression="Atime" />
            <asp:BoundField DataField="Seats" HeaderText="Seats" SortExpression="Seats" />
            <asp:CommandField HeaderText="Edit" ShowEditButton="True" ShowHeader="True" />
            <asp:CommandField HeaderText="Delete" ShowDeleteButton="True" ShowHeader="True" />
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
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT [FlightNo], [FlightDate], [Dairport], [Dtime], [Aairport], [Atime], [Seats] FROM [Flight]" DeleteCommand="DELETE FROM [Flight] WHERE [FlightNo] = @FlightNo AND [FlightDate] = @FlightDate" InsertCommand="INSERT INTO [Flight] ([FlightNo], [FlightDate], [Dairport], [Dtime], [Aairport], [Atime], [Seats]) VALUES (@FlightNo, @FlightDate, @Dairport, @Dtime, @Aairport, @Atime, @Seats)" UpdateCommand="UPDATE [Flight] SET [Dairport] = @Dairport, [Dtime] = @Dtime, [Aairport] = @Aairport, [Atime] = @Atime, [Seats] = @Seats WHERE [FlightNo] = @FlightNo AND [FlightDate] = @FlightDate">
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
    <asp:Label ID="lblMsg" runat="server" Font-Names="Arial Black" Font-Size="Medium"></asp:Label>
    <br />
    <br />
</asp:Content>

