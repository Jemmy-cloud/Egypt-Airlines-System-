﻿<%@ Page Title="" Language="C#" MasterPageFile="~/adminMaster.master" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<script runat="server">


    protected void SqlDataSource1_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {


    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style14
    {
        width: 67%;
    }
    .style15
    {
        width: 298px;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <p>


        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
</p>
    <p>


    <asp:Label ID="Label1" runat="server" Font-Names="Arial Black" 
        Font-Size="Medium" ForeColor="#000066" Text="Browse Flights:"></asp:Label>
    <br />
</p>
<table class="style14">
    <tr>
        <td class="style15">
            <asp:Label ID="Label2" runat="server" Font-Names="Arial Black" 
                Font-Size="Medium" ForeColor="#000066" Text="From:"></asp:Label>
&nbsp;&nbsp;
            <asp:TextBox ID="txtStartDate" runat="server" Font-Names="Arial" 
                Font-Size="Medium" ForeColor="#000066"></asp:TextBox>
            <ajaxToolkit:CalendarExtender ID="txtStartDate_CalendarExtender" runat="server" 
                BehaviorID="txtStartDate_CalendarExtender" TargetControlID="txtStartDate">
            </ajaxToolkit:CalendarExtender>
        </td>
        <td>
            <asp:Label ID="Label3" runat="server" Font-Names="Arial Black" 
                Font-Size="Medium" ForeColor="#000066" Text="To:"></asp:Label>
&nbsp;
            <asp:TextBox ID="txtEndDate" runat="server" Font-Names="Arial" 
                Font-Size="Medium" ForeColor="#000066" AutoPostBack="True" TextMode="Date"></asp:TextBox>
            <ajaxToolkit:CalendarExtender ID="txtEndDate_CalendarExtender" runat="server" 
                BehaviorID="txtStartDate_CalendarExtender" TargetControlID="txtEndDate">
            </ajaxToolkit:CalendarExtender>
        </td>
    </tr>
</table>
    <br />
    <br />
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        CellPadding="4" DataKeyNames="FlightNo,FlightDate" 
        DataSourceID="SqlDataSource1" Font-Names="Arial" Font-Size="Medium" 
        ForeColor="#000066" GridLines="None">
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
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
        SelectCommand="SELECT [FlightNo], [FlightDate], [Dairport], [Dtime], [Aairport], [Atime], [Seats] FROM [Flight] WHERE (([FlightDate] &gt;= @FlightDate) AND ([FlightDate] &lt;= @FlightDate2))" DeleteCommand="DELETE FROM [Flight] WHERE [FlightNo] = @FlightNo AND [FlightDate] = @FlightDate" InsertCommand="INSERT INTO [Flight] ([FlightNo], [FlightDate], [Dairport], [Dtime], [Aairport], [Atime], [Seats]) VALUES (@FlightNo, @FlightDate, @Dairport, @Dtime, @Aairport, @Atime, @Seats)" OnSelecting="SqlDataSource1_Selecting" UpdateCommand="UPDATE [Flight] SET [Dairport] = @Dairport, [Dtime] = @Dtime, [Aairport] = @Aairport, [Atime] = @Atime, [Seats] = @Seats WHERE [FlightNo] = @FlightNo AND [FlightDate] = @FlightDate">
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
        <SelectParameters>
            <asp:ControlParameter ControlID="txtStartDate" DbType="Date" Name="FlightDate" PropertyName="Text" />
            <asp:ControlParameter ControlID="txtEndDate" DbType="Date" Name="FlightDate2" PropertyName="Text" />
        </SelectParameters>
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
    <asp:LinkButton ID="LinkButton1" runat="server" Font-Bold="True" Font-Names="Arial Black" Font-Size="Medium" ForeColor="#000066" PostBackUrl="~/addFlights.aspx">Add Flight</asp:LinkButton>
    <br />
    <br />

</asp:Content>

