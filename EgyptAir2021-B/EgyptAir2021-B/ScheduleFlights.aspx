<%@ Page Title="" Language="C#" MasterPageFile="~/adminMaster.master" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <p>
    <br />
</p>
<p>
    <asp:GridView ID="grdaddFlights" runat="server" AutoGenerateColumns="False" 
        CellPadding="4" DataKeyNames="FlightNo,FlightDate" 
        DataSourceID="SqlDataSource1" Font-Names="Arial" ForeColor="#000066" 
        GridLines="None">
        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
        <Columns>
            <asp:BoundField DataField="FlightNo" HeaderText="FlightNo" ReadOnly="True" 
                SortExpression="FlightNo" />
            <asp:BoundField DataField="FlightDate" HeaderText="FlightDate" ReadOnly="True" 
                SortExpression="FlightDate" />
            <asp:BoundField DataField="Dairport" HeaderText="Dairport" 
                SortExpression="Dairport" />
            <asp:BoundField DataField="Dtime" HeaderText="Dtime" SortExpression="Dtime" />
            <asp:BoundField DataField="Aairport" HeaderText="Aairport" 
                SortExpression="Aairport" />
            <asp:BoundField DataField="Atime" HeaderText="Atime" SortExpression="Atime" />
            <asp:BoundField DataField="Seats" HeaderText="Seats" SortExpression="Seats" />
            <asp:CommandField HeaderText="Edit/Update" ShowEditButton="True" 
                ShowHeader="True" />
            <asp:CommandField HeaderText="Delete" ShowDeleteButton="True" 
                ShowHeader="True" />
            <asp:CommandField HeaderText="Select" ShowHeader="True" 
                ShowSelectButton="True" />
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
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
        DeleteCommand="DELETE FROM [Flight] WHERE [FlightNo] = @FlightNo AND [FlightDate] = @FlightDate" 
        InsertCommand="INSERT INTO [Flight] ([FlightNo], [FlightDate], [Dairport], [Dtime], [Aairport], [Atime], [Seats]) VALUES (@FlightNo, @FlightDate, @Dairport, @Dtime, @Aairport, @Atime, @Seats)" 
        SelectCommand="SELECT * FROM [Flight]" 
        UpdateCommand="UPDATE [Flight] SET [Dairport] = @Dairport, [Dtime] = @Dtime, [Aairport] = @Aairport, [Atime] = @Atime, [Seats] = @Seats WHERE [FlightNo] = @FlightNo AND [FlightDate] = @FlightDate">
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
</p>
<p>
</p>
</asp:Content>

